#' Add a spinner that shows while an output is recalculating
#'
#' Add a spinner that automatically shows while an output is recalculating. You can also manually trigger the spinner
#' using [showSpinner()] and [hideSpinner()].\cr\cr
#' Most parameters can be set globally in order to use a default setting for all spinners in your Shiny app.
#' This can be done by setting an R option with the parameter's name prepended by `"spinner."`. For example, to set all spinners
#' to type=5 and color=#0dc5c1 by default, use `options(spinner.type = 5, spinner.color = "#0dc5c1")`. The following parameters
#' cannot be set globally: `ui_element`, `id`.\cr\cr
#' Use [showPageSpinner()] to show a spinner on the entire page instead of individual outputs.
#' @param ui_element A UI element that should be wrapped with a spinner when the corresponding output is being calculated.
#' @param type The type of spinner to use. Valid values are integers between 0-8 (0 means no spinner). Check out
#' \url{https://daattali.com/shiny/shinycssloaders-demo} to see the different types of spinners.
#' You can also use your own custom image using the `image` parameter.
#' @param color The color of the spinner in hex format. Ignored if `image` is used.
#' @param size The size of the spinner, relative to its default size (default is 1, a size of 2 means twice as large).
#' Ignored if `image` is used.
#' @param color.background For certain spinners (type 2-3), you will need to specify the background color of the spinner.
#' Ignored if `image` is used.
#' @param custom.css Set to `TRUE` if you have your own custom CSS that you defined and you don't want the automatic CSS applied to the spinner.
#' Ignored if `image` is used.
#' @param proxy.height If the output UI doesn't specify the output height, you can set a proxy height. It defaults to "400px"
#' for outputs with undefined height. Ignored if `hide.ui` is set to `FALSE`.
#' @param id The HTML ID to use for the spinner. If you don't provide one, it will be generated automatically.
#' @param image The path or URL of the image to use if you want to use a custom image instead of a built-in spinner.
#' If `image` is provided, then `type` is ignored.
#' @param image.height The height for the custom image spinner, in pixels. If not provided, then the original
#' size of the image is used. Ignored if not using `image`.
#' @param image.width The width for the custom image spinner, in pixels. If not provided, then the original
#' size of the image is used. Ignored if not using `image`.
#' @param hide.ui By default, while an output is recalculating, the output UI is hidden and the spinner is visible instead.
#' Setting `hide.ui = FALSE` will result in the spinner showing up on top of the previous output UI.
#' @param caption Caption to display below the spinner or image (text or HTML). The caption's font color is determined
#' by the `color` parameter. Ignored if `type` is 1.
#' @seealso [showSpinner()], [hideSpinner()], [showPageSpinner()]
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
#' @export
withSpinner <- function(
  ui_element,
  type = getOption("spinner.type", default = 1),
  color = getOption("spinner.color", default = "#0275D8"),
  size = getOption("spinner.size", default = 1),
  color.background = getOption("spinner.color.background"),
  custom.css = getOption("spinner.custom.css", default = FALSE),
  proxy.height = getOption("spinner.proxy.height"),
  id = NULL,
  image = getOption("spinner.image"),
  image.width = getOption("spinner.image.width"),
  image.height = getOption("spinner.image.height"),
  hide.ui = getOption("spinner.hide.ui", default = TRUE),
  caption = getOption("spinner.caption")
) {

  if (!inherits(ui_element, "shiny.tag") && !inherits(ui_element, "shiny.tag.list")) {
    stop("`ui_element` must be a Shiny tag", call. = FALSE)
  }

  spinner <- buildSpinner(
    spinner_type = "output",
    ui_element = ui_element,
    type = type,
    color = color,
    size = size,
    color.background = color.background,
    custom.css = custom.css,
    proxy.height = proxy.height,
    id = id,
    image = image,
    image.width = image.width,
    image.height = image.height,
    hide.ui = hide.ui,
    caption = caption
  )

  htmltools::attachDependencies(spinner, getDependencies())
}
