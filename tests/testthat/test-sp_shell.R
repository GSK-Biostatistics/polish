test_that("sp_shell()", {
  expect_snapshot(sp_shell("<p:ph/>"))

  expect_snapshot(error = TRUE, sp_shell("<ph/>"))
  expect_snapshot(error = TRUE, sp_shell("<ph/"))
})

