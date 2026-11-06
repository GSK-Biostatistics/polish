test_that("fit_pptx_table_width respects full_width parameter", {
  skip_if_not_installed("gt")
  skip_if_not_installed("xml2")

  # Helper to get fresh table node for each test
  get_tbl_node <- function() {
    df <- data.frame(a = 1:3, b = 4:6, c = 7:9)
    tbl_gt <- gt::gt(df)
    xml_str <- gt_internal("as_pptx_ooxml")(tbl_gt)
    nodes <- gt_internal("read_xml_pptx_nodes")(xml_str)
    nodes[xml2::xml_name(nodes) == "tbl"][[1]]
  }

  # Get one node for calculating natural width
  tbl_node <- get_tbl_node()
  grid_cols <- xml2::xml_find_all(tbl_node, ".//a:gridCol")
  col_widths_emu <- as.numeric(xml2::xml_attr(grid_cols, "w"))
  natural_width <- sum(col_widths_emu) / 914400

  # Test 1: full_width = TRUE scales to placeholder width
  tbl_node <- get_tbl_node()
  placeholder_width <- 9.0
  tbl_copy1 <- as_xml_node(tbl_node)
  result_width_full <- fit_pptx_table_width(tbl_copy1, width = placeholder_width, full_width = TRUE)

  expect_equal(result_width_full, placeholder_width,
    tolerance = 0.01,
    label = "full_width = TRUE should scale to placeholder width"
  )

  # Test 2: full_width = FALSE, but if table is wider, it shrinks the table to match
  tbl_node <- get_tbl_node()
  tbl_copy2 <- as_xml_node(tbl_node)
  before <- as.character(tbl_copy2)
  result_width_shrunk <- fit_pptx_table_width(tbl_copy2, width = 1.0, full_width = FALSE)
  grid_cols_scaled <- xml2::xml_find_all(tbl_copy2, ".//a:gridCol")
  col_widths_scaled <- sum(as.numeric(xml2::xml_attr(grid_cols_scaled, "w")))

  expect_equal(result_width_shrunk, 1.0, tolerance = 0.01,
    label = "full_width = FALDE but wider should scale to placeholder width"
  )
  expect_equal(col_widths_scaled, 1.0 * 914400,
    label = "full_width = FALDE but wider should scale to placeholder width"
  )

  # Test 3: full_width = FALSE keeps natural width when it fits
  tbl_node <- get_tbl_node()
  tbl_copy3 <- as_xml_node(tbl_node)
  wide_placeholder <- 12.0
  result_width_natural <- fit_pptx_table_width(tbl_copy3, width = wide_placeholder, full_width = FALSE)

  expect_equal(result_width_natural, natural_width,
    tolerance = 0.01,
    label = "full_width = FALSE should preserve natural width when it fits in placeholder"
  )

  # Test 4: Verify column proportions are maintained after scaling
  tbl_node <- get_tbl_node()
  tbl_copy4 <- as_xml_node(tbl_node)
  fit_pptx_table_width(tbl_copy4, width = placeholder_width, full_width = TRUE)
  grid_cols_scaled <- xml2::xml_find_all(tbl_copy4, ".//a:gridCol")
  col_widths_scaled <- as.numeric(xml2::xml_attr(grid_cols_scaled, "w"))

  # Calculate proportions before and after
  proportions_original <- col_widths_emu / sum(col_widths_emu)
  proportions_scaled <- col_widths_scaled / sum(col_widths_scaled)

  expect_equal(proportions_scaled, proportions_original,
    tolerance = 0.01,
    label = "Column proportions should be maintained after scaling"
  )
})

test_that("fit_pptx_table_width handles edge cases", {
  skip_if_not_installed("gt")

  # Create a gt table
  df <- data.frame(x = 1)
  tbl_gt <- gt::gt(df)

  xml_str <- gt_internal("as_pptx_ooxml")(tbl_gt)
  nodes <- gt_internal("read_xml_pptx_nodes")(xml_str)
  tbl_node <- nodes[xml2::xml_name(nodes) == "tbl"][[1]]

  # Test: Empty grid columns (fallback to placeholder width)
  tbl_copy <- as_xml_node(tbl_node)
  xml2::xml_remove(xml2::xml_find_all(tbl_copy, ".//a:gridCol"))
  result <- fit_pptx_table_width(tbl_copy, width = 8.0, full_width = FALSE)

  expect_equal(result, 8.0,
    label = "Should default to placeholder width when grid columns are missing"
  )
})

test_that("fit_pptx_table_width respects narrow explicit widths", {
  skip_if_not_installed("gt")

  # Create a table with explicit narrow widths using px()
  mtcars_summary <- mtcars |>
    dplyr::group_by(cyl) |>
    dplyr::summarise(
      Count = dplyr::n(),
      Avg_MPG = round(mean(mpg), 2),
      Avg_HP = round(mean(hp), 2),
      .groups = "drop"
    )

  tbl_gt <- gt::gt(mtcars_summary) |>
    gt::cols_width(
      cyl ~ gt::px(5),
      Count ~ gt::px(5),
      Avg_MPG ~ gt::px(2),
      Avg_HP ~ gt::px(2)
    )

  xml_str <- gt_internal("as_pptx_ooxml")(tbl_gt)
  nodes <- gt_internal("read_xml_pptx_nodes")(xml_str)
  tbl_node <- nodes[xml2::xml_name(nodes) == "tbl"][[1]]

  # Get natural width of this narrow table
  grid_cols <- xml2::xml_find_all(tbl_node, ".//a:gridCol")
  col_widths_emu <- as.numeric(xml2::xml_attr(grid_cols, "w"))
  natural_width <- sum(col_widths_emu) / 914400

  # Verify it's actually narrow (much less than a typical slide)
  expect_lt(natural_width, 1.0,
    label = "Explicitly narrow table should be much less than 1 inch wide"
  )

  # Test: full_width = FALSE preserves the narrow width
  tbl_copy <- as_xml_node(tbl_node)
  placeholder_width <- 9.0
  result_width <- fit_pptx_table_width(tbl_copy, width = placeholder_width, full_width = FALSE)

  expect_equal(result_width, natural_width,
    tolerance = 0.01,
    label = "full_width = FALSE should preserve explicit narrow column widths"
  )

  # Test: full_width = TRUE expands the narrow table to fill placeholder
  tbl_copy2 <- as_xml_node(tbl_node)
  result_width_full <- fit_pptx_table_width(tbl_copy2, width = placeholder_width, full_width = TRUE)

  expect_equal(result_width_full, placeholder_width,
    tolerance = 0.01,
    label = "full_width = TRUE should expand even a narrow table to placeholder width"
  )
})
