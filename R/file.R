
# as_file() ---------------------------------------------------------------

#' Mark as a file by adding classes
#'
#' @param path file path
#'
#' @return `path` with classes set to `"file"` and `"file_{ext}"` where `ext` is
#'         the file extension
#'
#' @examples
#' tf <- tempfile(fileext = ".txt")
#' writeLines("", tf)
#'
#' as_file(tf)
#'
#' @export
as_file <- function(path) {
  check_file_exists(path)
  ext <- paste0("file_", file_extension(path))

  class(path) <- c(ext, "file")
  path
}

#' @export
print.file <- function(x, ...) {
  cli_text("File {.file {x}}")
}

check_file_exists <- function(path, error_call = caller_env()) {
  if (!file.exists(path)) {
    cli_abort("File {.file {path}} does not exist.", call = error_call)
  }
}

file_extension <- function(path, error_call = caller_env()) {
  ext <- file_ext(path)
  if (identical(ext, "")) {
    cli_abort("File {.file {path}} has no extension.", call = error_call)
  }
  tolower(ext)
}


ensure_dir_exists <- function(dir) {
  if (!dir.exists(dir)){
    dir.create(dir)
  }
}

change_extension <- function(path, extension) {
  prefix <- file_path_sans_ext(basename(path))
  glue("{prefix}.{extension}")
}

