local_file <- function(ext, .local_envir = parent.frame()) {
  file <- tempfile(fileext = ext)
  writeLines("", file)
  withr::local_file(file, .local_envir = .local_envir)
  as_file(file)
}
