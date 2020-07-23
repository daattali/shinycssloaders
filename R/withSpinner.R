#' Add a spinner (loader) that shows when an output is recalculating
#' 
#' You can use the \code{\link{withCustomSpinner}} function if you want to use a custom image
#' instead of one of the built-in loader animations.
#' @export
#' @param ui_element A UI element that should be wrapped with a spinner when the corresponding output is being calculated.
#' @param type The type of spinner to use, valid values are integers between 0-8 (0 means no spinner). Check out 
#' \url{https://daattali.com/shiny/shinycssloaders-demo} to see the different types of spinners.
#' @param color The color of the spinner in hex format
#' @param size The size of the spinner, relative to its default size.
#' @param color.background For certain spinners (type 2-3), you will need to specify the background color of the spinner
#' @param custom.css Set to `TRUE` if you have your own custom CSS that you defined and you don't want the automatic CSS applied to the spinner.
#' @param proxy.height If the output doesn't specify the output height, you can set a proxy height. It defaults to "400px" for outputs with undefined height.
#' @param id The HTML ID to use for the spinner. If you don't provide one, it will be generated automatically.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       actionButton("go", "Go"),
#'       withSpinner(tableOutput("table"))
#'     ),
#'     server = function(input, output) {
#'       output$table <- renderTable({
#'         input$go
#'         Sys.sleep(1.5)
#'         mtcars
#'       })
#'     }
#'   )
#' }
withSpinner <- function(ui_element,
                        type = getOption("spinner.type", default = 1),
                        color = getOption("spinner.color", default = "#0275D8"),
                        size = getOption("spinner.size", default = 1),
                        color.background = getOption("spinner.color.background"),
                        custom.css = FALSE,
                        proxy.height = NULL,
                        id = NULL)
{
  stopifnot(type %in% 0:8)
  
  if (grepl("rgb", color, fixed = TRUE)) {
    stop("Color should be given in hex format")
  }
  
  if (is.character(custom.css)) {
    stop("It looks like you provided a string to 'custom.css', but it needs to be either `TRUE` or `FALSE`. ",
         "The actual CSS needs to added to the app's UI.")
  }
  
  # each spinner will have a unique id to allow separate sizing
  if (is.null(id)) {
    id <- paste0("spinner-", digest::digest(ui_element))
  }
  
  css_size_color <- shiny::tagList()
  
  if (!custom.css && type != 0) {
    if (type %in% c(2, 3) && is.null(color.background)) {
      stop("For spinner types 2 & 3 you need to specify manually a background color.")
    }
    
    color.rgb <- paste(grDevices::col2rgb(color), collapse = ",")
    color.alpha0 <- sprintf("rgba(%s, 0)", color.rgb)
    color.alpha2 <- sprintf("rgba(%s, 0.2)", color.rgb)
    
    css_file <- system.file(glue::glue("loaders-templates/load{type}.css"), package="shinycssloaders")
    base_css <- ""
    if (file.exists(css_file)) {
      base_css <- paste(readLines(css_file), collapse = " ")
      base_css <- glue::glue(base_css, .open = "{{", .close = "}}")
    }
    
    # get default font-size from css, and cut it by 25%, as for outputs we usually need something smaller
    size <- round(c(11, 11, 10, 20, 25, 90, 10, 10)[type] * size * 0.75)
    base_css <- paste(base_css, glue::glue("#{id} {{ font-size: {size}px; }}"))
    css_size_color <- add_style(base_css)
  }
  
  proxy_element <- get_proxy_element(ui_element, proxy.height)

  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$link(rel="stylesheet", href="shinycssloaders-assets/spinner.css"),
        shiny::tags$script(src="shinycssloaders-assets/spinner.js"),
        shiny::tags$link(rel="stylesheet", href="shinycssloaders-assets/css-loaders.css")
      )
    ),
    css_size_color,
    shiny::div(
      class="shiny-spinner-output-container",
      shiny::div(
        class=sprintf("load-container load%s shiny-spinner-hidden",type),
        shiny::div(id=id,class="loader", (if (type == 0) "" else "Loading..."))
      ),
      proxy_element,
      ui_element
    )
  )
}

#' Add a custom spinner image when an output is recalculating
#' 
#' Similar to \code{\link{withSpinner}}, but a custom image can be provided.
#' @export
#' @inheritParams withSpinner
#' @param image The path or URL of the image to use.
#' @param height The height for the spinner, in pixels. If not provided, then the original
#' size of the image is used.
#' @param width The width for the spinner, in pixels. If not provided, then the original
#' size of the image is used.
withCustomSpinner <- function(ui_element, image, 
                              height = NULL, width = NULL, 
                              proxy.height = NULL, id = NULL) {
  if (is.null(id)) {
    id <- paste0("spinner-", digest::digest(ui_element))
  }
  
  proxy_element <- get_proxy_element(ui_element, proxy.height)
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$link(rel="stylesheet", href="shinycssloaders-assets/spinner.css"),
        shiny::tags$script(src="shinycssloaders-assets/spinner.js")
      )
    ),
    shiny::div(
      class = "shiny-spinner-output-container shiny-spinner-custom",
      shiny::div(
        class = "load-container shiny-spinner-hidden",
        shiny::tags$img(id = id, src = image, alt = "Loading...", width = width, height = height),
      ),
      proxy_element,
      ui_element
    )
  )
}

get_proxy_element <- function(ui_element, proxy.height) {
  if (is.null(proxy.height)) {
    if (!grepl("height:\\s*\\d", ui_element)) {
      proxy.height <- "400px"
    }
  } else {
    if (is.numeric(proxy.height)) {
      proxy.height <- paste0(proxy.height, "px")
    }
  }
  
  if (is.null(proxy.height)) {
    proxy_element <- shiny::tagList()
  } else {
    proxy_element <- shiny::div(style=glue::glue("height:{proxy.height}"),
                                class="shiny-spinner-placeholder")
  }
}

add_style <- function(x) {
  shiny::tags$head(
    shiny::tags$style(
      shiny::HTML(
        x
      )
    )
  )
}