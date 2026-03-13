#' Convert to xml nodes
#'
#' @param x an object to convert to xml nodes
#' @param ns word or pptx
#' @inheritParams rlang::args_dots_empty
#' @inheritParams rlang::args_error_context
#' @param .envir,.open,.close forwarded to [glue::glue()]
#'
#' @return an `xml_nodeset`
#'
#' @export
as_xml_nodeset <- function(x, ns = c("word", "pptx"), ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  UseMethod("as_xml_nodeset")
}

#' @export
as_xml_nodeset.character <- function(x, ns = c("word", "pptx"), ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  check_dots_empty(call = error_call)

  ns <- xml_nodeset_ns(ns, error_call = error_call)
  x <- glue_collapse(x)
  x <- glue("<polish-wrapper-node {ns}>{x}</polish-wrapper-node>")
  x <- tryCatch(
    glue(x, .envir = .envir, .open = .open, .close = .close),
    error = function(e) {
      x
    }
  )
  xml <- withCallingHandlers(
    suppressWarnings(read_xml(unclass(x))),
    error = function(err) {
      cli_abort(call = error_call, parent = err, c(
        "Invalid xml"
      ))
    }
  )
  children <- xml_children(xml)
  if (length(children) == 0L) {
    cli_abort(c(
      "{.arg x} must be an xml node."
    ), call = error_call)
  }
  add_class(children, "polish_xml_nodeset")
}

#' @export
as_xml_nodeset.glue <- function(x, ns = c("word", "pptx"), ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  NextMethod()
}

#' @export
as_xml_nodeset.list <- function(x, ns = c("word", "pptx"), ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  n <- length(x)
  if (n == 0) {
    cli_abort(c(
      "{.arg x} must have at least one element"
    ), call = error_call)
  }
  nodes <- map(x, as_xml_nodeset, ns = ns, ..., .envir = .envir, .open = .open, .close = .close, error_call = error_call)
  classes <- class(nodes[[1L]])
  if (n > 1L) {
    for (i in seq(2, n)) {
      nodes[[1]] <- append(nodes[[1]], nodes[[i]])
    }
  }
  class(nodes[[1]]) <- classes
  nodes[[1]]
}

#' xml namespaces
#'
#' @param ns word or pptx
#' @inheritParams rlang::args_error_context
#'
#' @return xml namespaces for word or pptx
#' @export
xml_nodeset_ns_spec <- function(ns = c("word", "pptx"), error_call = caller_env()) {
  ns <- arg_match(ns, error_call = error_call)
  switch(ns,
    word = c(
      'w'  = "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
      'wp' = "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
      'r'  = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    ),
    pptx = c(
      'a' = "http://schemas.openxmlformats.org/drawingml/2006/main",
      'r' = "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
      'p' = "http://schemas.openxmlformats.org/presentationml/2006/main",
      'w' = "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
      'custom' = "urn:schemas-microsoft-com:office:custom-properties"
    )
  )
}

xml_nodeset_ns <- function(ns = c("word", "pptx"), error_call = caller_env()) {
  ns_spec <- xml_nodeset_ns_spec(ns = ns, error_call = error_call)
  glue_collapse(glue('xmlns:{names(ns_spec)}="{ns_spec}"'), sep = " ")
}

xml_name_pptx <- function(x) {
  xml_name(x, ns = xml_nodeset_ns_spec("pptx"))
}

xml_name_word <- function(x) {
  xml_name(x, ns = xml_nodeset_ns_spec("word"))
}

#' @export
as_xml_nodeset.xml_nodeset <- function(x, ns = c("word", "pptx"), ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  check_dots_empty(call = error_call)
  add_class(x, "polish_xml_nodeset")
}

#' @export
as_xml_nodeset.xml_node <- function(x, ns = c("word", "pptx"), ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  check_dots_empty(call = error_call)

  structure(list(x), class = c("polish_xml_nodeset", "xml_nodeset"))
}

#' @rdname as_xml_nodeset
#' @export
as_xml_node <- function(x, ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  nodeset <- as_xml_nodeset(x, ..., .envir = .envir, .open = .open, .close = .close, error_call = error_call)
  if (length(nodeset) != 1L) {
    cli_abort(
      "{.arg x} must be a single xml node",
      call = error_call
    )
  }
  nodeset[[1L]]
}

#' @rdname as_xml_nodeset
#' @export
as_xml_node_word <- function(x, ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  as_xml_node(x, ns = "word", ..., .envir = .envir, .open = .open, .close = .close, error_call = error_call)
}

#' @rdname as_xml_nodeset
#' @export
as_xml_node_pptx <- function(x, ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  as_xml_node(x, ns = "word", ..., .envir = .envir, .open = .open, .close = .close, error_call = error_call)
}

#' @rdname as_xml_nodeset
#' @export
as_xml_word <- function(x, ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  check_dots_empty(call = error_call)
  as_xml_nodeset(x, ns = "word", .envir = .envir, .open = .open, .close = .close, error_call = error_call)
}

#' @rdname as_xml_nodeset
#' @export
as_xml_pptx <- function(x, ..., .envir = parent.frame(), .open = "{", .close = "}", error_call = current_env()) {
  check_dots_empty(call = error_call)
  as_xml_nodeset(x, ns = "pptx", .envir = .envir, .open = .open, .close = .close, error_call = error_call)
}

#' @export
print.polish_xml_nodeset <- function(x, ...) {
  writeLines(as.character(x))
  invisible(x)
}
