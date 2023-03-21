#' Add a full-page spinner that covers the entire page
#'
#' This function must be called in a Shiny app's UI to create a full-page spinner. The spinner
#' will be centered on the page. In the server, you can call [showPageSpinner()] and [hidePageSpinner()]
#' to show/hide this spinner.
#' @inheritParams withSpinner
#' @param background Background color for the spinner. You can use semi-transparent colours
#' in order to have the Shiny app visible in the background, eg. `"#222222AA"` or `"rgba(150, 20, 70, 0.8)"`.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   #--- Example 1: Using showPageSpinner/hidePageSpinner ---
#'
#'   ui <- fluidPage(
#'     pageSpinner(),
#'     actionButton("go", "Go"),
#'     plotOutput("plot")
#'   )
#'   server <- function(input, output) {
#'     observeEvent(input$go, {
#'       showPageSpinner()
#'       Sys.sleep(1)
#'       hidePageSpinner()
#'     })
#'     output$plot <- renderPlot({
#'      plot(runif(10))
#'     })
#'   }
#'   shinyApp(ui, server)
#'
#'   #--- Example 2: Using showPageSpinner with expr ---
#'
#'   some_slow_function <- function() {
#'     Sys.sleep(1)
#'   }
#'
#'   ui <- fluidPage(
#'     pageSpinner(),
#'     actionButton("go", "Go"),
#'     plotOutput("plot")
#'   )
#'   server <- function(input, output) {
#'     observeEvent(input$go, {
#'       showPageSpinner({ some_slow_function() })
#'     })
#'     output$plot <- renderPlot({
#'      plot(runif(10))
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @seealso [showPageSpinner()], [hidePageSpinner()], [withSpinner()]
#' @export
pageSpinner <- function(
  type = 8,
  background = "#FFFFFF",
  color = "#222222",
  size = 1,
  color.background = NULL,
  custom.css = FALSE,
  image = NULL,
  image.width = NULL,
  image.height = NULL
) {
  shiny::div(
    id = "shinycssloaders-global-spinner",
    style = paste("background:", background),
    buildSpinner(
      spinner_type = "page",
      type = type,
      color = color,
      size = size,
      color.background = color.background,
      custom.css = custom.css,
      image = image,
      image.width = image.width,
      image.height = image.height,
      id = "spinner-shinycssloaders-global-spinner"
    )
  )
}

#' Show/hide a full-page spinner
#'
#' Use these functions to show or hide the full-page spinner. The spinner must first be
#' created in the Shiny app's UI using [pageSpinner()].
#' @param expr (optional) An R expression to run while showing the spinner. The
#' spinner will automatically get hidden when this expression completes.
#' @return If `expr` is provided, the result of `expr` is returned. Otherwise, `NULL`.
#' @seealso [pageSpinner()]
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   #--- Example 1: Using showPageSpinner/hidePageSpinner ---
#'
#'   ui <- fluidPage(
#'     pageSpinner(),
#'     actionButton("go", "Go"),
#'     plotOutput("plot")
#'   )
#'   server <- function(input, output) {
#'     observeEvent(input$go, {
#'       showPageSpinner()
#'       Sys.sleep(1)
#'       hidePageSpinner()
#'     })
#'     output$plot <- renderPlot({
#'      plot(runif(10))
#'     })
#'   }
#'   shinyApp(ui, server)
#'
#'   #--- Example 2: Using showPageSpinner with expr ---
#'
#'   some_slow_function <- function() {
#'     Sys.sleep(1)
#'   }
#'
#'   ui <- fluidPage(
#'     pageSpinner(),
#'     actionButton("go", "Go"),
#'     plotOutput("plot")
#'   )
#'   server <- function(input, output) {
#'     observeEvent(input$go, {
#'       showPageSpinner({ some_slow_function() })
#'     })
#'     output$plot <- renderPlot({
#'      plot(runif(10))
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @name showHidePage
NULL

#' @export
#' @rdname showHidePage
showPageSpinner <- function(expr) {
  session <- getSession()
  session$sendCustomMessage("shinycssloaders.show_page_spinner", list())

  if (missing(expr)) {
    value <- invisible(NULL)
  } else {
    value <- expr
    on.exit(hidePageSpinner())
  }

  value
}

#' @export
#' @rdname showHidePage
hidePageSpinner <- function() {
  session <- getSession()
  session$sendCustomMessage("shinycssloaders.hide_page_spinner", list())
  invisible(NULL)
}
