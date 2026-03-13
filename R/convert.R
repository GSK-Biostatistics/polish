convert_rtf_file_to_png <- function(path, ..., temp_dir = tempfile(), error_call = current_env()){
  check_dots_empty(call = error_call)
  ensure_dir_exists(temp_dir)

  tmp_ref <- file.path(temp_dir, change_extension(path, "html"))

  rmarkdown::pandoc_convert(
    input = normalizePath(path, winslash = "/"),
    output = tmp_ref,
    verbose = FALSE
  )

  convert_html_file_to_png(tmp_ref, temp_dir = temp_dir)
}

convert_html_file_to_png <- function(path, ..., temp_dir = tempfile(), error_call = current_env()){
  check_dots_empty(call = error_call)
  ensure_dir_exists(temp_dir)

  tmp_png <- file.path(temp_dir, change_extension(path, "png"))

  path <- fit_body_to_content(path)

  webshot2::webshot(
    url = paste0("file:///", path),
    file = tmp_png,
    selector = "body",
    quiet = TRUE,
    zoom = 2
  )

  tmp_png
}

convert_pdf_file_to_png <- function(path, ..., temp_dir = tempfile(), error_call = current_env()){
  check_dots_empty(call = error_call)
  ensure_dir_exists(temp_dir)

  tmp_png <- file.path(temp_dir, change_extension(path, "png"))

  suppressMessages({
    image <- magick::image_read_pdf(path)
    converted_image <- magick::image_convert(image, format = "png")
    magick::image_write(converted_image, path = tmp_png)
    gc(verbose = FALSE)
  })

  tmp_png
}

fit_body_to_content <- function(x, temp_dir = tempfile()){
  ensure_dir_exists(temp_dir)

  # make body fit-content
  html_content <- xml2::read_html(as.character(x))

  body <- xml_find_first(html_content,"body")
  xml_attr(body,"style")  <- "width: fit-content;height: fit-content;"

  tmp_html <- tempfile(tmpdir = temp_dir, pattern = file_path_sans_ext(basename(x)), fileext = ".html")
  xml2::write_html(html_content, tmp_html)
  tmp_html
}
