
#' Polish content for Powerpoint
#'
#' @param x object to be polished
#' @param ph placeholder
#' @param pptx The powerpoint presentation.
#' @inheritParams rlang::args_dots_empty
#' @inheritParams rlang::args_error_context
#'
#' @export
polish_content_pptx <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()) {
  UseMethod("polish_content_pptx")
}

#' @export
polish_content_pptx.default <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()) {
  abort_default(x, error_call = error_call)
}

#' @export
polish_content_pptx.file <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()) {
  abort_unknown_extension(x, error_call = error_call)
}

#' @export
polish_content_pptx.as_is <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()) {
  not_yet_implemented("polish_content_pptx(<as_is>)", issue = 2, error_call = error_call)
}

#' @export
polish_content_pptx.as_md <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()) {

  ## convert md content to actual text
  content <- md_as_ppt_xml(x)

  ## Style each paragraph/content
  xml_content <- glue('
    <p:sp>
      {ph}
      <p:txBody>
        <a:bodyPr/>
        <a:lstStyle/>
        {content}
      </p:txBody>
    </p:sp>
  ')

  as_xml_pptx(xml_content, error_call = error_call)
}

#' @param escape Should `x` be escaped with [htmltools::htmlEscape()]
#' @param collapse If `TRUE` a `<a:br w:type="textWrapping" w:clear="all">` element is added between the `<a:r>` nodes
#' @param font_color color of text. Enter as a hex code.
#' @param font_style styling of text, vector including "bold","italic","underline".
#' @param font_size point size of text if different from document default.
#' @param font_typeface typeface of the text to be added if different from document default.
#'
#' @rdname polish_content_pptx
#' @export
polish_content_pptx.character <- function(x, ph = '<p:ph/>', pptx, ..., escape = TRUE, collapse = FALSE, font_color = NULL, font_style = NULL, font_size = NULL, font_typeface = NULL, error_call = current_env()){
  check_dots_empty(call = error_call)

  # polish each string into a <a:r> node
  # potentially separated by <a:br w:type="textWrapping" w:clear="all" />
  content <- glue_collapse(
    polish_pptx_strings(x, escape = escape, collapse = collapse, font_color = font_color, font_style = font_style, font_size = font_size, font_typeface = font_typeface, error_call = error_call)
  )

  xml_content <- glue('
    <p:sp>
      {ph}
      <p:txBody>
        <a:bodyPr/>
        <a:lstStyle/>
        <a:p>{content}</a:p>
      </p:txBody>
    </p:sp>
  ')
  as_xml_pptx(xml_content, error_call = error_call)
}

#' @export
polish_content_pptx.numeric <- function(x, ph = '<p:ph/>', pptx, ..., escape = TRUE, collapse = FALSE, error_call = current_env()) {
  polish_content_pptx(format(x, ...), ph = ph, pptx = pptx, escape = escape, collapse = collapse, ..., error_call = error_call)
}

#' @inheritParams polish_content_pptx.flextable
#' @export
polish_content_pptx.data.frame <- function(x, ph = '<p:ph/>', pptx, ..., table_style = NULL, error_call = current_env()) {
  check_dots_empty(call = error_call)
  ft <- flextable::flextable(x)
  polish_content_pptx(ft, ph = ph, pptx = pptx, ..., table_style = table_style, error_call = error_call)
}


#' @param list_type How to print the list. Options are "none", "unordered" and
#'   "ordered".
#'   - "none" (default) puts contents on new lines and indents lists accordingly.
#'   - "unordered" makes the content bulleted list with indents.
#'   - "ordered" makes a numbered list with intents.
#'
#' @rdname polish_content_pptx
#' @export
polish_content_pptx.list <- function(x, ph = '<p:ph/>', pptx, ..., list_type = c("none","unordered","ordered"), error_call = current_env()){

  list_type <- match.arg(list_type)

  ## check all contents, even nested under another list is a character
  check_all_list_viable(x, error_call = error_call)


  ## convert md content to actual text
  content <- list_as_ppt_xml(x, ..., list_type = list_type, error_call = error_call) |>
    paste0(collapse = "\n")

  xml_content <- glue('
    <p:sp>
      {ph}
      <p:txBody>
        <a:bodyPr/>
        <a:lstStyle/>
        {content}
      </p:txBody>
    </p:sp>
  ')

  as_xml_pptx(xml_content, error_call = error_call)
}


# file_ -------------------------------------------------------------------

#' @param guess_size see [officer::external_img]
#' @rdname polish_content_pptx
#' @export
polish_content_pptx.file_png <- function(x, ph = '<p:ph/>', pptx, ..., height = 5, width = 6, guess_size = FALSE, units = "in", error_call = current_env()) {
  check_dots_empty(call = error_call)

  # wrap ph in a <p:sp> node
  sp_ph      <- sp_shell(ph)

  ext_img <- officer::external_img(x, height = height, width = width, unit = units, guess_size = guess_size)

  if (length(xml_find_all(sp_ph, ".//a:xfrm")) == 1) {
    offsets <- dim_extract(sp_ph, ".//a:off", c("x", "y"))
    top     <- offsets$y
    left    <- offsets$x

    dims    <- dim_extract(sp_ph, ".//a:ext", c("cx", "cy"))
    height  <- dims$cy
    width   <- dims$cx
  } else {
    height <- attr(ext_img, "dims")$height
    width <- attr(ext_img, "dims")$width
    top <- 0
    left <- 0
  }

  # make the <p:pic> node
  xml <- as_xml_pptx(officer::to_pml(
    x      = ext_img,
    top    = top,
    left   = left,
    height = height,
    width  = width,
    add_ns  = TRUE,
    ln      = officer::sp_line(lwd = 0, linecmpd = "sng", lineend = "rnd"),
    ph      = as.character(xml_find_all(sp_ph, "//p:ph"))
  ))

  xml_replace(
    xml_find_all(xml, ".//p:nvPicPr/p:cNvPr"),  # created by to_pml()
    xml_find_all(sp_ph, ".//p:nvSpPr/p:cNvPr")  # given as ph=
  )

  xml
}

#' @export
polish_content_pptx.file_jpeg <- polish_content_pptx.file_png

#' @export
polish_content_pptx.file_svg <- polish_content_pptx.file_png

#' @export
polish_content_pptx.file_txt <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()){
  check_dots_empty(call = error_call)

  not_yet_implemented("polish_content_pptx(<file_text>)", issue = 1, error_call = error_call)
}

#' @export
polish_content_pptx.file_md <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()){
  check_dots_empty(call = error_call)

  polish_content_pptx(as_md(readLines(x)), ph = ph, error_call = error_call)
}

#' @export
polish_content_pptx.file_rtf <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()){
  check_dots_empty(call = error_call)

  png_path <- convert_rtf_file_to_png(x)
  polish_content_pptx(as_file(png_path), ph = ph, guess_size = TRUE, error_call = error_call)
}

