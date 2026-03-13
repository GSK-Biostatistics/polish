#' @param res Plot resolution. Also accepts a string input: "retina" (320),
#'   "print" (300), or "screen" (72). Applies only to raster output types.
#' @rdname polish_content_word
#' @export
polish_content_word.ggplot <- function(x, inline = FALSE, ..., height = 5, width = 6, units = "in", res = 300, error_call = current_env()){
  png <- polish_ggplot(x, height = height, width = width, units = units, dpi = res)
  polish_content_word(png, inline = inline, ..., height = height, width = width, units = "in", error_call = error_call)
}

#' @param width,height,units Plot size in `units` ("in", "cm", "mm", or "px").
#'   defaults to 5 inches tall and 6 inches wide.
#' @param res Plot resolution. Also accepts a string input: "retina" (320),
#'   "print" (300), or "screen" (72). Applies only to raster output types.
#' @rdname polish_content_pptx
#' @export
polish_content_pptx.ggplot <- function(x, ph = "<p:ph/>", pptx, ..., height = 5, width = 6, units = "in", res = 300, error_call = current_env()){
  png <- polish_ggplot(x, height = height, width = width, units = units, dpi = res)
  polish_content_pptx(png, ph = ph, pptx = pptx, ..., height = height, width = width, units = "in", error_call = error_call)
}

polish_ggplot <- function(x, ...) {
  tmp_png <- tempfile(fileext = ".png")
  ggsave(x, filename = tmp_png, ...)
  as_file(tmp_png)
}
