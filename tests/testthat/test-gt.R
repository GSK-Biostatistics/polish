test_that("polish_content_word(<gt_tbl>", {
  suppressWarnings(withr::local_package("gt"))

  tab <- gt(gtcars) |>
    tab_header(
      title = md("Data listing from **gtcars**"),
      subtitle = md("`gtcars` is an R dataset")
    )

  xml <- polish_content_word(tab)
  expect_equal(
    xml_name_word(xml),
    c("w:p", "w:p", "w:tbl")
  )

  # inline= is just ignored
  xml <- polish_content_word(tab, inline = TRUE)
  expect_equal(
    xml_name_word(xml),
    c("w:p", "w:p", "w:tbl")
  )
})

test_that("polish_content_word(<gt_group>", {
  suppressWarnings(withr::local_package("gt"))

  tab <- gt(gtcars) |>
    tab_header(
      title = md("Data listing from **gtcars**"),
      subtitle = md("`gtcars` is an R dataset")
    )

  tab2 <- gt(gtcars) |>
    tab_header(
      title = md("Data listing from **gtcars** second table"),
      subtitle = md("`gtcars` is an R dataset")
    )

  tab_group <- gt_group(tab, tab2)

  xml <- polish_content_word(tab_group)
  expect_equal(
    xml_name_word(xml),
    c("w:p", "w:p", "w:tbl","w:p","w:p", "w:p", "w:tbl")
  )

  # inline= is just ignored
  xml <- polish_content_word(tab_group, inline = TRUE)
  expect_equal(
    xml_name_word(xml),
    c("w:p", "w:p", "w:tbl", "w:p","w:p", "w:p", "w:tbl")
  )
})
