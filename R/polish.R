#' Polish content
#'
#' @param x object to be polished into ooxml
#' @param type output type. Valid values are "word" and "pptx".
#' @param ... additional arguments for methods
#' @param error_class Additional error class.
#' @inheritParams rlang::args_error_context
#'
#' @details depending on `type` either the [polish_content_pptx()] or [polish_content_word()]
#'          function is called.
#'
#' @returns  an object of class "polish_xml_nodeset". Contains XML that is viable Word or PowerPoint OOXML for addition
#'   to Word documents or PowerPoint presentations based on the "type".
#'
#' @export
polish_content <- function(x, type, ..., error_call = current_env(), error_class = NULL) {
  if (missing(type)) {
    cli::cli_abort(
      '{.arg type} must be one of "word" or "pptx", not absent.',
      call = error_call, class = c(error_class, "polish_content_error"))
  }
  type <- arg_match(type, values = c("word", "pptx"), error_call = error_call)

  polished <- withCallingHandlers({
    switch(
      type,
      word = polish_content_word(x, ...),
      pptx = polish_content_pptx(x, ...)
    )
  }, error = function(err) {
      cli_abort(
        "Cannot polish content for {.emph {type}} documents.",
        parent = err,
        call = error_call,
        class = c(error_class, glue("polish_content_{type}_error"), "polish_content_error")
      )
    }
  )

  if (!inherits(polished, "xml_nodeset")) {
    dispatch <- switch(type,
      word = s3_dispatch(polish_content_word(x, ...)),
      pptx = s3_dispatch(polish_content_pptx(x, ...))
    )
    bullets <- set_names(capture.output(print(dispatch)), " ")

    bullets <- c(
      "Polished content must be an {.cls xml_nodeset} object, not {.obj_type_friendly {polished}}.",
      i = "Check the `polish_content_{type}()` method objects of class {.cls {x}}.",
      bullets
    )

    cli_abort(
      bullets, call = error_call,
      class = c(error_class, "polish_content_{type}_result_error", "polish_content_result_error")
    )
  }

  polished
}

abort_default <- function(x, error_call = caller_env()) {
  cli_abort("No available method for objects of type {.cls {class(x)}}.", call = error_call)
}

abort_unknown_extension <- function(x, error_call = caller_env()) {
  ext <- file_extension(x)
  cli_abort("No available method for `.{ext}` files.", call = error_call)
}
