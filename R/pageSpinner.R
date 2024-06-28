#' Show (and hide) a full-page spinner that covers the entire page
#'
#' Use these functions to show and hide a full-page spinner.\cr\cr
#' All parameters (except `expr`) can be set globally in order to use a default setting for all
#' full-page spinner in your Shiny app. This can be done by setting an R option with the parameter's
#' name prepended by `"page.spinner."`. For example, to set all page spinners to type=5 and
#' color=#0dc5c1 by default, use `options(page.spinner.type = 5, page.spinner.color = "#0dc5c1")`.
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
    background = getOption("page.spinner.background", default = "#FFFFFFCC"),
    type = getOption("page.spinner.type", default = 8),
    color = getOption("page.spinner.color", default = "#0275D8"),
    size = getOption("page.spinner.size", default = 1),
    color.background = getOption("page.spinner.color.background"),
    custom.css = getOption("page.spinner.custom.css", default = FALSE),
    id = getOption("page.spinner.id"),
    image = getOption("page.spinner.image"),
    image.width = getOption("page.spinner.image.width"),
    image.height = getOption("page.spinner.image.height"),
    caption = getOption("page.spinner.caption")
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

  hidePageSpinner()

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
