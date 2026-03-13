# word --------------------------------------------------------------------

#' @param align alignment of table and caption
#' @param split should table be allowed to split
#' @param topcaption should caption be above or below the table
#' @param keepnext should content be marked for keep next.
#' @rdname polish_content_word
#'
#' @export
polish_content_word.flextable <- function(x, inline = TRUE, ..., align = NULL, split = NULL, topcaption = TRUE, keepnext = NULL, error_call = current_env()) {
  polish_check_dots_empty(call = error_call)
  if (!is.null(align)) {
    x$properties$align <- align
  }
  if (!is.null(split)) {
    x$properties$opts_word$split <- split
  }
  if (!is.null(keepnext)) {
    x$properties$opts_word$keep_with_next <- keepnext
  }

  caption_xml <- NULL
  if (!is.null(x[["caption"]][["value"]])) {
    caption_xml <- ns_flextable$caption_default_docx_openxml(
      x = x,
      keep_with_next = topcaption,
      allow_autonum = TRUE
    )
  }

  tbl_xml <- officer::to_wml(x, add_ns = TRUE)

  xml_content <- paste0(
    if(topcaption & !is.null(caption_xml)){caption_xml},
    tbl_xml,
    if(!topcaption & !is.null(caption_xml)){caption_xml}
  )

  as_xml_word(xml_content, error_call = error_call)
}

# pptx --------------------------------------------------------------------

#' @param full_width Logical, used to fit full size of given width
#' @param page_size Number of rows to accommodate in a slide
#' @param table_style Named list with two entries: style and options. style is
#'   the name of table style to apply as a character, options a character vector
#'   of options to apply from the table style, including: "Banded Columns",
#'   "Banded Rows", "First Column", "Header Row", "Last Column", and "Total Row"
#' @param pptx a `pptx_container` object
#'
#' @rdname polish_content_pptx
#'
#' @export
polish_content_pptx.flextable <- function(x, ph = "<p:ph/>", ...,  full_width = FALSE, page_size = NULL, table_style = NULL, pptx = NULL, error_call = current_env()){

  polish_check_dots_empty(call = error_call)
  sp_ph <- sp_shell(ph)

  if (length(xml_find_all(sp_ph, ".//a:xfrm")) == 1) {
    offsets <- dim_extract(sp_ph, ".//a:off", c("x", "y"))
    dims    <- dim_extract(sp_ph, ".//a:ext", c("cx", "cy"))

    width   <- dims$cx
    height  <- dims$cy
    left    <- offsets$x
    top     <- offsets$y
  } else {
    width   <- 1
    height  <- 2
    left    <- 0
    top     <- 0
  }

  x <- autofit_ft(
    x,
    width = width, height = height,
    full_width = full_width, page_size = page_size
  )

  dim <- flextable::flextable_dim(x)

  offset_x <- left
  if (dim$widths > width) {
    cli_inform(c(
      "Table width is greater than the provided placeholder and may run off the slide.",
      i = "Consider splitting the table across multiple slides."
    ), error_call = error_call)
  } else {
    offset_x <- offset_x + (width - dim$widths) / 2
  }

  offset_y <- top
  if (dim$heights > height) {
    cli_inform(c(
      "Table height is greater than the provided placeholder and may run off the slide.",
      i = "Consider splitting the table across multiple slides."
    ), error_call = error_call)
  } else {
    ## center table in placeholder if not taller
    offset_y <- offset_y + (height - dim$heights) / 2
  }

  xml_content <- as_xml_node(ns_flextable$gen_raw_pml(
    x,
    offx = offset_x, offy = offset_y, cx = dim$widths, cy = dim$heights
  ))

  ## Add table style if it exists
  if(!is.null(table_style)){
    add_table_style(xml_content, table_style, pptx)
  }

  xml2::xml_replace(
    xml_find_all(xml_content, ".//p:cNvPr"),
    xml_find_all(as_xml_node(sp_ph), ".//p:cNvPr")
  )

  as_xml_pptx(xml_content, error_call = error_call)
}

#' Resize width and height of a flextable
#'
#' @param x a flextable
#' @param width maximum acceptance width
#' @param height maximum acceptance height
#' @param full_width Logical, used to fit full size of given width
#' @param page_size Number of rows to accommodate in a slide
#'
#' @importFrom flextable dim_pretty width height nrow_part height_all
#' @importFrom dplyr na_if
#'
#' @return Flextable
#'
#' @noRd
autofit_ft <- function(x, width, height, full_width = FALSE, page_size = NULL){
  dist_width <- dim(x)$widths
  x <- flextable::autofit(x)
  w <- flextable::dim_pretty(x)$widths
  h <- flextable::dim_pretty(x)$heights

  ## if any h values are 0, set to the average of non "0" h values
  if(sum(h <= 0, na.rm = TRUE) > 0){
    h[h<=0] <- mean(h[h>0], na.rm = TRUE)
  }

  # [flextable::autofit()] doesn't work properly if you have a spanning header.
  # So, get the width of header apart and the body part separately and compare
  # if any column width is more than expected as defined by `> 1` and replace
  # the width by standard width through [flextable::dim].
  if (nrow_part(x, "header") > 1) {
    w_body <- flextable::dim_pretty(x, part = "body")$widths

    # algorithm is based on trial and error method
    # - ratio is more than 100% then set constant width
    reconsider <- which(floor(pmax(w_body, w)/pmin(w_body, w)) > 1)

    new_w <- purrr::map2_dbl(dist_width, w_body, ~ sum(.x + .y)/2)
    w[reconsider] <-  new_w[reconsider]
  }

  x <- width(x, j = seq_along(w), w)

  if (full_width || sum(w) > width) {
    # fix if width is larger than layout size or req. to fit full width
    w_val <- (w / sum(w)) * width
    x <- width(x, width = w_val)
  } else if (sum(w) < width / 2) {
    # fix if width is smaller than half the size of layout
    w_val <- (w / sum(w)) * width / 2
    x <- width(x, width = w_val)
  }

  # height ---
  h_nrow <- nrow_part(x, "header")
  b_nrow <- nrow_part(x, "body")
  f_nrow <- nrow_part(x, "footer")

  cum_height <- ((h / sum(h)) * height - (0.1925525 / (h_nrow + b_nrow + f_nrow))) |>
    pmax(.2)

  # smallest height adjustment to fit
  body_h_val <- min(c(cum_height[(h_nrow+1):(h_nrow+b_nrow)],h[(h_nrow+1):(h_nrow+b_nrow)]),na.rm = TRUE )
  if(isTRUE(is.infinite(body_h_val))){
    body_h_val <- .37
  }
  x <- flextable::height_all(x, body_h_val, part = "body")

  if(f_nrow > 0){
    footer_h_val <- min(c(cum_height[(h_nrow+b_nrow+1):(h_nrow+b_nrow+f_nrow)],h[(h_nrow+b_nrow+1):(h_nrow+b_nrow+f_nrow)]), na.rm = TRUE)
    if(isTRUE(is.infinite(footer_h_val))){
      footer_h_val <- .37
    }
    x <- flextable::height_all(x, footer_h_val, part = "footer")
  }

  x
}

