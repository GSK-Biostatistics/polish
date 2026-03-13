test_that("polish_content() fails with wrong type", {
  expect_snapshot(error = TRUE, cnd_class = TRUE, polish_content("", type = "xml"))
})

test_that("polish_content() fails on unknown class", {
  foo <- new_object("foo")
  expect_snapshot(error = TRUE, cnd_class = TRUE, polish_content(foo, type = "word"))
  expect_snapshot(error = TRUE, cnd_class = TRUE, polish_content(foo, type = "pptx"))
})

test_that("polish_content(type=) is mandatory", {
  expect_snapshot(error = TRUE, polish_content(42))
})

test_that("polish_content() fails on files with unknown extensions", {
  file <- local_file(".foo")
  expect_snapshot(error = TRUE, cnd_class = TRUE, polish_content(file, type = "word"))
  expect_snapshot(error = TRUE, cnd_class = TRUE, polish_content(file, type = "pptx"))
})

test_that("polish_content() checks that the method returns an xml_nodeset", {
  local_methods(
    polish_content_word.foo = function(x, ..., error_call = current_env()) {
      "not an xml_nodeset"
    },
    polish_content_word.bar = function(x, ..., error_call = current_env()) {
      NextMethod()
    },

    polish_content_pptx.foo = function(x, ph = '<p:ph/>', ..., error_call = current_env()) {
      "not an xml_nodeset"
    },
    polish_content_pptx.bar = function(x, ph = '<p:ph/>', ..., error_call = current_env()) {
      NextMethod()
    }
  )

  foo <- structure(list(), class = "foo")
  bar <- structure(list(), class = c("bar", "foo"))
  expect_snapshot(error = TRUE, polish_content(foo, type = "word"))
  expect_snapshot(error = TRUE, polish_content(bar, type = "word"))

  expect_snapshot(error = TRUE, polish_content(foo, type = "pptx"))
  expect_snapshot(error = TRUE, polish_content(bar, type = "pptx"))
})
