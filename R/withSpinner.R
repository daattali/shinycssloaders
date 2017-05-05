#' Add a spinner (loader) that shows when an output is recalculating
#' @export
#' @param ui_element A UI element that should be wrapped with a spinner when the corresponding output is being calculated.
#' @param type The type of spinner to use, valid values are integers between 1-8. They correspond to the enumeration in \url{https://projects.lukehaas.me/css-loaders/}
#' @param color The color of the spinner to be applied in HTML in hex format
#' @param size The size of the spinner, defined in relative terms ('em') by text-size. Default value is 12, you can increase / decrease as necessary. For type=6 it seems you should multiply by a factor of 4.
#' @param color.background For certain spinners, you will need to specify the background colour of the spinner
withSpinner <- function(ui_element,type=getOption("spinner.type"),color=getOption("spinner.color"),size=getOption("spinner.size"),color.background=getOption("spinner.color.background")) {
  stopifnot(type %in% 1:8)
  
  size <- paste0(size,"px")
  
  if (grepl("rgb",color,fixed=TRUE)) {
    stop("Color should be given in hex format")
  }
  # each spinner will have a unique id, to allow seperate sizing
  id <- paste0("spinner-",shiny:::createUniqueId(4))
  
  add_style <- function(x) {
    shiny::tags$head(
      shiny::tags$style(
        shiny::HTML(
          x
        )
      )
    )
  }
  
  css_color <- shiny::tagList()
  
  if (!is.null(color)) {
    color.alpha <- sprintf("rgba(%s,0)",paste(grDevices::col2rgb(color),collapse=","))
    
    if (type==1) {
      css_color <- add_style(
        glue::glue("#{id}, #{id}:before, #{id}:after {{background: {color}}} #{id} {{color: {color}}}")
      )
    }
    if (type == 2) {
      stopifnot(!is.null(color.background))
      
      css_color <- add_style(
        glue::glue("#{id} {{color: {color}}} #{id}:before, #{id}:after {{background: {color.background};}}")
      )
    }
    
    if (type == 3) {
      stopifnot(!is.null(color.background))
      
      css_color <- add_style(
        glue::glue(
          "#{id} {{
  background: -moz-linear-gradient(left, {color} 10%, {color.alpha} 42%);
  background: -webkit-linear-gradient(left, {color} 10%, {color.alpha} 42%);
  background: -o-linear-gradient(left, {color} 10%, {color.alpha} 42%);
  background: -ms-linear-gradient(left, {color} 10%, {color.alpha} 42%);
  background: linear-gradient(to right, {color} 10%, {color.alpha} 42%);
}} 
#{id}:before {{
   background: {color}
}}  
#{id}:after {{
  background: {color.background};
}}
")
      )
    }
    
    if (type %in% c(4,6,7)) {
      css_color <- add_style(
        glue::glue("#{id} {{color: {color}}}")
      )
    }
    
    if (type==5) {
      base_css <- paste(readLines(system.file("css-loaders/css/load5.css",package="shinycssloaders")),collapse=" ")
      base_css <- gsub(".load5 .loader",paste0("#",id),base_css)
      base_css <- gsub("load5",paste0("load5-",id),base_css,fixed=TRUE)
      base_css <- gsub("255, 255, 255",paste(grDevices::col2rgb(color),collapse=','),base_css,fixed=TRUE)
      base_css <- gsub("#ffffff",color,base_css,fixed=TRUE)
      css_color <- add_style(base_css)
    }
    
    if (type == 8) {
      css_color <- add_style(
        glue::glue("
#{id} {{
      border-top: 1.1em solid rgba({paste(grDevices::col2rgb(color),collapse=',')}, 0.2);
      border-right: 1.1em solid rgba({paste(grDevices::col2rgb(color),collapse=',')}, 0.2);
      border-bottom: 1.1em solid rgba({paste(grDevices::col2rgb(color),collapse=',')}, 0.2);
      border-left: 1.1em solid {color};
}}
      ")
      )
    }
  }
  
  if (!is.null(size)) {
    css_size <- add_style(
      sprintf("#%s {font-size: %s}",id,size)
    )
  }
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(shiny::tags$link(rel="stylesheet",href="assets/spinner.css"))
    ),
    shiny::singleton(
      shiny::tags$script(src="assets/spinner.js")
    ),
    shiny::singleton(
      shiny::tags$head(shiny::tags$link(rel="stylesheet",href=sprintf("css-loaders/css/fallback.css",type)))
    ),
    shiny::singleton(
      shiny::tags$head(shiny::tags$link(rel="stylesheet",href=sprintf("css-loaders/css/load%s.css",type)))
    ),
    css_color,
    css_size,
    shiny::div(class="shiny-spinner-output-container",
               shiny::div(class=sprintf("load-container load%s",type),
                          shiny::div(id=id,class="loader","Loading...")
               ),
               ui_element
    )
  )
}