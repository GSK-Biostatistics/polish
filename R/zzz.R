#' @import cli
#' @import glue
#' @import rlang
#' @import htmltools
#' @importFrom xml2 read_xml xml_children xml_attrs xml_find_first xml_name xml_child xml_attr xml_attr<- xml_ns xml_find_all xml_replace xml_text
#' @importFrom tools file_ext file_path_sans_ext
#' @importFrom purrr map imap
#' @importFrom ggplot2 ggsave
#' @importFrom gt vec_fmt_markdown as_word grp_pull
#' @importFrom utils getFromNamespace
#' @importFrom flextable flextable
#' @importFrom sloop s3_dispatch
#' @importFrom utils capture.output browseURL
NULL

ns_flextable <- NULL

.onLoad <- function(libname, pkgname) {
  ns_flextable <<- asNamespace("flextable")
}
