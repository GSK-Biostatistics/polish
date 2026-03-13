test_that("polish_content_word() fails on unknown class", {
  expect_snapshot(error = TRUE,
    polish_content_word(new_object("foo"))
  )
})

test_that("polish_content_word() fails on files with unknown extensions", {
  expect_snapshot(error = TRUE,
    polish_content_word(local_file(".foo"))
  )
})

test_that("polish_content_word.character()", {
  txt <- "   my character value  "
  xml <- polish_content_word(txt)
  expect_equal(length(xml_find_all(xml, "//w:p")), 1L)
  expect_equal(xml_text(xml_find_all(xml, "//w:p/w:r/w:t")), txt)
  expect_equal(length(xml_find_all(xml, "//w:p/w:r/w:rPr")), 0L)

  txt <- c("   my character value  ","char value 2")
  xml <- polish_content_word(txt)
  expect_equal(length(xml_find_all(xml, "//w:p")), 2L)
  expect_equal(xml_text(xml_find_all(xml, "//w:p/w:r/w:t")), txt)
  expect_equal(length(xml_find_all(xml, "//w:p/w:r/w:rPr")), 0L)

  txt <- c("hello", "world")
  expect_warning(
    xml <- polish_content_word(c("hello", "world"), inline = TRUE)
  )
  expect_equal(xml_name(xml), c("r", "r"))
  expect_equal(xml_text(xml_find_all(xml, "//w:r/w:t")), txt)

  txt <- "   my character value  "
  xml <- polish_content_word(txt, font_color = "red", font_size = 12)
  expect_equal(length(xml_find_all(xml, "//w:p")), 1L)
  expect_equal(xml_text(xml_find_all(xml, "//w:p/w:r/w:t")), txt)
  w_rPr <- xml_find_all(xml, "//w:p/w:r/w:rPr")
  expect_equal(length(w_rPr), 1L)
  expect_equal(xml_attr(xml_find_all(w_rPr, "w:sz"), "val"), "12")
  expect_equal(xml_attr(xml_find_all(w_rPr, "w:color"), "val"), "FF0000")


  xml <- polish_content_word(txt, font_typeface = "helvetica", font_size = 12, font_style = c("bold","italic"))
  expect_equal(length(xml_find_all(xml, "//w:p")), 1L)
  expect_equal(xml_text(xml_find_all(xml, "//w:p/w:r/w:t")), txt)
  w_rPr <- xml_find_all(xml, "//w:p/w:r/w:rPr")
  expect_equal(length(w_rPr), 1L)
  expect_equal(xml_attr(xml_find_all(w_rPr, "w:sz"), "val"), "12")
  expect_equal(xml_attr(xml_find_all(w_rPr, "w:rFonts"), "ascii"), "helvetica")
  expect_equal(xml_attr(xml_find_all(w_rPr, "w:rFonts"), "hAnsi"), "helvetica")
  expect_equal(xml_attr(xml_find_all(w_rPr, "w:rFonts"), "cs"), "helvetica")
  expect_equal(xml_name(xml_children(w_rPr)), c("rFonts", "sz", "b", "i"))

  expect_snapshot(error = TRUE,
    polish_content_word("<")
  )
})

test_that("polish_content_word.character() tolerates non empty ...", {
  local_options(polish.dots_error = FALSE)
  expect_no_error(polish_content_word("hello", foo = TRUE))
})

test_that("polish_content_word.data.frame()", {
  expect_snapshot(
    polish_content_word(data.frame(x = 1:2, y = c("hello", "world")))
  )
})

test_that("polish_content_word().numeric", {
  expect_snapshot(
    polish_content_word(42L)
  )
  expect_snapshot(
    polish_content_word(42.5)
  )

  expect_snapshot(
    polish_content_word(c(42L, 43L))
  )
  expect_snapshot(
    polish_content_word(c(42.5, 43.5))
  )
})

test_that("polish_content_word().ggplot", {
  suppressWarnings(withr::local_package("ggplot2"))

  expect_snapshot(transform = transform_polish,
    polish_content_word(ggplot(mtcars))
  )
})
