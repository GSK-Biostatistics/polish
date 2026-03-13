style_text_word <- function(font_color = NULL, font_style = NULL, font_size = NULL, font_typeface = NULL){

  if (is.null(font_color) && is.null(font_style) && is.null(font_size) && is.null(font_typeface)) {
    return("")
  }

  typeface <- font_typeface_word(font_typeface)
  size     <- font_size_word(font_size)
  style    <- style_xml_word(font_style)
  color    <- font_color_xml_word(font_color)

  glue("<w:rPr>{typeface}{size}{style}{color}</w:rPr>")

}

style_text_pptx <- function(font_color = NULL, font_style = NULL, font_size = NULL, font_typeface = NULL){

  if (is.null(font_color) && is.null(font_style) && is.null(font_size) && is.null(font_typeface)) {
    return("")
  }

  font_typeface_xml <- font_typeface_xml_pptx(font_typeface)
  font_point_args   <- font_point_xml_pptx(font_size)
  font_style_args   <- style_xml_pptx(font_style)
  font_color_xml    <- font_color_xml_pptx(font_color)

  glue("
    <a:rPr {font_point_args} {font_style_args}>
       {font_color_xml}
       {font_typeface_xml}
    </a:rPr>
  ")

}


# typeface and size -------------------------------------------------------

font_typeface_word <- function(font_typeface = NULL) {
  if (is.null(font_typeface)) {
    return("")
  }

  glue('<w:rFonts w:ascii="{font_typeface}" w:hAnsi="{font_typeface}" w:cs="{font_typeface}"/>')
}

font_size_word <- function(font_size = NULL) {
  if (is.null(font_size)) {
    return("")
  }

  glue('<w:sz w:val="{font_size}"/>')
}

font_typeface_xml_pptx <- function(font_typeface = NULL){
  xml <- ""
  if (!is.null(font_typeface)) {
    xml <- glue('<a:latin typeface="{font_typeface}"/>')
  }
  xml
}

font_point_xml_pptx <- function(font_size = NULL){
  if (is.null(font_size)) {
    return("")
  }

  if (font_size <= 200) {
    font_size <- font_size * 100
  }
  glue('sz = "{font_size}"')
}

# style -------------------------------------------------------

style_xml_word <- function(font_style = c("bold", "italic", "underline")){
  if (is.null(font_style)) {
    return("")
  }

  style <- rlang::arg_match(font_style, multiple = TRUE)
  code  <- purrr::map_chr(docx_style_codes[style], "code")

  w <- paste0('<w:', code, '/>')
  glue_collapse(w)
}

style_xml_pptx <- function(font_style){
  if (is.null(font_style)) {
    return("")
  }

  style <- rlang::arg_match(font_style, names(docx_style_codes), multiple = TRUE)

  code  <- purrr::map_chr(docx_style_codes[style], "code")
  value <- purrr::map_chr(docx_style_codes[style], "value")

  args <- glue('{code} = "{value}"')
  glue_collapse(args, " ")
}

docx_style_codes <- list(
  bold      = list(code = "b", value = "1"),
  italic    = list(code = "i", value = "1"),
  underline = list(code = "u", value = "sng")
)

# color -------------------------------------------------------

font_color_xml_word <- function(font_color){
  if (is.null(font_color)) {
    return("")
  }

  hex <- as_hex_codes(font_color)
  glue('<w:color w:val="{hex}"/>')
}

font_color_xml_pptx <- function(font_color){
  if (is.null(font_color)) {
    return("")
  }

  hex <- as_hex_codes(font_color)
  glue('<a:solidFill><a:srgbClr val="{hex}"/></a:solidFill>')
}

#' @importFrom grDevices col2rgb rgb
as_hex_codes <- function(x) {

  tryCatch({
    ## if hex already, return the hex
    if (grepl("^(#)", x) || grepl("^(#)*[0-9A-Fa-f]{6}$", x, perl = TRUE)) {
      x <- toupper(x)
    } else {
      font_colors <- col2rgb(x)
      x <- rgb(font_colors[1], font_colors[2], font_colors[3], maxColorValue = 255)
    }

    gsub("^(#)","",x)
  }, error = function(e) {
    # TODO: should this be an informative error ?
    ""
  })

}

