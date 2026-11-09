
# word --------------------------------------------------------------------

#' @export
polish_content_word.gt_tbl <- function(x, inline = FALSE, keep_with_next = TRUE, autonum = TRUE, ..., error_call = current_env()) {
  polish_check_dots_empty(call = error_call)

  xml <- gt::as_word(x, keep_with_next = keep_with_next, autonum = autonum)
  as_xml_word(xml, error_call = error_call)
}

#' @export
polish_content_word.gt_group <- function(x, inline = FALSE, keep_with_next = TRUE, autonum = TRUE, ..., error_call = current_env()) {
  polish_check_dots_empty(call = error_call)

  xml_list <- list()
  for(i in 1:nrow(x$gt_tbls)){
    xml <- gt::as_word(repair_gt(grp_pull(x,i)), keep_with_next = keep_with_next, autonum = autonum)
    xml_list[[length(xml_list)+1]] <- xml

    # Add empty line between the tables
    if(i<nrow(x$gt_tbls)){
      xml_list[[length(xml_list)+1]] <- "<w:p/>"
    }
  }
  as_xml_word(xml_list, error_call = error_call)
}

# pptx --------------------------------------------------------------------

#' @param pages For `gt_group` objects, integer indices of the tables to
#'   include. Defaults to all tables. Selected tables are stacked vertically
#'   within the placeholder, each as its own graphic frame.
#'
#' @rdname polish_content_pptx
#'
#' @export
polish_content_pptx.gt_tbl <- function(x, ph = "<p:ph/>", ..., full_width = FALSE, table_style = NULL, pptx = NULL, error_call = current_env()) {
  polish_check_dots_empty(call = error_call)
  gt_tbls_to_pptx(list(x), ph = ph, full_width = full_width, table_style = table_style, pptx = pptx, error_call = error_call)
}

#' @rdname polish_content_pptx
#'
#' @export
polish_content_pptx.gt_group <- function(x, ph = "<p:ph/>", ..., pages = NULL, full_width = FALSE, table_style = NULL, pptx = NULL, error_call = current_env()) {
  polish_check_dots_empty(call = error_call)

  n_tbls <- nrow(x$gt_tbls)
  pages <- pages %||% seq_len(n_tbls)
  if (!is.numeric(pages) || length(pages) == 0 || any(pages < 1 | pages > n_tbls | pages %% 1 != 0 | is.na(pages))) {
    cli_abort(
      "{.arg pages} must be integer indices between 1 and {n_tbls}.",
      i = "Provided: {paste('\'',pages, collapse = ', ')}.",
      call = error_call
    )
  }

  # gt's as_pptx_ooxml() rejects gt_group, so render each table separately
  tbls <- lapply(pages, \(i) grp_pull(x, i))
  gt_tbls_to_pptx(tbls, ph = ph, full_width = full_width, table_style = table_style, pptx = pptx, error_call = error_call)
}

#' @importFrom xml2 xml_set_attr xml_remove xml_find_first xml_attr xml_name xml_find_all
#' @noRd
gt_tbls_to_pptx <- function(tbls, ph, full_width = FALSE, table_style = NULL, pptx = NULL, error_call = current_env()) {
  check_gt_pptx(error_call = error_call)
  check_table_style(table_style, error_call = error_call)

  # get dimensions from the placeholder (ph) if present,
  #  otherwise use default dimensions of 10 x 7.5 inches, and aligned to the top left corner of the slide
  sp_ph <- sp_shell(ph, error_call = error_call)
  if (length(xml_find_all(sp_ph, ".//a:xfrm")) == 1) {
    off <- dim_extract(sp_ph, ".//a:off", c("x", "y"))
    ext <- dim_extract(sp_ph, ".//a:ext", c("cx", "cy"))
    left <- off$x; top <- off$y; width <- ext$cx; height <- ext$cy
  } else {
    left <- 0; top <- 0; width <- 10; height <- 7.5
  }

  cnvpr <- xml_find_first(sp_ph, ".//p:cNvPr")
  ph_id <- xml_attr(cnvpr, "id")
  ph_name <- xml_attr(cnvpr, "name")
  n <- length(tbls)

  as_pptx_ooxml <- gt_internal("as_pptx_ooxml")
  frames <- vector("list", n)
  y <- top
  for (i in seq_len(n)) {
    tbl <- gt_pptx_table_node(as_pptx_ooxml(repair_gt(tbls[[i]])), error_call = error_call)
    tbl_width <- fit_pptx_table_width(tbl, width = width, full_width = full_width)

    if (!is.null(table_style)) {
      xml_remove(xml_find_all(tbl, ".//a:tableStyleId"))
      add_table_style(tbl, table_style, pptx, error_call = error_call)
    }

    id <- if (is.na(ph_id)) as.character(i + 1L) else if (n == 1) ph_id else paste0(ph_id, "-", i)
    name <- if (is.na(ph_name)) paste0("gt table ", i) else if (n == 1) ph_name else paste0(ph_name, " - gt table ", i)

    frames[[i]] <- pptx_graphic_frame(
      tbl,
      left = left + (width - tbl_width) / 2, top = y, width = tbl_width,
      id = id, name = name
    )
    y <- y + pptx_table_height(tbl)
  }

  if (y - top > height) {
    cli_inform(c(
      "Table height is greater than the provided placeholder and may run off the slide.",
      i = "Consider splitting the table across multiple slides."
    ))
  }

  # tableStyleId GUIDs contain braces; disable glue interpolation
  as_xml_pptx(unlist(frames), .open = "\u0001", .close = "\u0002", error_call = error_call)
}

