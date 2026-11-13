test_that("to_inches() converts units", {
  expect_equal(to_inches(2, "in"), 2)
  expect_equal(to_inches(2.54, "cm"), 1)
  expect_equal(to_inches(25.4, "mm"), 1)
  expect_equal(to_inches(600, "px", res = 300), 2)
  expect_error(to_inches(600, "px", res = "print"), "numeric")
})
