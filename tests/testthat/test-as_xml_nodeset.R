test_that("as_xml_nodeset() checks it's nodes", {
  expect_equal(xml_name(as_xml_nodeset("<hello />")), "hello")

  expect_snapshot(as_xml_nodeset("hello"), error = TRUE)
  expect_snapshot(as_xml_nodeset("<hello"), error = TRUE)
})

test_that("as_xml_nodeset(character())", {
  nodes <- as_xml_nodeset(c("<hello/>", "<world/>"))
  expect_s3_class(nodes, "polish_xml_nodeset")
  expect_equal(xml_name(nodes), c("hello", "world"))
})

test_that("as_xml_nodeset(list())", {
  content_string <- "<tbl>tblcontent</tbl>"
  content_nodeset <- as_xml_nodeset(content_string)

  nodes <- as_xml_nodeset(list("<hello/>", content_nodeset, "<world/>"))
  expect_s3_class(nodes, "polish_xml_nodeset")
  expect_equal(xml_name(nodes), c("hello", "tbl", "world"))

  nodes <- as_xml_nodeset(list("<hello/>", content_nodeset[[1L]], "<world/>"))
  expect_s3_class(nodes, "polish_xml_nodeset")
  expect_equal(xml_name(nodes), c("hello", "tbl", "world"))
})

test_that("as_xml_nodeset(character()) does glue", {
  who <- "world"
  nodes <- as_xml_nodeset('<hello who = "{who}"/>')
  expect_s3_class(nodes, "polish_xml_nodeset")
  expect_equal(xml_attr(nodes[[1]], "who"), "world")
})

test_that("as_xml_node(character()) does glue", {
  who <- "world"
  node <- as_xml_node('<hello who = "{who}"/>')
  expect_s3_class(node, "xml_node")
  expect_equal(xml_attr(node, "who"), "world")
})

test_that("as_xml_node_word(character()) does glue", {
  who <- "world"
  node <- as_xml_node_word('<hello who = "{who}"/>')
  expect_s3_class(node, "xml_node")
  expect_equal(xml_attr(node, "who"), "world")
})

test_that("as_xml_node_pptx(character()) does glue", {
  who <- "world"
  node <- as_xml_node_pptx('<hello who = "{who}"/>')
  expect_s3_class(node, "xml_node")
  expect_equal(xml_attr(node, "who"), "world")
})
