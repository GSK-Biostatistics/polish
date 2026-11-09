gt_ph <- '<p:nvSpPr><p:cNvPr id="7" name="Content"/><p:cNvSpPr><a:spLocks noGrp="1"/></p:cNvSpPr><p:nvPr><p:ph type="body"/></p:nvPr></p:nvSpPr><p:spPr><a:xfrm><a:off x="914400" y="914400"/><a:ext cx="7315200" cy="4572000"/></a:xfrm></p:spPr>'

pptx_ns <- function() xml_nodeset_ns_spec("pptx")

test_that("polish_content_pptx(<gt_tbl>) returns one fitted graphic frame", {
  tab <- gt::gt(data.frame(x = 1:3, y = letters[1:3])) |> gt::tab_header("Title")
  out <- polish_content_pptx(tab, ph = gt_ph, full_width = TRUE)

  expect_length(out, 1)
  expect_equal(xml_name_pptx(out[[1]]), "p:graphicFrame")
  expect_length(xml_find_all(out, ".//a:tbl", pptx_ns()), 1)
  # title paragraph is dropped, not placed inside the frame
  expect_length(xml_find_all(out, "./a:graphic/a:graphicData/a:p", pptx_ns()), 0)

  cols <- as.numeric(xml_attr(xml_find_all(out, ".//a:gridCol", pptx_ns()), "w"))
  expect_equal(sum(cols), 7315200)
  expect_equal(xml_attr(xml_find_first(out, ".//a:tableW", pptx_ns()), "w"), "7315200")
  expect_equal(xml_attr(xml_find_first(out, ".//a:off", pptx_ns()), "x"), "914400")

  cnvpr <- xml_find_first(out, ".//p:cNvPr", pptx_ns())
  expect_equal(xml_attr(cnvpr, "id"), "7")
  expect_equal(xml_attr(cnvpr, "name"), "Content")
})

test_that("polish_content_pptx(<gt_tbl>) full_width mirrors flextable sizing", {
  ns <- pptx_ns()
  frame_w <- function(out) as.numeric(xml_attr(xml_find_first(out, ".//a:ext", ns), "cx"))
  frame_x <- function(out) as.numeric(xml_attr(xml_find_first(out, ".//a:off", ns), "x"))
  base <- gt::gt(data.frame(x = 1:3, y = letters[1:3]))

  # natural width (5in) fits in 8in placeholder: kept and centred
  # does not scale to fill placeholder when full_width = FALSE (default)
  tab <- gt::cols_width(base, everything() ~ gt::px(240))
  out <- polish_content_pptx(tab, ph = gt_ph)
  expect_equal(frame_w(out), 5 * 914400)
  expect_equal(frame_x(out), 914400 + 1.5 * 914400)

  ## scales to fill placeholder when full_width = TRUE
  expect_equal(frame_w(polish_content_pptx(tab, ph = gt_ph, full_width = TRUE)), 7315200)

  # wider than the placeholder: shrunk to fit
  tab <- gt::cols_width(base, everything() ~ gt::px(960))
  ## full_width = FALSE, but shrinks if natural width (10in) exceeds placeholder
  expect_equal(frame_w(polish_content_pptx(tab, ph = gt_ph)), 7315200)
  ## full_width = TRUE shrinks to fit placeholder
  expect_equal(frame_w(polish_content_pptx(tab, ph = gt_ph, full_width = TRUE)), 7315200)
  
})

test_that("polish_content_pptx(<gt_group>) gives one stacked frame per table", {
  grp <- gt::gt_group(
    gt::gt(data.frame(x = 1:2)),
    gt::gt(data.frame(x = 3:5)),
    gt::gt(data.frame(x = 6))
  )
  out <- polish_content_pptx(grp, ph = gt_ph)

  expect_length(out, 3)
  expect_equal(vapply(out, xml_name_pptx, ""), rep("p:graphicFrame", 3))
  ids <- xml_attr(xml_find_all(out, ".//p:cNvPr", pptx_ns()), "id")
  expect_equal(anyDuplicated(ids), 0L)

  ys <- as.numeric(xml_attr(xml_find_all(out, "./p:xfrm/a:off", pptx_ns()), "y"))
  expect_true(all(diff(ys) > 0))

  sub <- polish_content_pptx(grp, ph = gt_ph, pages = c(1, 3))
  expect_length(sub, 2)
  expect_match(as.character(sub[[2]]), ">6<")

  expect_error(polish_content_pptx(grp, pages = 4), "pages")
})

test_that("polish_content_pptx(<gt_tbl>) table_style handling", {

  tab <- gt::gt(data.frame(x = 1:3))

  # gt's own style id is kept by default
  default <- polish_content_pptx(tab)
  expect_length(xml_find_all(default, ".//a:tableStyleId", pptx_ns()), 1)

  styled <- polish_content_pptx(tab, table_style = list(options = "Header Row"))
  expect_length(xml_find_all(styled, ".//a:tableStyleId", pptx_ns()), 0)
  expect_equal(xml_attr(xml_find_first(styled, ".//a:tblPr", pptx_ns()), "firstRow"), "1")

  pptx <- list(rpptx = officer::read_pptx())
  cat(
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <a:tblStyleLst xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
    <a:tblStyle styleId="{291DBC07-340B-ACF5-F4C7-67FE120D59C4}" styleName="New Table Style"/>
    </a:tblStyleLst>',
    file = file.path(pptx$rpptx$package_dir, "ppt/tableStyles.xml")
  )
  styled <- polish_content_pptx(tab, table_style = list(style = "New Table Style"), pptx = pptx)
  expect_equal(
    xml_text(xml_find_all(styled, ".//a:tableStyleId", pptx_ns())),
    "{291DBC07-340B-ACF5-F4C7-67FE120D59C4}"
  )
})

test_that("polished gt content can be written to a pptx", {
  tab <- gt::gt(data.frame(x = 1:3, y = letters[1:3]))
  out <- polish_content_pptx(tab)

  doc <- officer::read_pptx() |>
    officer::add_slide("Title and Content", "Office Theme") |>
    officer::ph_with(officer::block_list(), officer::ph_location_type("body"))
  slide <- doc$slide$get_slide(1)$get()
  sp_tree <- xml_find_first(slide, "//p:spTree")
  xml_add_child(sp_tree, out[[1]])

  path <- withr::local_tempfile(fileext = ".pptx")
  print(doc, target = path)
  expect_length(xml_find_all(officer::read_pptx(path)$slide$get_slide(1)$get(), "//a:tbl"), 1)
})
