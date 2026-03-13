test_that("polish_content_word.as_md()", {
  expect_snapshot(
    polish_content_word(as_md("*hello*"))
  )
})


test_that("polish_content_pptx.as_md()", {
  expect_snapshot(
    polish_content_pptx(as_md("*hello*"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("__hello__"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("## hello"))
  )

  ## List markdowns ----
  ### Unordered ----
  expect_snapshot(
    polish_content_pptx(as_md("- hello"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("- hello\n- world!"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("- hello\n- *world*!"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("- hello\n    - world!"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("- hello\n    - *world*!"))
  )

  ### Ordered----
  expect_snapshot(
    polish_content_pptx(as_md("1. hello"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("1. hello\n2. world!"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("1. hello\n2. *world*!"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("1. hello\n    1. world!"))
  )

  expect_snapshot(
    polish_content_pptx(as_md("1. hello\n    1. *world*!"))
  )


  ##  links
  expect_snapshot(
    polish_content_pptx(as_md("markdown is defined at [this website](https://daringfireball.net/projects/markdown/)"))
  )

})

test_that("Expected Errors",{


  ## Image
  expect_snapshot(
    polish_content_pptx(as_md("![subtext](man/figures/logo.png)")),
    error = TRUE
  )

})
