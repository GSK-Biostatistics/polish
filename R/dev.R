not_yet_implemented <- function(what, issue, error_call = caller_env()) {
  url <- glue("https://github.com/GSK-Biostatistics/polish/issues/{issue}")
  cli_abort(call = error_call, c(
    "{what} is not yet implemented.",
    i = "See {.url {url}} for progress."
  ))
}
