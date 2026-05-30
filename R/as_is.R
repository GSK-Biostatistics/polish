#' Mark as a node to inject as is
#'
#' @param x raw ooxml passed through [as_xml_node()]
#'
#' @inheritParams rlang::args_error_context
#'
#' @returns adds the class "as_is" to the input text the content "as is" and not
#'   modify it when polishing
#'
#' @export
as_is <- function(x, error_call = current_env()) {
  add_class(x, "as_is")
}

#' Mark text as markdown
#'
#' @param x text to be interpreted as markdown
#'
#' @returns adds the class "as_ms" to the input text the content "as markdown"
#'   apply markdown formatting to the text when polishing
#'
#' @export
as_md <- function(x) {
  add_class(x, "as_md")
}

add_class <- function(x, class = NULL) {
  class(x) <- c(class, setdiff(class(x), class))
  x
}
