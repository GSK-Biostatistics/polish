expect_have_argument <- function(pattern, arg = "error_call") {
  ns <- asNamespace("polish")
  funs <- ls(ns, pattern = pattern)
  purrr::walk(funs, \(fun) {
    f <- get(fun, envir = ns)
    form <- formals(f)
    expect_true(arg %in% names(form), info = glue::glue("{fun}() must take an `{arg}=` argument"))
  })
}
