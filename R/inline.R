wrap_inline <- function(content, inline = FALSE) {
  if (!isTRUE(inline)) {
    content <- glue('<w:p>{content}</w:p>')
  }
  content
}

