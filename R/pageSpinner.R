#' Show (and hide) a full-page spinner that covers the entire page
#'
#' Use these functions to show and hide a full-page spinner.
#' @param expr (optional) An R expression to run while showing the spinner. The
#' spinner will automatically get hidden when this expression completes. If not provided,
#' you must explicitly end the spinner with a call to `hidePageSpinner()`.
#' @param background Background color for the spinner. You can use semi-transparent colours
#' in order to have the Shiny app visible in the background, eg. `"#FFFFFFD0"` or
#' `"rgba(0, 0, 0, 0.7)"`.
#' @inheritParams withSpinner
#' @return If `expr` is provided, the result of `expr` is returned. Otherwise, `NULL`.
#' @seealso [withSpinner()], [showSpinner()], [hideSpinner()]
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   #--- Example 1: Using showPageSpinner/hidePageSpinner ---
#'
#'   ui <- fluidPage(
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
showPageSpinner <- function(
    expr,
    background = "#FFFFFF",
    type = 8,
    color = "#222222",
    size = 1,
    color.background = NULL,
    custom.css = FALSE,
    id = NULL,
    image = NULL,
    image.width = NULL,
    image.height = NULL,
    caption = NULL
) {

  session <- getSession()
  if (is.null(session$userData$.shinycssloaders_added) || !session$userData$.shinycssloaders_added) {
    shiny::insertUI("head", "beforeEnd", immediate = TRUE, ui = getDependencies())
    session$userData$.shinycssloaders_added <- TRUE
  }

  spinner <- buildSpinner(
    spinner_type = "page",
    type = type,
    color = color,
    size = size,
    color.background = color.background,
    custom.css = custom.css,
    id = id,
    image = image,
    image.width = image.width,
    image.height = image.height,
    caption = caption,
    ui_element = NULL,
    proxy.height = NULL,
    hide.ui = FALSE
  )

  spinner_container <- shiny::div(
    id = "shinycssloaders-global-spinner",
    style = paste("background:", background),
    spinner
  )
  shiny::insertUI("body", "beforeEnd", immediate = TRUE, ui = spinner_container)

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
  removeUI("#shinycssloaders-global-spinner", immediate = TRUE)
  removeUI(".global-spinner-css", immediate = TRUE)
  invisible(NULL)
}
