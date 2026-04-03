## defined placeholders
ph_dims_unset <- "<p:nvSpPr><p:cNvPr id=\"c5672246-4915-4812-b4a2-e7de4805bade\" name=\"unset dims Placeholder\"/><p:cNvSpPr><a:spLocks noGrp=\"1\"/></p:cNvSpPr><p:nvPr><p:ph type=\"body\"/></p:nvPr></p:nvSpPr><p:spPr></p:spPr>"
ph_dims_set <- "<p:nvSpPr><p:cNvPr id=\"c5672246-4915-4812-b4a2-e7de4805bade\" name=\"set dims  Placeholder\"/><p:cNvSpPr><a:spLocks noGrp=\"1\"/></p:cNvSpPr><p:nvPr><p:ph type=\"body\"/></p:nvPr></p:nvSpPr><p:spPr><a:xfrm><a:off x=\"487680\" y=\"480060\"/><a:ext cx=\"7071360\" cy=\"5829300\"/></a:xfrm></p:spPr>"

test_that("polish_content_word().ggplot - undefined height and width", {
  suppressWarnings(withr::local_package("ggplot2"))

  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()

  ## provided ph with out set dims/location
  xml_dims_unset <- polish_content_pptx(p, ph = ph_dims_unset)

  expect_equal(xml_attr(xml_find_all(xml_dims_unset, ".//a:off"), "x"), "0")
  expect_equal(xml_attr(xml_find_all(xml_dims_unset, ".//a:off"), "y"), "0")
  expect_equal(xml_attr(xml_find_all(xml_dims_unset, ".//a:ext"), "cx"), "5486400")
  expect_equal(xml_attr(xml_find_all(xml_dims_unset, ".//a:ext"), "cy"), "4572000")

  ## provided ph with set dims/location
  xml_dims_set <- polish_content_pptx(p, ph = ph_dims_set)

  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:off"), "x"), "487680")
  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:off"), "y"), "480060")
  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:ext"), "cx"), "7071360")
  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:ext"), "cy"), "5829300")

})

test_that("polish_content_word().ggplot - defined height and width,", {

  suppressWarnings(withr::local_package("ggplot2"))

  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()

  ## provided ph with out set dims/location
  xml_dims_unset <- polish_content_pptx(p, ph = ph_dims_unset, height = 10, width = 12)

  expect_equal(xml_attr(xml_find_all(xml_dims_unset, ".//a:off"), "x"), "0")
  expect_equal(xml_attr(xml_find_all(xml_dims_unset, ".//a:off"), "y"), "0")
  expect_equal(xml_attr(xml_find_all(xml_dims_unset, ".//a:ext"), "cx"), "10972800")
  expect_equal(xml_attr(xml_find_all(xml_dims_unset, ".//a:ext"), "cy"), "9144000")

  ## provided ph with set dims/location, image dims smaller than ph, image ratio of .83333
  xml_dims_set <- polish_content_pptx(p, ph = ph_dims_set, height = 2, width = 2.4)

  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:off"), "x"), "525780")
  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:off"), "y"), "480060")
  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:ext"), "cx"), "6995160")
  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:ext"), "cy"), "5829300")

  ## provided ph with set dims/location, image dims larger than ph, image ratio of .83333
  xml_dims_set <- polish_content_pptx(p, ph = ph_dims_set, height = 10, width = 12)

  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:off"), "x"), "525780")
  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:off"), "y"), "480060")
  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:ext"), "cx"), "6995160")
  expect_equal(xml_attr(xml_find_all(xml_dims_set, ".//a:ext"), "cy"), "5829300")

})

test_that("polish_content_word().ggplot - partially or incorrectly defined height and width,", {

  suppressWarnings(withr::local_package("ggplot2"))

  p <- ggplot(mtcars, aes(mpg, cyl)) + geom_point()

  expect_snapshot(
    polish_content_pptx(p, ph = ph_dims_unset, height = NA, width = 12),
    error = TRUE
  )

  expect_snapshot(
    polish_content_pptx(p, ph = ph_dims_unset, height = NULL, width = 12),
    error = TRUE
  )

  expect_snapshot(
    polish_content_pptx(p, ph = ph_dims_unset, height = -10, width = 12),
    error = TRUE
  )

  expect_snapshot(
    polish_content_pptx(p, ph = ph_dims_unset, height = c(10,11), width = 12),
    error = TRUE
  )

  expect_snapshot(
    polish_content_pptx(p, ph = ph_dims_unset, height = "invalid", width = 12),
    error = TRUE
  )

})
