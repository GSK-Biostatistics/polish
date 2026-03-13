
#' @importFrom commonmark markdown_xml
md_as_ppt_xml <- function(x, level = 0){

  content <- read_xml(markdown_xml(x)) |>
    xml_children()

  content_xml <- lapply(
    content,
    function(content_node){
      node_type <- xml_name(content_node)
      apply_format_pptx_xml(node_type,content_node, level = level)
    })

  paste0(unlist(content_xml),collapse = "\n")

}

apply_format_pptx_xml <- function(node, x, ...){

  if(node %in% names(format_pptx_xml)){
    format_pptx_xml[[node]](x, ...)
  }else{
    format_pptx_xml[["missing"]](x, ...)
  }
}

format_pptx_xml <- list(

  missing = function(x, ...){

    content <-xml_children(x)
    lapply(
      content,
      function(content_node){
        node_type <- xml_name(content_node)
        apply_format_pptx_xml(node_type,content_node, ...)
      }) |>
      unlist()
  },

  list = function(x, ..., layer = 0){

    list_type <- xml_attr(x, "type") ## types are "ordered" or "bullet"
    list_items <- x |> xml_children()


    pPr <- c(
      ## if bulleted, only start adding pPr if more than 1 layer
      bullet = ifelse(layer == 0, "", paste0('<a:pPr lvl="', layer, '"/>')),
      ## if ordered, start adding lvl if more than 1 layer. set indent and margin-left
      ordered = paste0(
        '<a:pPr marL="',
        514350 * (1 + layer),
        '" indent="-514350"',
        ifelse(layer == 0, "", paste0(' lvl="', layer, '"')),
        '><a:buFont typeface="+mj-lt"/><a:buAutoNum type="arabicPeriod"/></a:pPr>'
      )
    )[[list_type]]

    lapply(
      list_items,
      function(item_node){
        content <-xml_children(item_node)
        lapply(
          content,
          function(content_node){
            node_type <- xml_name(content_node)
            apply_format_pptx_xml(node_type,content_node, pPr = pPr, layer = layer + 1)
          })
      }) |>
      unlist()

  },

  paragraph = function(x, ..., pPr = '<a:pPr marL="0" indent="0"><a:buNone/></a:pPr>') {
    paragraph_text <- x |> xml_find_all(".//d1:text")

    run_content <- c()

    for (txt in paragraph_text) {
      style_settings <- NULL
      link_path <- NULL
      image_path <- NULL
      parent_node <- xml2::xml_parent(txt)

      type <- "text"

      while (!identical(parent_node, x)) {
        parent_type <- xml_name(parent_node)
        if(parent_type %in% c("emph","strong")){
          style_settings <- c(style_settings, c(emph = "italic", strong = "bold")[[parent_type]])
        }else if(parent_type == "link"){
          link_path <- xml_attr(parent_node, "destination")
        }else if(parent_type == "image"){
          type <- "image"
          image_path <- xml_attr(parent_node, "destination")
        }
        parent_node <- xml2::xml_parent(parent_node)
      }

      run_content <- c(run_content,
                       apply_format_pptx_xml(
                         type,
                         xml_text(txt),
                         font_style = style_settings,
                         link_path = link_path,
                         image_path = image_path
                         ))

    }

    run_content <- paste0(run_content, collapse = "\n")

    glue('<a:p>{pPr}{run_content}</a:p>')
  },

  text = function(txt, font_style = NULL, link_path = NULL, ...) {
    a_rPr <- ""

    if (length(font_style) > 0 | length(link_path) > 0) {
      font_style_args <- style_xml_pptx(font_style)
      link_node <- ifelse(is.null(link_path),"", glue('<a:hlinkClick r:id=\"{link_path}\"/>'))
      a_rPr <-  glue("<a:rPr {font_style_args}>{link_node}</a:rPr>")
    }

    glue('<a:r>{a_rPr}<a:t>{txt}</a:t></a:r>')
  },


  image = function(txt, ..., image_path = NULL){
    stop("Images cannot be added via markdown formatting because images cannot be inline with text. Use as_file() instead.")
  }
)
