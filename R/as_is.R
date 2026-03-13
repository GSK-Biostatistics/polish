#' Mark as a node to inject as is
#'
#' @param x raw ooxml passed through [as_xml_node()]
#'
#' @inheritParams rlang::args_error_context
#'
#' @export
as_is <- function(x, error_call = current_env()) {
  add_class(x, "as_is")
}

#' Mark text as markdown
#'
#' @param x text to be interpreted as markdown
#' @export
as_md <- function(x) {
  add_class(x, "as_md")
}

add_class <- function(x, class = NULL) {
  class(x) <- c(class, setdiff(class(x), class))
  x
}
