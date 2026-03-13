test_that("polish_content_word(<data.frame>)", {
  d_f <- data.frame(x = 1:3, y = letters[1:3])

  xml <- as_xml_node(polish_content_word(d_f))
  expect_equal(xml_name_word(xml), "w:tbl")
})

test_that("polish_content_pptx(<data.frame>)", {
  d_f <- data.frame(x = 1:3, y = letters[1:3])

  xml <- as_xml_node(polish_content_pptx(d_f))
  expect_equal(xml_name_pptx(xml), "p:graphicFrame")
})

