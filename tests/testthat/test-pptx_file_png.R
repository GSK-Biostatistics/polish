test_that("polish_content_pptx.file_png() only creates one cNvPr", {
  suppressWarnings(withr::local_package("ggplot2"))

  ph <- "<p:nvSpPr><p:cNvPr id=\"c5672246-4915-4812-b4a2-e7de4805bade\" name=\"New Placeholder\"/><p:cNvSpPr><a:spLocks noGrp=\"1\"/></p:cNvSpPr><p:nvPr><p:ph type=\"body\"/></p:nvPr></p:nvSpPr><p:spPr><a:xfrm><a:off x=\"487680\" y=\"480060\"/><a:ext cx=\"7071360\" cy=\"5829300\"/></a:xfrm></p:spPr>"

  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()
  xml <- polish_content_pptx(p, ph = ph)

  node_cNvPr <- xml2::xml_find_all(xml, ".//p:cNvPr")
  expect_equal(length(node_cNvPr), 1)
  expect_equal(xml2::xml_attr(node_cNvPr, "id"), "c5672246-4915-4812-b4a2-e7de4805bade")
  expect_equal(xml2::xml_attr(node_cNvPr, "name"), "New Placeholder")

  expect_equal(xml_attr(xml_find_all(xml, ".//a:off"), "x"), "487680")
  expect_equal(xml_attr(xml_find_all(xml, ".//a:off"), "y"), "480060")

  expect_equal(xml_attr(xml_find_all(xml, ".//a:ext"), "cx"), "7071360")
  expect_equal(xml_attr(xml_find_all(xml, ".//a:ext"), "cy"), "5829300")
})
