#' @param res Plot resolution. Also accepts a string input: "retina" (320),
#'   "print" (300), or "screen" (72). Applies only to raster output types.
#' @rdname polish_content_word
#' @export
polish_content_word.ggplot <- function(x, inline = FALSE, ..., height = 5, width = 6, units = "in", res = 300, error_call = current_env()){
  png <- polish_ggplot(x, height = height, width = width, units = units, dpi = res)
  polish_content_word(png, inline = inline, ..., height = height, width = width, units = "in", error_call = error_call)
}

#' @param width,height defaults to match the height and width of the placeholder
#'   provided. When that cannot be derived, it assumes the plot should be 5
#'   inches tall and 6 inches wide. Users may set the width and height, but they
#'   most both be set.
#' @param res Plot resolution. Also accepts a string input: "retina" (320),
#'   "print" (300), or "screen" (72). Applies only to raster output types.
#' @param device what graphic device to use when saving the plot. Can be one of
#'   "png","svg", or "jpeg".
#'
#' @param scale Multiplicative scaling factor.
#' @rdname polish_content_pptx
#' @export
polish_content_pptx.ggplot <- function(x, ph = "<p:ph/>", pptx, ..., height = NULL, width = NULL, res = 300, device = c("png","svg","jpeg"), scale = 1, error_call = current_env()){

  ## get width and height of placeholder if not set
  if(is.null(height) & is.null(width)){

    # wrap ph in a <p:sp> node
    sp_ph      <- sp_shell(ph)

    if (length(xml_find_all(sp_ph, ".//a:xfrm")) == 1) {
      ## gives dimensions of the placehlder in inches
      dims    <- dim_extract(sp_ph, ".//a:ext", c("cx", "cy"))
      height  <- dims$cy
      width   <- dims$cx
      image_fit <- "stretch"
    }else{
      height <- 5
      width  <- 6
      image_fit <- "scale"
    }
  }else{

    invalid_dims <- is.null(height) | is.null(width)
    if(!is.null(width) & !invalid_dims){
      invalid_dims <- !is.numeric(width) | (length(width) > 1) | isTRUE(width <= 0)
    }
    if(!is.null(height) & !invalid_dims){
      invalid_dims <- !is.numeric(height) | (length(height) > 1) | isTRUE(height <= 0)
    }

    if(invalid_dims){

      width_value <- width_value %||% "NULL"
      height_value <- height %||% "NULL"

      cli_abort(c(
        "{.arg height} and {.arg width} must both be set if defining the plot size, and be positive numeric values.",
        i="You've supplied for {.arg height} a {.cls {class(height)}} vector with value {.val {height_value}}.",
        i="You've supplied for {.arg width} a {.cls {class(width)}} vector with value {.val {width_value}}."
      ), call = error_call)
    }

    image_fit <- "scale"
  }

  png <- polish_ggplot(x, device = device, height = height, width = width, units = "in", dpi = res, scale = scale)
  polish_content_pptx(png, ph = ph, pptx = pptx, ..., height = height, width = width, units = "in", image_fit = image_fit, error_call = error_call)
}

polish_ggplot <- function(x, device = c("png","svg","jpeg"), ...) {
  device <- match.arg(device)
  tmp_img <- tempfile(fileext = paste0(".", device))
  ggsave(x, filename = tmp_img, device = device, ...)
  as_file(tmp_img)
}