#' @importFrom xml2 xml_add_child xml_remove xml_find_all
add_table_style <- function(tbl_xml , table_style, pptx = NULL, error_call = current_env()){

  tblPr_node <- xml_find_first(tbl_xml, ".//a:tblPr")

    ## add table specific formatting
  tblPr_node <- add_table_style_settings(tblPr_node, table_style$options)

  if(!is.null(pptx)){

    check_table_style(table_style, error_call = error_call)

    ## add which style to use
    table_style_id_node <- get_table_style_id_node(table_style$style, pptx, error_call = error_call)
    if(!is.null(table_style_id_node)){

      tblPr_node |>
        xml_add_child(table_style_id_node)

      ## remove cell styles to let style override
      tbl_xml |>
        xml_find_all(".//a:tc//a:tcPr") |>
        xml_remove()

      ## remove celltext fills to let style override
      tbl_xml |>
        xml_find_all(".//a:tc//a:rPr//a:solidFill") |>
        xml_remove()

    }
  }

}

check_table_style <- function(x, error_call = current_env()){

  ## Nothing to check if NULL
  if(is.null(x)){
    return()
  }

  not_list <- !is.list(x)
  missing_style <- !"style" %in% names(x)
  missing_options <- !"options" %in% names(x)
  extra_names <- sum(!names(x) %in% c("style","options")) > 0
  extra_options <- FALSE

  if(not_list | (missing_style & missing_options) | extra_names | extra_options){
    cli_abort(c(
      "Argument `table_style` must be a named list with only two(2) named elements for `style` and `options`.",
      i = "`style` must match one of the existing Table Styles in the PowerPoint",
      i = paste0("`options` is a character vector of all the options: ",paste0("`",table_style_settings_key,"`", collapse = ", "))
    ), call = error_call)
  }

}

table_style_settings_key <- c(
  "bandCol" = "Banded Columns",
  "bandRow" = "Banded Rows",
  "firstCol" = "First Column",
  "firstRow"  = "Header Row",
  "lastCol" = "Last Column",
  "lastRow" = "Total Row"
)

add_table_style_settings <- function(tblPr_node, table_styles){

  styles <- names(table_style_settings_key)[table_style_settings_key %in% table_styles]

  for(style in styles){
    xml_attr(tblPr_node,style) <- 1
  }

  tblPr_node

}

#' @importFrom dplyr filter slice
get_table_style_id_node <- function(table_style_name, pptx, error_call = current_env()){

  if(is.null(table_style_name)){
    return(NULL)
  }

  table_style_df <- get_table_styles(pptx)

  style_id_df <- table_style_df |>
    filter(.data$style_name == table_style_name) |>
    slice(1)

  if(nrow(style_id_df)){
    as_xml_node(glue("<a:tableStyleId>{style_id_df[['style_id']]}</a:tableStyleId>"))
  }else{
    cli_abort(c(
      "Invalid Table Style Provided.",
      i = paste0("Viable Table Styles include: ", paste0("`",unique(table_style_df$style_name),"`", collapse = ", ")),
      x = paste0("Invalid Table Style provided: `",table_style_name,"`")
    ), call = error_call)
    return(NULL)
  }

}

#' @importFrom dplyr bind_rows
#' @importFrom tibble tibble
#' @importFrom purrr map
get_table_styles <- function(pptx){

  table_style_list_xml <- read_table_style_file(pptx)

  styles <- xml_find_all(table_style_list_xml, "//a:tblStyle")

  if( length(styles) == 0 ){
    return(data.frame(style_id = character(), style_name = character()))
  }else{
    styles |>
      map(function(x) {
        tibble(style_id = xml_attr(x, "styleId"),
               style_name = xml_attr(x, "styleName"))
      }) |>
      bind_rows()
  }
}

#' @importFrom xml2 read_xml
read_table_style_file <- function(pptx){

  table_style_xml_file <- file.path(pptx$rpptx$package_dir, "ppt/tableStyles.xml")

  if(!file.exists(table_style_xml_file)){
    table_style_list_xml <- read_xml(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <a:tblStyleLst xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
      </a:tblStyleLst>
      ')

  }else{
    table_style_list_xml <- read_xml(table_style_xml_file)
  }

  table_style_list_xml
}
