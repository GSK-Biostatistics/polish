test_that("polish_content_pptx.file_png() only creates one cNvPr", {
  suppressWarnings(withr::local_package("ggplot2"))

  ph <- "<p:nvSpPr><p:cNvPr id=\"c5672246-4915-4812-b4a2-e7de4805bade\" name=\"New Placeholder\"/><p:cNvSpPr><a:spLocks noGrp=\"1\"/></p:cNvSpPr><p:nvPr><p:ph type=\"body\"/></p:nvPr></p:nvSpPr><p:spPr><a:xfrm><a:off x=\"487680\" y=\"480060\"/><a:ext cx=\"7071360\" cy=\"5829300\"/></a:xfrm></p:spPr>"

  ## create png file
  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()
  temp_png <- tempfile(fileext = ".png")
  ggsave(plot = p, filename = temp_png, width = 6, height = 5, units = "in", dpi = 300)
  img_file <- as_file(temp_png)

  xml <- polish_content_pptx(img_file, ph = ph)

  node_cNvPr <- xml2::xml_find_all(xml, ".//p:cNvPr")
  expect_equal(length(node_cNvPr), 1)
  expect_equal(xml2::xml_attr(node_cNvPr, "id"), "c5672246-4915-4812-b4a2-e7de4805bade")
  expect_equal(xml2::xml_attr(node_cNvPr, "name"), "New Placeholder")

  expect_equal(xml_attr(xml_find_all(xml, ".//a:off"), "x"), "487680")
  expect_equal(xml_attr(xml_find_all(xml, ".//a:off"), "y"), "480060")

  expect_equal(xml_attr(xml_find_all(xml, ".//a:ext"), "cx"), "7071360")
  expect_equal(xml_attr(xml_find_all(xml, ".//a:ext"), "cy"), "5829300")
})


test_that("polish_content_pptx.file_png() image_fit", {

  suppressWarnings(withr::local_package("ggplot2"))

  ph <- "<p:nvSpPr><p:cNvPr id=\"c5672246-4915-4812-b4a2-e7de4805bade\" name=\"New Placeholder\"/><p:cNvSpPr><a:spLocks noGrp=\"1\"/></p:cNvSpPr><p:nvPr><p:ph type=\"body\"/></p:nvPr></p:nvSpPr><p:spPr><a:xfrm><a:off x=\"487680\" y=\"480060\"/><a:ext cx=\"7071360\" cy=\"5829300\"/></a:xfrm></p:spPr>"

  ## create png file
  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()
  temp_wide_png <- tempfile(fileext = ".png")
  ggsave(plot = p, filename = temp_wide_png, width = 6, height = 2, units = "in", dpi = 300)
  img_file_wide <- as_file(temp_wide_png)

  temp_tall_png <- tempfile(fileext = ".png")
  ggsave(plot = p, filename = temp_tall_png, width = 2, height = 6, units = "in", dpi = 300)
  img_file_tall <- as_file(temp_tall_png)

  ## scale image, keeping ratio
  xml_scale_wide <- polish_content_pptx(img_file_wide, ph = ph, image_fit = "scale")
  xml_scale_tall <- polish_content_pptx(img_file_tall, ph = ph, image_fit = "scale")

  ## wide, keep x offset and width, move y offset and height
  expect_equal(xml_attr(xml_find_all(xml_scale_wide, ".//a:off"), "x"), "487680")
  expect_equal(xml_attr(xml_find_all(xml_scale_wide, ".//a:off"), "y"), "2216150")
  expect_equal(xml_attr(xml_find_all(xml_scale_wide, ".//a:ext"), "cx"), "7071360")
  expect_equal(xml_attr(xml_find_all(xml_scale_wide, ".//a:ext"), "cy"), "2357120")

  ## tall, keep y offset and height, move x offset and width
  expect_equal(xml_attr(xml_find_all(xml_scale_tall, ".//a:off"), "x"), "3051810")
  expect_equal(xml_attr(xml_find_all(xml_scale_tall, ".//a:off"), "y"), "480060")
  expect_equal(xml_attr(xml_find_all(xml_scale_tall, ".//a:ext"), "cx"), "1943100")
  expect_equal(xml_attr(xml_find_all(xml_scale_tall, ".//a:ext"), "cy"), "5829300")

  ## stretch image to ph

  xml_stretch_wide <- polish_content_pptx(img_file_wide, ph = ph, image_fit = "stretch")
  xml_stretch_tall <- polish_content_pptx(img_file_tall, ph = ph, image_fit = "stretch")

  expect_equal(xml_attr(xml_find_all(xml_stretch_wide, ".//a:off"), "x"), "487680")
  expect_equal(xml_attr(xml_find_all(xml_stretch_wide, ".//a:off"), "y"), "480060")
  expect_equal(xml_attr(xml_find_all(xml_stretch_wide, ".//a:ext"), "cx"), "7071360")
  expect_equal(xml_attr(xml_find_all(xml_stretch_wide, ".//a:ext"), "cy"), "5829300")

  expect_equal(xml_attr(xml_find_all(xml_stretch_tall, ".//a:off"), "x"), "487680")
  expect_equal(xml_attr(xml_find_all(xml_stretch_tall, ".//a:off"), "y"), "480060")
  expect_equal(xml_attr(xml_find_all(xml_stretch_tall, ".//a:ext"), "cx"), "7071360")
  expect_equal(xml_attr(xml_find_all(xml_stretch_tall, ".//a:ext"), "cy"), "5829300")

})
