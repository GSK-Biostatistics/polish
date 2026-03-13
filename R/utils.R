#' Check ... empty
#'
#' Wrapper around [rlang::check_dots_empty()] that only does the check
#' if the `polish.dots_error` is set to TRUE
#'
#' @inheritParams rlang::check_dots_empty
polish_check_dots_empty <- function(env = caller_env(), error = NULL, call = caller_env()) {
  if (isTRUE(getOption("polish.dots_error"))) {
    check_dots_empty(env = env, error = error, call = call)
  }
}