#' @export
polish_content_pptx.file_html <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()){
  check_dots_empty(call = error_call)

  polish_content_pptx(
    as_file(convert_html_file_to_png(x)),
    ph = ph, guess_size = TRUE, error_call = error_call
  )
}

#' @export
polish_content_pptx.file_pdf <- function(x, ph = '<p:ph/>', pptx, ..., error_call = current_env()){
  check_dots_empty(call = error_call)

  polish_content_pptx(
    as_file(convert_pdf_file_to_png(x)),
    ph = ph, guess_size = TRUE, error_call = error_call
  )
}


# utils -------------------------------------------------------------------

#' Wrap the placeholder into a <p:sp> shell
#'
#' @param ph placeholder
#' @inheritParams rlang::args_error_context
#'
#' @export
sp_shell <- function(ph, error_call = current_env()){
  xml_content <- glue('<p:sp>{ph}</p:sp>')
  nodes <- suppressWarnings(
    as_xml_pptx(xml_content, error_call = error_call)
  )

  ns <- c(
    'a' = "http://schemas.openxmlformats.org/drawingml/2006/main",
    'r' = "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
    'p' = "http://schemas.openxmlformats.org/presentationml/2006/main"
  )
  names <- xml_children(nodes) |> xml_name(ns = ns)
  if (any(wrong <- !grepl("^p:", names))) {
    pos <- which(wrong)

    bullets <- glue("node {pos} is <{names[pos]}>.")
    names(bullets) <- rep("i", length(bullets))

    cli::cli_abort(c(
      "Nodes must be in the 'p:' namespace.",
      bullets
    ), call = error_call)
  }
  nodes
}

dim_extract <- function(xml, xpath, attrs = c("x, y")) {
  xml <- xml_find_first(xml, xpath)
  out <- purrr::map(attrs, \(name) {
    as.numeric(xml_attr(xml, name)) / 914400
  })
  names(out) <- attrs
  out
}

polish_pptx_strings <- function(txt, escape = TRUE, collapse = FALSE, font_color = NULL, font_style = NULL, font_size = NULL, font_typeface = NULL, error_call = caller_env()) {
  if (escape){
    txt <- htmlEscape(txt)
  }

  a_rPr <- style_text_pptx(font_color, font_style, font_size, font_typeface)

  xml <- glue('
      <a:r>{a_rPr}
      <a:t>{txt}</a:t>
    </a:r>
  ')

  xml <- glue_collapse(xml, sep = if(collapse) '<a:br w:type="textWrapping" w:clear="all"></a:br>' else "")
  as_xml_pptx(xml, error_call = error_call)
}
