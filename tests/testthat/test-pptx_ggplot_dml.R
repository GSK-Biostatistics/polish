ph_dims_unset <- "<p:nvSpPr><p:cNvPr id=\"1\" name=\"unset dims Placeholder\"/><p:cNvSpPr><a:spLocks noGrp=\"1\"/></p:cNvSpPr><p:nvPr><p:ph type=\"body\"/></p:nvPr></p:nvSpPr><p:spPr></p:spPr>"
ph_dims_set <- "<p:nvSpPr><p:cNvPr id=\"1\" name=\"set dims Placeholder\"/><p:cNvSpPr><a:spLocks noGrp=\"1\"/></p:cNvSpPr><p:nvPr><p:ph type=\"body\"/></p:nvPr></p:nvSpPr><p:spPr><a:xfrm><a:off x=\"487680\" y=\"480060\"/><a:ext cx=\"7071360\" cy=\"5829300\"/></a:xfrm></p:spPr>"

grp_xfrm <- function(xml, node, attr) {
  xml_attr(xml_find_first(xml, paste0(".//p:grpSpPr/a:xfrm/a:", node)), attr)
}

test_that("polish_content_pptx().ggplot - dml device, undefined placeholder dims", {
  skip_if_not_installed("rvg")
  suppressWarnings(withr::local_package("ggplot2"))

  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()
  xml <- polish_content_pptx(p, ph = ph_dims_unset, device = "dml")

  expect_s3_class(xml, "polish_xml_nodeset")
  expect_equal(xml_name(xml), "grpSp")
  expect_equal(grp_xfrm(xml, "off", "x"), "0")
  expect_equal(grp_xfrm(xml, "off", "y"), "0")
  expect_equal(grp_xfrm(xml, "ext", "cx"), "5486400")
  expect_equal(grp_xfrm(xml, "ext", "cy"), "4572000")
})

test_that("polish_content_pptx().ggplot - dml device, placeholder dims stretch", {
  skip_if_not_installed("rvg")
  suppressWarnings(withr::local_package("ggplot2"))

  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()
  xml <- polish_content_pptx(p, ph = ph_dims_set, device = "dml")

  expect_equal(grp_xfrm(xml, "off", "x"), "487680")
  expect_equal(grp_xfrm(xml, "off", "y"), "480060")
  expect_equal(grp_xfrm(xml, "ext", "cx"), "7071360")
  expect_equal(grp_xfrm(xml, "ext", "cy"), "5829300")
})

test_that("polish_content_pptx().ggplot - dml device, set height and width scale into placeholder", {
  skip_if_not_installed("rvg")
  suppressWarnings(withr::local_package("ggplot2"))

  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()
  xml <- polish_content_pptx(p, ph = ph_dims_set, height = 2, width = 4, device = "dml")

  # 2:4 aspect ratio is kept: full placeholder width, vertically centred
  expect_equal(grp_xfrm(xml, "ext", "cx"), "7071360")
  expect_equal(grp_xfrm(xml, "ext", "cy"), "3535680")
  expect_equal(grp_xfrm(xml, "off", "x"), "487680")
  expect_equal(grp_xfrm(xml, "off", "y"), as.character(480060 + (5829300 - 3535680) / 2))
})

test_that("polish_content_pptx().ggplot - invalid device errors", {
  suppressWarnings(withr::local_package("ggplot2"))

  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()
  expect_error(polish_content_pptx(p, ph = ph_dims_unset, device = "bmp"))
})

test_that("polish_ggplot() - dml returns a file_dml", {
  skip_if_not_installed("rvg")
  suppressWarnings(withr::local_package("ggplot2"))

  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()
  out <- polish_ggplot(p, device = "dml", width = 6, height = 5, units = "in")

  expect_s3_class(out, "file_dml")
  expect_true(file.exists(out))
})
