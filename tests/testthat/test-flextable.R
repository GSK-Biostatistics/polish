test_that("polish_content_word(<flextable>)", {
  ft <- flextable::flextable(data.frame(x = 1:3, y = letters[1:3]))

  xml <- as_xml_node(polish_content_word(ft, inline = TRUE))
  expect_equal(xml_name_word(xml), "w:tbl")

  xml <- as_xml_node(polish_content_word(ft, inline = FALSE))
  expect_equal(xml_name_word(xml), "w:tbl")
})

test_that("polish_content_pptx(<flextable>)", {
  ft <- flextable::flextable(data.frame(x = 1:3, y = letters[1:3]))
  polished_ft <- polish_content_pptx(ft)

  expect_equal(xml_name_pptx(as_xml_node(polished_ft)), "p:graphicFrame")

  expect_snapshot(
    transform = transform_polish,
    polished_ft
  )

})

test_that("polish_content_pptx(<flextable>) keeps ph info", {
  ft <- flextable::flextable(data.frame(x = 1:3, y = letters[1:3]))

  ph <- '<p:nvSpPr><p:cNvPr id="c5672246-4915-4812-b4a2-e7de4805bade" name="New Placeholder"/><p:cNvSpPr><a:spLocks noGrp="1"/></p:cNvSpPr><p:nvPr><p:ph type="body"/></p:nvPr></p:nvSpPr><p:spPr><a:xfrm><a:off x="487680" y="480060"/><a:ext cx="7071360" cy="5829300"/></a:xfrm></p:spPr>'
  polished_ft <- polish_content_pptx(ft, ph = ph)

  expect_equal(xml_name_pptx(as_xml_node(polished_ft)), "p:graphicFrame")
  expect_equal(xml_attr(xml_find_all(polished_ft, ".//p:cNvPr"), "id"), "c5672246-4915-4812-b4a2-e7de4805bade")
  expect_equal(xml_attr(xml_find_all(polished_ft, ".//p:cNvPr"), "name"), "New Placeholder")
})

test_that("polish_content_pptx(<flextable>) applied table styling id", {

  ft <- flextable::flextable(data.frame(x = 1:3, y = letters[1:3]))

  ## define a basic table style in the pptx
  pptx <- list(rpptx = officer::read_pptx())
  cat(
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <a:tblStyleLst xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
      <a:tblStyle styleId="{291DBC07-340B-ACF5-F4C7-67FE120D59C4}" styleName="New Table Style"/>
      </a:tblStyleLst>
      ',
    file = file.path(pptx$rpptx$package_dir, "ppt/tableStyles.xml")
  )

  polished_ft <- polish_content_pptx(ft, table_style = list(style = "New Table Style"), pptx = pptx)

  expect_equal(xml_name_pptx(as_xml_node(polished_ft)), "p:graphicFrame")
  expect_equal(as_xml_node(polished_ft) |> xml_find_all(".//a:tblPr") |> as.character(),
               "<a:tblPr>\n  <a:tableStyleId>{291DBC07-340B-ACF5-F4C7-67FE120D59C4}</a:tableStyleId>\n</a:tblPr>")

  expect_snapshot(
    transform = transform_polish,
    polished_ft
  )

  ## test invalid style
  expect_error(
    polish_content_pptx(ft, table_style = list(style = "Invalid Style"), pptx = pptx),
    "Invalid Table Style Provided"
  )

})

test_that("polish_content_pptx(<flextable>) applied table styling option", {

  ft <- flextable::flextable(data.frame(x = 1:3, y = letters[1:3]))
  polished_ft <- polish_content_pptx(ft, table_style = list(options = "Header Row"))

  expect_equal(xml_name_pptx(as_xml_node(polished_ft)), "p:graphicFrame")
  expect_equal(as_xml_node(polished_ft) |> xml_find_all(".//a:tblPr") |> as.character(), "<a:tblPr firstRow=\"1\"/>")

  expect_snapshot(
    transform = transform_polish,
    polished_ft
  )

  ## invalid option does not prevent running still
  expect_snapshot(
    transform = transform_polish,
    polish_content_pptx(ft, table_style = list(options = "Invalid Option"))
  )

})

test_that("polish_content_pptx(<flextable>) for tables with empty rows", {

  ft <- flextable::flextable(data.frame(x = c(1:3,"",5), y = c(letters[1:3],"",letters[5]))) |>
    flextable::padding( padding.left = 1, padding.right = 1, padding.top = 0, padding.bottom = 0, part = "all")

  polished_ft <- polish_content_pptx(ft)

  expect_equal(xml_name_pptx(as_xml_node(polished_ft)), "p:graphicFrame")

  expect_snapshot(
    transform = transform_polish,
    polished_ft
  )

})
