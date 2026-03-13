
# word --------------------------------------------------------------------

#' @export
polish_content_word.gt_tbl <- function(x, inline = FALSE, keep_with_next = TRUE, ..., error_call = current_env()) {
  polish_check_dots_empty(call = error_call)

  xml <- gt::as_word(x, keep_with_next = keep_with_next)
  as_xml_word(xml, error_call = error_call)
}

#' @export
polish_content_word.gt_group <- function(x, inline = FALSE, keep_with_next = TRUE, ..., error_call = current_env()) {
  polish_check_dots_empty(call = error_call)

  xml_list <- list()
  for(i in 1:nrow(x$gt_tbls)){
    xml <- gt::as_word(grp_pull(x,i), keep_with_next = keep_with_next)
    xml_list[[length(xml_list)+1]] <- xml

    # Add empty line between the tables
    if(i<nrow(x$gt_tbls)){
      xml_list[[length(xml_list)+1]] <- "<w:p/>"
    }
  }
  as_xml_word(xml_list, error_call = error_call)
}
