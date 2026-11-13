ph_offsets <- list(left = 1, top = 1)
ph_dims <- list(width = 6, height = 4)

test_that("scale_down keeps original size, centered, when image is smaller", {
  img <- list(dims = list(width = 2, height = 1))
  out <- image_fit_scale_down(img, ph_offsets, ph_dims)

  expect_equal(out$dims, list(height = 1, width = 2))
  expect_equal(out$offset, list(top = 2.5, left = 3))
})

test_that("scale_down scales larger images keeping aspect ratio", {
  img <- list(dims = list(width = 12, height = 4))
  out <- image_fit_scale_down(img, ph_offsets, ph_dims)

  expect_equal(out$dims, list(height = 2, width = 6))
  expect_equal(out$offset, list(top = 2, left = 1))
})

test_that("scale_down scales when only one dimension is too large", {
  img <- list(dims = list(width = 3, height = 8))
  out <- image_fit_scale_down(img, ph_offsets, ph_dims)

  expect_equal(out$dims, list(height = 4, width = 1.5))
  expect_equal(out$offset, list(top = 1, left = 3.25))
})

test_that("image_fit accepts 'scale_down'", {
  expect_no_error(
    match.arg("scale_down", c("stretch", "scale", "scale_down"))
  )
})
