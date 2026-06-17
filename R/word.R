#' Polish content for Word
#'
#' @param x object to be polished
#' @param ... used in some methods
#' @param inline if `FALSE` the comments are wrapped in a `<w:p>`
#' @inheritParams rlang::args_error_context
#' @returns  an object of class "polish_xml_nodeset". Contains XML that is viable Word OOXML for addition to
#'   Word documents.
#' @export
polish_content_word <- function(x, inline = FALSE, ..., error_call = current_env()) {
  UseMethod("polish_content_word")
}

#' @export
polish_content_word.default <- function(x, inline = FALSE, ..., error_call = current_env()) {
  abort_default(x, error_call = error_call)
}

#' @export
polish_content_word.file <- function(x, inline = FALSE, ..., error_call = current_env()) {
  abort_unknown_extension(x, error_call = error_call)
}

#' @inheritParams rlang::args_error_context
#' @rdname polish_content_word
#' @param font_color color of text. Enter as a hex code.
#' @param font_style styling of text, vector including "bold","italic","underline".
#' @param font_size point size of text if different from document default.
#' @param font_typeface typeface of the text to be added if different from document default.
#'
#' @export
polish_content_word.character <- function(x, inline = FALSE, ..., font_color = NULL, font_style = NULL, font_size = NULL, font_typeface = NULL, error_call = current_env()) {
  polish_check_dots_empty(call = error_call)
  inline <- isTRUE(inline)

  if (length(x) > 1 && inline) {
    cli_warn(call = error_call, c(
      "Polishing a vector containing more than one element with {.code inline = TRUE}.",
      i   = "The elements are combined without spaces.",
      i   = "This might lead to unexpected output."
    ))
  }

  font_style_xml <- style_text_word(font_color, font_style, font_size, font_typeface)

  xml_content <- glue('
    <w:r>
      {font_style_xml}
      <w:t xml:space="preserve">{x}</w:t>
    </w:r>
  ')
  xml_content <- wrap_inline(xml_content, inline)
  xml_content <- glue_collapse(xml_content, sep = "\n")
  as_xml_word(xml_content, error_call = error_call)
}

#' @export
polish_content_word.numeric <- function(x, inline = FALSE, ..., error_call = current_env()) {
  polish_content_word(format(x, ...), inline = inline, error_call = error_call)
}

#' @export
polish_content_word.as_is <- function(x, inline = TRUE, ..., valid = c("w:p", "w:tbl"), error_call = current_env()) {
  x <- wrap_inline(x, inline)
  node <- as_xml_word(x, error_call = error_call)

  node_name <- xml_name(node, ns = xml_ns(node))
  if (sum(!node_name %in% valid) > 0) {

    invalid_node_names <- paste(unique(node_name[!node_name %in% valid]),sep = ",")

    valid <- glue_collapse(glue("<{valid}>"), sep = ", ", last = " or ")
    invalid <- glue_collapse(glue("<{invalid_node_names}>"), sep = ", ", last = " or ")

    cli_abort(
      "{.arg x} must be a {.emph {valid}} node, not {.emph {invalid}}.",
      call = error_call
    )
  }

  node
}

#' @export
polish_content_word.as_md <- function(x, inline = TRUE, ..., error_call = current_env()) {
  polish_check_dots_empty(call = error_call)

  x <- wrap_inline(x, inline)
  glue_collapse(x, sep = "\n") |>
    gt::vec_fmt_markdown(output = "word") |>
    as_xml_word(error_call = error_call) |>
    xml_child() |>
    as_xml_word(error_call = error_call)
}

#' @export
polish_content_word.data.frame <- function(x, inline = TRUE, ..., error_call = current_env()) {
  polish_check_dots_empty(call = error_call)

  bt <- officer::block_table(x, header = TRUE, alignment = "center")
  xml <- officer::to_wml(bt, add_ns = TRUE)
  xml <- wrap_inline(xml, inline)
  as_xml_word(xml, error_call = error_call)
}


# file_ -------------------------------------------------------------------

#' @param width,height,units Plot size in `units` ("in", "cm", "mm", or "px").
#'   defaults to 5 inches tall and 6 inches wide.
#' @rdname polish_content_word
#' @export
polish_content_word.file_png <- function(x, inline = FALSE, ..., height = 5, width = 6, units = "in", error_call = current_env()) {
  polish_check_dots_empty(call = error_call)

  ext_img <- officer::external_img(x, height = height, width = width, unit = units)
  xml_content <- officer::to_wml(ext_img, add_ns = TRUE)
  xml_content <- wrap_inline(xml_content, inline)
  as_xml_word(xml_content, error_call = error_call)
}

#' @export
polish_content_word.file_jpeg <- polish_content_word.file_png

#' @export
polish_content_word.file_svg <- polish_content_word.file_png

#' @export
polish_content_word.file_txt <- function(x, inline = FALSE, ..., error_call = current_env()) {
  polish_check_dots_empty(call = error_call)

  x_content <- iconv(readLines(x), to = "UTF-8")
  xml_content <- glue_collapse(
    glue('
    <w:r>
      <w:t>{x_content}</w:t>
    </w:r>
    '),
    sep = '<w:br w:type="textWrapping" w:clear="all"></w:br>'
  )

  xml_content <- wrap_inline(xml_content, inline)
  as_xml_word(xml_content, error_call = error_call)
}

#' @export
polish_content_word.file_md <- function(x, inline = TRUE, ..., error_call = current_env()){
  polish_check_dots_empty(call = error_call)
  polish_content_word(as_md(readLines(x)), error_call = error_call)
}

#' @export
polish_content_word.file_docx <- function(x, inline = TRUE, ..., error_call = current_env()){
  polish_check_dots_empty(call = error_call)

  bt <- officer::block_pour_docx(file = x)
  xml_content <- officer::to_wml(bt, add_ns = TRUE)
  xml_content <- wrap_inline(xml_content, inline)
  as_xml_word(xml_content, error_call = error_call)
}

#' @export
polish_content_word.file_rtf <- function(x, inline = TRUE, ..., error_call = current_env()){
  polish_check_dots_empty(call = error_call)

  path <- normalizePath(x, winslash = "/", mustWork = FALSE)
  xml_content <- glue('<w:altChunk r:id="{path}"/>')
  xml_content <- wrap_inline(xml_content, inline)
  as_xml_word(xml_content, error_call = error_call)
}

#' @export
polish_content_word.file_html <- function(x, inline = TRUE, ..., error_call = current_env()){
  polish_check_dots_empty(call = error_call)

  path <- normalizePath(x, winslash = "/", mustWork = FALSE)
  xml_content <- glue('<w:altChunk r:id="{path}"/>')
  xml_content <- wrap_inline(xml_content, inline)
  as_xml_word(xml_content, error_call = error_call)
}

