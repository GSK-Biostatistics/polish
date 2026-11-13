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
#'   "png","svg","jpeg", or "dml". "dml" uses [rvg::dml_pptx()] to produce an
#'   editable vector graphic and requires the rvg package.
#'
#' @param scale Multiplicative scaling factor.
#' @param units Units of `height` and `width`: "in", "cm", "mm", or "px"
#'   ("px" uses `res`). Ignored when the size is taken from the placeholder.
#' @rdname polish_content_pptx
#' @export
polish_content_pptx.ggplot <- function(x, ph = "<p:ph/>", pptx, ..., height = NULL, width = NULL, units = c("in", "cm", "mm", "px"), res = 300, device = c("png","svg","jpeg","dml"), scale = 1, image_fit = NULL, error_call = current_env()){

  units <- match.arg(units)

  ## get width and height of placeholder if not set
  if(is.null(height) & is.null(width)){

    # wrap ph in a <p:sp> node
    sp_ph      <- sp_shell(ph)

    if (length(xml_find_all(sp_ph, ".//a:xfrm")) == 1) {
      ## gives dimensions of the placehlder in inches
      dims    <- dim_extract(sp_ph, ".//a:ext", c("cx", "cy"))
      height  <- dims$cy
      width   <- dims$cx
      image_fit <- image_fit %||% "stretch"
    }else{
      height <- 5
      width  <- 6
      image_fit <- image_fit %||% "scale"
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

      width_value <- width %||% "NULL"
      height_value <- height %||% "NULL"

      cli_abort(c(
        "{.arg height} and {.arg width} must both be set if defining the plot size, and be positive numeric values.",
        i="You've supplied for {.arg height} a {.cls {class(height)}} vector with value {.val {height_value}}.",
        i="You've supplied for {.arg width} a {.cls {class(width)}} vector with value {.val {width_value}}."
      ), call = error_call)
    }

    # downstream functions work in inches
    height <- to_inches(height, units = units, res = res)
    width  <- to_inches(width, units = units, res = res)

    image_fit <- image_fit %||% "scale"
  }

  png <- polish_ggplot(x, device = device, height = height, width = width, units = "in", dpi = res, scale = scale)
  polish_content_pptx(png, ph = ph, pptx = pptx, ..., height = height, width = width, units = "in", image_fit = image_fit, error_call = error_call)
}


to_inches <- function(x, units = c("in", "cm", "mm", "px"), res = 300) {
  units <- match.arg(units)
  if (units == "px" && !is.numeric(res)) {
    cli::cli_abort("{.arg res} must be numeric (pixels per inch) when {.code units = \"px\"}.")
  }
  switch(units, "in" = x, cm = x / 2.54, mm = x / 25.4, px = x / res)
}

polish_ggplot <- function(x, device = c("png","svg","jpeg","dml"), ...) {
  device <- match.arg(device)
  ext <- device
  if (device == "dml") {
    # Position and size are applied by polish_content_pptx.file_dml()
    device <- dml_device
  }
  tmp_img <- tempfile(fileext = paste0(".", ext))
  ggsave(x, filename = tmp_img, device = device, ...)
  as_file(tmp_img)
}

dml_device <- function(file, width, height, ...) {
  rlang::check_installed("rvg", reason = "to use `device = \"dml\"`.")
  rvg::dml_pptx(
    file = file, width = width, height = height, offx = 0, offy = 0,
    id = 0L, last_rel_id = 1L, raster_prefix = tempfile(), standalone = FALSE
  )
}