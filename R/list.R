list_as_ppt_xml <- function(x,
                            list_type = "none",
                            level = 0,
                            escape = TRUE,
                            collapse = FALSE,
                            font_color = NULL,
                            font_style = NULL,
                            font_size = NULL,
                            font_typeface = NULL,
                            ...,
                            error_call = current_env()){


  map(x,function(x_item){

    if(is_list(x_item)){

      ## allow for nesting lists
      output_content <- list_as_ppt_xml(
          x_item,
          list_type = list_type,
          level = level + 1,
          escape = escape,
          collapse = collapse,
          font_color = font_color,
          font_style = font_style,
          font_size = font_size,
          font_typeface = font_typeface,
          error_call = error_call
      )

    }else{

      if(inherits(x_item,"as_md")){
        output_content <- md_as_ppt_xml(x_item, level = level)
      }else if(inherits(x_item,c("numeric","character"))){

        if(is.numeric(x_item)){
          x_item <- format(x_item)
        }

        run_content <- glue_collapse(
          polish_pptx_strings(
            x_item,
            escape = escape,
            collapse = collapse,
            font_color = font_color,
            font_style = font_style,
            font_size = font_size,
            font_typeface = font_typeface,
            error_call = error_call
          ))

          pPr <- c(
            none = paste0(
              '<a:pPr marL="',
              514350 * (1 + level),
              '" indent="-514350"',
              '/>'
            ),
            ## if bulleted, only start adding pPr if more than 1 level
            unordered = paste0(
              '<a:pPr marL="',
              514350 * (1 + level),
              '" indent="-514350"',
              ifelse(level == 0, "", paste0(' lvl="', level, '"')),
              '><a:buFont typeface="Arial" panose="020B0604020202020204" pitchFamily="34" charset="0"/>',
              '<a:buChar char="\u2022"/></a:pPr>'
              ),
            ## if ordered, start adding lvl if more than 1 layer. set indent and margin-left
            ordered = paste0(
              '<a:pPr marL="',
              514350 * (1 + level),
              '" indent="-514350"',
              ifelse(level == 0, "", paste0(' lvl="', level, '"')),
              '><a:buFont typeface="+mj-lt"/><a:buAutoNum type="arabicPeriod"/></a:pPr>'
            )
          )[[list_type]]

          output_content <- glue('<a:p>{pPr}{run_content}</a:p>')

      }else{
        cli_abort("Cannot polish a list with elements of type {.cls {class(x_item)}}.", call = error_call)
      }

    }


    output_content

  }) |>

    unlist()

}




check_all_list_viable <- function(x, suppress_error = FALSE, error_call = current_env()){

  res_all <- map(x,function(z){

    if(is.list(z)){
      res <- check_all_list_viable(z, suppress_error = TRUE)
    }else{
      res <- is.character(z) | is.numeric(z) & length(z) == 1
    }
    res
  }) |> unlist()

  is_viable <- sum(!res_all) == 0

  if(!is_viable & !suppress_error){
    cli_abort(
      "List objects to be polished can only contain character or numeric values of length 1",
      call = error_call
    )
  }

  invisible(is_viable)

}