check_gt_pptx <- function(error_call = current_env()) {
  ok <- utils::packageVersion("gt") >= "1.4.0" &&
    all(vapply(c("as_pptx_ooxml", "read_xml_pptx_nodes"), exists, logical(1),
               envir = asNamespace("gt"), inherits = FALSE))
  if (!ok) {
    cli_abort(c(
      "PowerPoint output for {.cls gt_tbl} requires {.pkg gt} >= 1.4.0.",
      i = "Installed version: {utils::packageVersion('gt')}."
    ), call = error_call)
  }
  invisible(TRUE)
}

gt_internal <- function(name) {
  get(name, envir = asNamespace("gt"), inherits = FALSE)
}

#' Upgrade a `gt_tbl` built by an older gt to the current structure
#'
#' Builds a template with the installed gt from a zero-row copy of the input's
#' `_data` (so columns match) and fills in the top-level components and
#' `_options` rows the input lacks. Existing values are never overwritten.
#' @noRd
repair_gt <- function(x) {
  base <- gt::gt(x[["_data"]][0, , drop = FALSE])

  miss <- setdiff(names(base), names(x))
  x[miss] <- base[miss]

  o <- x[["_options"]]
  b <- base[["_options"]]
  x[["_options"]] <- rbind(o, b[!b$parameter %in% o$parameter, ])

  structure(x[names(base)], class = class(base))
}

#' Extract the single `a:tbl` node from gt PowerPoint OOXML
#'
#' gt emits title/subtitle as `a:p` nodes ahead of the table; only the table
#' can live in a graphic frame, so those are dropped.
#' @noRd
gt_pptx_table_node <- function(ooxml, error_call = current_env()) {
  nodes <- gt_internal("read_xml_pptx_nodes")(ooxml)
  tbls <- nodes[xml_name(nodes) == "tbl"]
  if (length(tbls) != 1) {
    cli_abort(
      "Expected a single {.code a:tbl} node from {.pkg gt}, found {length(tbls)}.",
      call = error_call
    )
  }
  tbls[[1]]
}

#' Scale grid columns and `a:tableW` to fit the placeholder width (inches)
#'
#' When `full_width`, scale to fill the placeholder. Otherwise the table is
#' left untouched and gt's natural width is returned (in inches).
#' @noRd
fit_pptx_table_width <- function(tbl, width, full_width = TRUE) {

  grid_cols <- xml_find_all(tbl, ".//a:gridCol")
  col_widths <- as.numeric(xml_attr(grid_cols, "w"))
  natural <- sum(col_widths) / 914400

  ## scale if full_width = TRUE or the table is wider than the placeholder
  ## scale to fill the placeholder width, preserving column proportions
  if (full_width | (natural > width)) {
    
    target <- width
    emu <- round(target * 914400)

    if (length(col_widths) > 0 && sum(col_widths) > 0) {
      scaled <- round(col_widths / sum(col_widths) * emu)
      # absorb rounding drift so columns total the placeholder width
      scaled[length(scaled)] <- emu - sum(scaled[-length(scaled)])
      xml_set_attr(grid_cols, "w", as.character(scaled))
    }
    xml_set_attr(xml_find_first(tbl, ".//a:tableW"), "w", as.character(emu))
    target

  }else{
    ## otherwise didnt specify full_width or the table is fits,
    return(if (length(col_widths) == 0 || natural == 0) width else natural)

  }
}

pptx_table_height <- function(tbl) {
  sum(as.numeric(xml_attr(xml_find_all(tbl, "./a:tr"), "h")), na.rm = TRUE) / 914400
}

pptx_graphic_frame <- function(tbl, left, top, width, id, name) {
  paste0(
    "<p:graphicFrame>",
    "<p:nvGraphicFramePr>",
    "<p:cNvPr id=\"", id, "\" name=\"", htmltools::htmlEscape(name, attribute = TRUE), "\"/>",
    "<p:cNvGraphicFramePr><a:graphicFrameLocks noGrp=\"1\"/></p:cNvGraphicFramePr>",
    "<p:nvPr/>",
    "</p:nvGraphicFramePr>",
    "<p:xfrm>",
    "<a:off x=\"", round(left * 914400), "\" y=\"", round(top * 914400), "\"/>",
    "<a:ext cx=\"", round(width * 914400), "\" cy=\"", round(pptx_table_height(tbl) * 914400), "\"/>",
    "</p:xfrm>",
    "<a:graphic>",
    "<a:graphicData uri=\"http://schemas.openxmlformats.org/drawingml/2006/table\">",
    as.character(tbl),
    "</a:graphicData>",
    "</a:graphic>",
    "</p:graphicFrame>"
  )
}
