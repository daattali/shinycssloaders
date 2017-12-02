#' Add a spinner (loader) that shows when an output is recalculating
#' @export
#' @param ui_element A UI element that should be wrapped with a spinner when the corresponding output is being calculated.
#' @param type The type of spinner to use, valid values are integers between 1-8. They correspond to the enumeration in \url{https://projects.lukehaas.me/css-loaders/}
#' @param color The color of the spinner to be applied in HTML in hex format
#' @param size The size of the spinner, relative to it's default size.
#' @param color.background For certain spinners (type 2-3), you will need to specify the background colour of the spinner
#' @param custom.css If custom css is to be applied, we don't enforce the color / size options to the given spinner id
#' @param proxy.height If the output doesn't specify the output height, you can set a proxy height. It defaults to 400px for outputs with undefined height.
#' @examples
#' \dontrun{withSpinner(plotOutput("my_plot"))}
withSpinner <- function(ui_element,type=getOption("spinner.type",default=1),color=getOption("spinner.color",default="#0275D8"),size=getOption("spinner.size",default=1),color.background=getOption("spinner.color.background"),custom.css=FALSE,proxy.height=if (grepl("height:\\s*\\d",ui_element)) NULL else "400px") {
  stopifnot(type %in% 1:8)
  
  if (grepl("rgb",color,fixed=TRUE)) {
    stop("Color should be given in hex format")
  }
  # each spinner will have a unique id, to allow seperate sizing - based on hashing the UI element code
  id <- paste0("spinner-",digest::digest(ui_element))
  
  add_style <- function(x) {
    shiny::tags$head(
      shiny::tags$style(
        shiny::HTML(
          x
        )
      )
    )
  }
  
  css_size <- css_color <- shiny::tagList()
  
  if (!custom.css) {
    color.alpha <- sprintf("rgba(%s,0)",paste(grDevices::col2rgb(color),collapse=","))
    
    if (type==1) {
      css_color <- add_style(
        glue::glue("#{id}, #{id}:before, #{id}:after {{background: {color}}} #{id} {{color: {color}}}")
      )
    }
    
    if (type %in% c(2,3) && is.null(color.background)) {
      stop("For spinner types 2 & 3 you need to specify manually a background color. This should match the background color of the container.")
    }
    
    if (type == 2) {
      css_color <- add_style(
        glue::glue("#{id} {{color: {color}}} #{id}:before, #{id}:after {{background: {color.background};}}")
      )
    }
    
    if (type == 3) {
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
    
    # get default font-size from css, and cut it by 25%, as for outputs we usually need something smaller
    size <- round(c(11,11,10,20,25,90,10,10)[type] * size * 0.75)
    css_size <- add_style(
      glue::glue("#{id} {{font-size: {size}px}}",id,size)
    )
  }
  
  proxy_element <- shiny::tagList()
  if (!is.null(proxy.height)) {
    proxy_element <- shiny::div(style=glue::glue("height:{ifelse(is.null(proxy.height),'100%',proxy.height)}"),
                                class="shiny-spinner-placeholder")
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
               shiny::div(class=sprintf("load-container load%s shiny-spinner-hidden",type),
                          shiny::div(id=id,class="loader","Loading...")
               ),
               proxy_element,
               ui_element
    )
  )
}