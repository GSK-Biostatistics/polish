test_that("polish_content() methods have a error_call= argument", {
  expect_have_argument("^polish_content_word[.]", "error_call")
  expect_have_argument("^polish_content_pptx[.]", "error_call")
})

test_that("polish_content_pptx() methods have a ph= argument", {
  expect_have_argument("^polish_content_pptx[.]", "ph")
})

test_that("polish_content_pptx() methods have a pptx= argument", {
  expect_have_argument("^polish_content_pptx[.]", "pptx")
})

test_that("polish_content_word() methods have a inline= argument", {
  expect_have_argument("^polish_content_word[.]", "inline")
})
