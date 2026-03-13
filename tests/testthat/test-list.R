test_that("lists can be converted into bulleted lists - pptx", {

  simple_list <- list("These","are","separate","bullets")
  nested_list <- list("Non indented bullet 1",list("indentet bullet 1","indented bullet 2"),"Non indented bullet 2")

  ## basic list
  expect_snapshot(
    polish_content_pptx.list(simple_list)
  )

  ## basic ordered list
  expect_snapshot(
    polish_content_pptx.list(simple_list, list_type = "ordered")
  )

  ## nested list
  expect_snapshot(
    polish_content_pptx.list(nested_list)
  )

  ## nested ordered list
  expect_snapshot(
    polish_content_pptx.list(nested_list, list_type = "ordered")
  )

})

test_that("lists can be converted into indented text if content is text, numeric, or md - pptx", {

  success_list <- list("These",1,as_md("**hello**"))

  expect_snapshot(
    polish_content_pptx.list(success_list, list_type = "none")
  )

})

test_that("lists can be converted into bulleted lists if content is text, numeric, or md - pptx", {

  success_list <- list("These",1,as_md("**hello**"))

  expect_snapshot(
    polish_content_pptx.list(success_list, list_type = "unordered")
  )

})

test_that("lists can be converted into bulleted lists, apply styling - pptx", {

  simple_list <- list("These","are","separate","bullets")

  ## basic list
  expect_snapshot(
    polish_content_pptx.list(
      simple_list,
      font_color = "blue",
      font_style = "italic",
      font_size = 20
      )
  )

})

test_that("lists cannot be converted into bulleted lists if content is not text, numeric, or md - pptx", {

  expect_snapshot(
    polish_content_pptx.list(list(mtcars)),
    error = TRUE
  )

})


