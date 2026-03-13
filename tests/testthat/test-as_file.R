test_that("as_file() errors ", {
  expect_error(as_file(tempfile()))
  expect_error(local_file())
})

test_that("as_file() set extension specific classes", {
  expect_s3_class(local_file(".txt") , c("file_txt", "file"))
  expect_s3_class(local_file(".docx"), c("file_docx", "file"))
  expect_s3_class(local_file(".pptx"), c("file_pptx", "file"))
})

test_that("polish_content_word(<file_txt>)", {
  tf <- withr::local_tempfile(fileext = ".txt")
  writeLines(c("hello", "world"), con = tf)

  expect_snapshot(
    polish_content_word(as_file(tf), inline = TRUE)
  )

  expect_snapshot(
    polish_content_word(as_file(tf), inline = FALSE)
  )
})

test_that("polish_content_word(<file_md>)", {
  tf <- withr::local_tempfile(fileext = ".md")
  writeLines(c("hello", "*world*"), con = tf)

  expect_snapshot(
    polish_content_word(as_file(tf))
  )
})

test_that("polish_content_word(<file_docx>", {
  suppressWarnings(withr::local_package("officer")) # for print(), read_docx()

  tf <- withr::local_tempfile(fileext = ".docx")
  doc <- read_docx()
  print(doc, tf)

  expect_snapshot(transform = transform_polish,
    polish_content_word(as_file(tf))
  )
})

test_that("polish_content_word(<file_rtf>", {
  tf <- withr::local_tempfile(fileext = ".rtf")
  writeLines(c("hello", "rtf"), tf)

  expect_snapshot(transform = transform_polish,
    polish_content_word(as_file(tf))
  )
})

test_that("polish_content_pptx(<file_txt>)", {
  tf <- withr::local_tempfile(fileext = ".txt")
  writeLines(c("hello", "world"), con = tf)

  expect_snapshot(error = TRUE,
    polish_content_pptx(as_file(tf))
  )
})

test_that("polish_content_pptx(<file_md>)", {
  tf <- withr::local_tempfile(fileext = ".md")
  writeLines(c("hello", "*world*"), con = tf)

  expect_snapshot(
    polish_content_pptx(as_file(tf))
  )

})

test_that("polish_content_pptx(<file_rtf>)", {
  skip_on_ci()

  tf <- withr::local_tempfile(fileext = ".rtf")
  writeLines(c("hello", "rtf"), tf)

  expect_snapshot(transform = transform_polish,
    polish_content_pptx(as_file(tf))
  )
})

test_that("polish_content_pptx(<file_html>)", {
  skip_on_ci()

  tf <- withr::local_tempfile(fileext = ".html")
  writeLines('<html><body>hello</body></html>', tf)

  expect_snapshot(transform = transform_polish,
    polish_content_pptx(as_file(tf))
  )
})
