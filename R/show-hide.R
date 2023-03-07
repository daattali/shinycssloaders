#' Manually show/hide a spinner
#'
#' Any Shiny output that uses [withSpinner()] will automatically show a spinner
#' while it's recalculating. Use [showSpinner()] and [hideSpinner()] to manually
#' trigger the spinner on-demand.
#' @param id The ID of the Shiny output. The corresponding output must have been
#' wrapped in [withSpinner()] in the UI.
#' @param expr (optional) An R expression to run while showing the spinner. The
#' spinner will automatically get hidden when this expression completes.
#' @return If `expr` is provided, the result of `expr` is returned. Otherwise, `NULL`.
#' @seealso [withSpinner()], [hideSpinner()]
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   #--- Example 1: Using showSpinner/hideSpinner ---
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       actionButton("show", "Show"),
#'       actionButton("hide", "Hide"),
#'       withSpinner(plotOutput("plot"))
#'     ),
#'     server = function(input, output) {
#'       output$plot <- renderPlot({
#'         plot(runif(10))
#'       })
#'       observeEvent(input$show, {
#'         showSpinner("plot")
#'       })
#'       observeEvent(input$hide, {
#'         hideSpinner("plot")
#'       })
#'     }
#'   )
#'
#'   #--- Example 2: Using showSpinner with expr ---
#'
#'   some_slow_function <- function() {
#'     Sys.sleep(2)
#'   }
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       actionButton("show", "Show"),
#'       withSpinner(plotOutput("plot"))
#'     ),
#'     server = function(input, output) {
#'       output$plot <- renderPlot({
#'         plot(runif(10))
#'       })
#'       observeEvent(input$show, {
#'         showSpinner("plot", { some_slow_function() })
#'       })
#'     }
#'   )
#' }
#' @name showHide
NULL

#' @export
#' @rdname showHide
showSpinner <- function(id, expr) {
  session <- getSession()

  idns <- session$ns(id)
  session$sendCustomMessage("shinycssloaders.show_spinner",  list(id = idns))

  if (missing(expr)) {
    value <- invisible(NULL)
  } else {
    value <- expr
    on.exit(hideSpinner(id))
  }

  value
}

#' @export
#' @rdname showHide
hideSpinner <- function(id) {
  # make sure it works with modules
  session <- getSession()

  idns <- session$ns(id)
  session$sendCustomMessage("shinycssloaders.hide_spinner", list(id = idns))

  invisible(NULL)
}
