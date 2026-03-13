test_that("polish_content_pptx() fails on unknown class", {
  expect_snapshot(error = TRUE,
    polish_content_pptx(new_object("foo"))
  )
})

test_that("polish_content_pptx() fails on files with unknown extensions", {
  expect_snapshot(error = TRUE,
    polish_content_pptx(local_file(".foo"))
  )
})

test_that("polish_content_pptx().character", {
  txt <- "hello"
  xml <- polish_content_pptx(txt)
  expect_equal(xml_name(xml), "sp")
  expect_equal(xml_name(xml_children(xml)), c("ph", "txBody"))
  p_txBody <- xml_find_all(xml, "//p:sp/p:txBody")
  expect_equal(xml_name(xml_children(p_txBody)), c("bodyPr", "lstStyle", "p"))
  expect_equal(length(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r")), 1)
  expect_equal(xml_text(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r/a:t")), txt)

  txt <- c("hello", "world")
  xml <- polish_content_pptx(txt)
  expect_equal(xml_name(xml), "sp")
  expect_equal(xml_name(xml_children(xml)), c("ph", "txBody"))
  p_txBody <- xml_find_all(xml, "//p:sp/p:txBody")
  expect_equal(xml_name(xml_children(p_txBody)), c("bodyPr", "lstStyle", "p"))
  expect_equal(xml_name(xml_children(xml_find_all(xml, "//p:sp/p:txBody/a:p"))), c("r", "r"))
  expect_equal(length(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r")), 2)
  expect_equal(xml_text(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r/a:t")), txt)

  xml <- polish_content_pptx(txt, collapse = TRUE)
  expect_equal(xml_name(xml), "sp")
  expect_equal(xml_name(xml_children(xml)), c("ph", "txBody"))
  p_txBody <- xml_find_all(xml, "//p:sp/p:txBody")
  expect_equal(xml_name(xml_children(p_txBody)), c("bodyPr", "lstStyle", "p"))
  expect_equal(xml_name(xml_children(xml_find_all(xml, "//p:sp/p:txBody/a:p"))), c("r", "br", "r"))
  expect_equal(length(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r")), 2)
  expect_equal(xml_text(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r/a:t")), txt)
  br <- xml_find_all(xml, "//p:sp/p:txBody/a:p/a:br")
  expect_equal(xml_attr(br, "type"), "textWrapping")
  expect_equal(xml_attr(br, "clear"), "all")

  txt <- "hello"
  xml <- polish_content_pptx(txt, font_style = c("bold","italic"), font_color = "green")
  expect_equal(xml_name(xml), "sp")
  expect_equal(xml_name(xml_children(xml)), c("ph", "txBody"))
  p_txBody <- xml_find_all(xml, "//p:sp/p:txBody")
  expect_equal(xml_name(xml_children(p_txBody)), c("bodyPr", "lstStyle", "p"))
  expect_equal(length(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r")), 1)
  expect_equal(xml_text(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r/a:t")), txt)
  rPr <- xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r/a:rPr")
  expect_equal(xml_attr(rPr, "b"), "1")
  expect_equal(xml_attr(rPr, "i"), "1")
  srgbClr <- xml_find_all(rPr, "a:solidFill/a:srgbClr")
  expect_equal(xml_attr(srgbClr, "val"), "00FF00")

  txt <- "hello"
  xml <- polish_content_pptx(txt, font_typeface = c("Helvetica"), font_size = 12)
  expect_equal(xml_name(xml), "sp")
  expect_equal(xml_name(xml_children(xml)), c("ph", "txBody"))
  p_txBody <- xml_find_all(xml, "//p:sp/p:txBody")
  expect_equal(xml_name(xml_children(p_txBody)), c("bodyPr", "lstStyle", "p"))
  expect_equal(length(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r")), 1)
  expect_equal(xml_text(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r/a:t")), txt)
  rPr <- xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r/a:rPr")
  expect_equal(xml_attr(rPr, "sz"), "1200")
  expect_equal(xml_attr(xml_find_all(rPr, "a:latin"), "typeface"), "Helvetica")

  xml <- polish_content_pptx("<", escape = TRUE)
  expect_equal(xml_text(xml_find_all(xml, "//p:sp/p:txBody/a:p/a:r/a:t")), "<")

  expect_snapshot(error = TRUE,
    polish_content_pptx("<", escape = FALSE)
  )
})

test_that("polish_content_pptx.data.frame()", {

  expect_snapshot(transform = transform_polish,
    polish_content_pptx(data.frame(x = 1:2, y = c("hello", "world")))
  )

})

test_that("polish_content_pptx().numeric", {
  expect_snapshot(
    polish_content_pptx(42L)
  )
  expect_snapshot(
    polish_content_pptx(42.5)
  )

  expect_snapshot(
    polish_content_pptx(c(42L, 43L))
  )
  expect_snapshot(
    polish_content_pptx(c(42.5, 43.5))
  )
})

test_that("polish_content_word().ggplot", {
  suppressWarnings(withr::local_package("ggplot2"))

  expect_snapshot(transform = transform_polish,
    polish_content_pptx(ggplot(mtcars))
  )
})
