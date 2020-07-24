#' Add a spinner that shows when an output is recalculating
#' @export
#' @param ui_element A UI element that should be wrapped with a spinner when the corresponding output is being calculated.
#' @param type The type of spinner to use, valid values are integers between 0-8 (0 means no spinner). Check out 
#' \url{https://daattali.com/shiny/shinycssloaders-demo} to see the different types of spinners. You can also use
#' your own custom image using the `image` parameter.
#' @param color The color of the spinner in hex format. Ignored if `image` is used.
#' @param size The size of the spinner, relative to its default size (default is 1, a size of 2 means twice as large). Ignored if `image` is used.
#' @param color.background For certain spinners (type 2-3), you will need to specify the background color of the spinner. Ignored if `image` is used.
#' @param custom.css Set to `TRUE` if you have your own custom CSS that you defined and you don't want the automatic CSS applied to the spinner. Ignored if `image` is used.
#' @param proxy.height If the output UI doesn't specify the output height, you can set a proxy height. It defaults to "400px"
#' for outputs with undefined height. Ignored if `hide.ui` is set to `FALSE`.
#' @param id The HTML ID to use for the spinner. If you don't provide one, it will be generated automatically.
#' @param image The path or URL of the image to use if you want to use a custom image instead of a built-in spinner.
#' @param image.height The height for the custom image spinner, in pixels. If not provided, then the original
#' size of the image is used. Ignored if not using `image`.
#' @param image.width The width for the custom image spinner, in pixels. If not provided, then the original
#' size of the image is used. Ignored if not using `image`.
#' @param hide.ui By default, while an output is recalculating, the output UI is hidden and the spinner is visible instead.
#' Setting `hide.ui = FALSE` will result in the spinner showing up on top of the previous output UI.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       actionButton("go", "Go"),
#'       withSpinner(plotOutput("plot"))
#'     ),
#'     server = function(input, output) {
#'       output$plot <- renderPlot({
#'         input$go
#'         Sys.sleep(1.5)
#'         plot(runif(10))
#'       })
#'     }
#'   )
#' }
withSpinner <- function(
  ui_element,
  type = getOption("spinner.type", default = 1),
  color = getOption("spinner.color", default = "#0275D8"),
  size = getOption("spinner.size", default = 1),
  color.background = getOption("spinner.color.background"),
  custom.css = FALSE,
  proxy.height = NULL,
  id = NULL,
  image = NULL, image.width = NULL, image.height = NULL,
  hide.ui = TRUE
) {
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
  
  if (is.null(image)) {
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
  }
  
  proxy_element <- get_proxy_element(ui_element, proxy.height, hide.ui)
  
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$link(rel="stylesheet", href="shinycssloaders-assets/spinner.css"),
        shiny::tags$script(src="shinycssloaders-assets/spinner.js")
      )
    ),
    if (is.null(image))
      shiny::singleton(
        shiny::tags$head(
          shiny::tags$link(rel="stylesheet", href="shinycssloaders-assets/css-loaders.css")
        )
      ),
    
    if (is.null(image)) css_size_color,

    shiny::div(
      class = paste(
        "shiny-spinner-output-container",
        if (hide.ui) "shiny-spinner-hideui" else "",
        if (is.null(image)) "" else "shiny-spinner-custom"
      ),
      shiny::div(
        class = paste(
          "load-container",
          "shiny-spinner-hidden",
          if (is.null(image)) paste0("load",type)
        ),
        if (is.null(image))
          shiny::div(id = id, class = "loader", (if (type == 0) "" else "Loading..."))
        else
          shiny::tags$img(id = id, src = image, alt = "Loading...", width = image.width, height = image.height)
      ),
      proxy_element,
      ui_element
    )
  )
}

get_proxy_element <- function(ui_element, proxy.height, hide.ui) {
  if (!hide.ui) {
    return(shiny::tagList())
  }
  
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