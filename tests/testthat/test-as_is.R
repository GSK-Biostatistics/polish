test_that("as_is()", {
  expect_equal(
    polish_content_word(as_is("<w:p/>")),
    as_xml_word("<w:p/>")
  )
  expect_equal(
    polish_content_word(as_is("<w:tbl/>")),
    as_xml_word("<w:tbl/>")
  )

  expect_equal(
    polish_content_word(as_is("<w:p/><w:p/>")),
    as_xml_word("<w:p/><w:p/>")
  )

  expect_equal(
    polish_content_word(as_is("<w:tbl/><w:p/>")),
    as_xml_word("<w:tbl/><w:p/>")
  )

  expect_snapshot(error = TRUE,
    polish_content_word(as_is("<a/>"))
  )

  expect_snapshot(error = TRUE,
    polish_content_word(as_is("<a"))
  )

  expect_snapshot(error = TRUE,
    polish_content_word(as_is("<a/><w:p/>"))
  )

  expect_snapshot(error = TRUE,
    polish_content_word(as_is("<a/><w:p/><b/>"))
  )
})
