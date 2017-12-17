#' Generate an html file to be included as `in_header` for Rmarkdown documents
#' @param header_file The path to the html header file to be created
#' @inheritParams withSpinner
#' @export
rmd_in_header <- function(header_file="cssloaders_in_header.html", type=getOption("spinner.type",default=1),color=getOption("spinner.color",default="#0275D8"),size=getOption("spinner.size",default=1),color.background=getOption("spinner.color.background")) {
  file.remove(header_file)
  
  .shinycssloaders_headers <- file(header_file,"w"); 
  writeLines("<style>",.shinycssloaders_headers)
  writeLines(readLines(system.file(sprintf("css-loaders/css/load%s.css",type),package="shinycssloaders")),.shinycssloaders_headers)
  writeLines(readLines(system.file("assets/spinner.css",package="shinycssloaders"),warn = FALSE),.shinycssloaders_headers); 
  color.alpha <- sprintf("rgba(%s,0)",paste(grDevices::col2rgb(color),collapse=","))
  
  if (type==1) {
    writeLines(
      glue::glue(".load{type} .loader, .load{type} .loader:before, .load{type} .loader:after {{background: {color}}} .load{type} .loader {{color: {color}}}"),.shinycssloaders_headers
    )
  }
  
  if (type %in% c(2,3) && is.null(color.background)) {
    stop("For spinner types 2 & 3 you need to specify manually a background color. This should match the background color of the container.")
  }
  
  if (type == 2) {
    writeLines(
      glue::glue(".load{type} .loader {{color: {color}}} .load{type} .loader:before, .load{type} .loader:after {{background: {color.background};}}"),.shinycssloaders_headers
    )
  }
  
  if (type == 3) {
    writeLines(
      glue::glue(
        ".load{type} .loader {{
        background: -moz-linear-gradient(left, {color} 10%, {color.alpha} 42%);
        background: -webkit-linear-gradient(left, {color} 10%, {color.alpha} 42%);
        background: -o-linear-gradient(left, {color} 10%, {color.alpha} 42%);
        background: -ms-linear-gradient(left, {color} 10%, {color.alpha} 42%);
        background: linear-gradient(to right, {color} 10%, {color.alpha} 42%);
  }} 
        .load{type} .loader:before {{
        background: {color}
        }}  
        .load{type} .loader:after {{
        background: {color.background};
        }}
        "),.shinycssloaders_headers
    )
  }
  
  if (type %in% c(4,6,7)) {
    writeLines(
      glue::glue(".load{type} .loader {{color: {color}}}")
    ,.shinycssloaders_headers)
  }
  

  if (type == 8) {
    writeLines(
      glue::glue("
.load{type} .loader {{
      border-top: 1.1em solid rgba({paste(grDevices::col2rgb(color),collapse=',')}, 0.2);
      border-right: 1.1em solid rgba({paste(grDevices::col2rgb(color),collapse=',')}, 0.2);
      border-bottom: 1.1em solid rgba({paste(grDevices::col2rgb(color),collapse=',')}, 0.2);
      border-left: 1.1em solid {color};
}}
      "),.shinycssloaders_headers
    )
  }
  
  # get default font-size from css, and cut it by 25%, as for outputs we usually need something smaller
  size <- round(c(11,11,10,20,25,90,10,10)[type] * size * 0.75)
  writeLines(
    glue::glue(".load{type} .loader {{font-size: {size}px}}"),.shinycssloaders_headers
  )
  writeLines("</style>",.shinycssloaders_headers)
  
  writeLines("<script>",.shinycssloaders_headers)
  writeLines(readLines(system.file("assets/spinner.js",package="shinycssloaders")),.shinycssloaders_headers); 
  writeLines("</script>",.shinycssloaders_headers)
  close(.shinycssloaders_headers); 
}