% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pageSpinner.R
\name{showHidePage}
\alias{showHidePage}
\alias{showPageSpinner}
\alias{hidePageSpinner}
\title{Show (and hide) a full-page spinner that covers the entire page}
\usage{
showPageSpinner(
  expr,
  background = getOption("page.spinner.background", default = "#FFFFFFCC"),
  type = getOption("page.spinner.type", default = 8),
  color = getOption("page.spinner.color", default = "#0275D8"),
  size = getOption("page.spinner.size", default = 1),
  color.background = getOption("page.spinner.color.background"),
  id = getOption("page.spinner.id"),
  image = getOption("page.spinner.image"),
  image.width = getOption("page.spinner.image.width"),
  image.height = getOption("page.spinner.image.height"),
  caption = getOption("page.spinner.caption")
)

hidePageSpinner()
}
\arguments{
\item{expr}{(optional) An R expression to run while showing the spinner. The
spinner will automatically get hidden when this expression completes. If not provided,
you must explicitly end the spinner with a call to \code{hidePageSpinner()}.}

\item{background}{Background color for the spinner. You can use semi-transparent colours
in order to have the Shiny app visible in the background, eg. \code{"#FFFFFFD0"} or
\code{"rgba(0, 0, 0, 0.7)"}.}

\item{type}{The type of spinner to use. Valid values are integers between 0-8 (0 means no spinner). Check out
\url{https://daattali.com/shiny/shinycssloaders-demo/} to see the different types of spinners.
You can also use your own custom image using the \code{image} parameter.}

\item{color}{The color of the spinner in hex format. Ignored if \code{image} is used.}

\item{size}{The size of the spinner, relative to its default size (default is 1, a size of 2 means twice as large).
Ignored if \code{image} is used.}

\item{color.background}{For certain spinners (type 2-3), you will need to specify the background color of the spinner.
Ignored if \code{image} is used.}

\item{id}{The HTML ID to use for the spinner. If you don't provide one, it will be generated automatically.}

\item{image}{The path or URL of the image to use if you want to use a custom image instead of a built-in spinner.
If \code{image} is provided, then \code{type} is ignored.}

\item{image.width}{The width for the custom image spinner, in pixels. If not provided, then the original
size of the image is used. Ignored if not using \code{image}.}

\item{image.height}{The height for the custom image spinner, in pixels. If not provided, then the original
size of the image is used. Ignored if not using \code{image}.}

\item{caption}{Caption to display below the spinner or image (text or HTML). The caption's font color is determined
by the \code{color} parameter. Ignored if \code{type} is 1.}
}
\value{
If \code{expr} is provided, the result of \code{expr} is returned. Otherwise, \code{NULL}.
}
\description{
Use these functions to show and hide a full-page spinner.\cr\cr
All parameters (except \code{expr}) can be set globally in order to use a default setting for all
full-page spinner in your Shiny app. This can be done by setting an R option with the parameter's
name prepended by \code{"page.spinner."}. For example, to set all page spinners to type=5 and
color=#0dc5c1 by default, use \code{options(page.spinner.type = 5, page.spinner.color = "#0dc5c1")}.
}
\examples{
if (interactive()) {
  library(shiny)

  #--- Example 1: Using showPageSpinner/hidePageSpinner ---

  ui <- fluidPage(
    actionButton("go", "Go"),
    plotOutput("plot")
  )
  server <- function(input, output) {
    observeEvent(input$go, {
      showPageSpinner()
      Sys.sleep(1)
      hidePageSpinner()
    })
    output$plot <- renderPlot({
     plot(runif(10))
    })
  }
  shinyApp(ui, server)

  #--- Example 2: Using showPageSpinner with expr ---

  some_slow_function <- function() {
    Sys.sleep(1)
  }

  ui <- fluidPage(
    actionButton("go", "Go"),
    plotOutput("plot")
  )
  server <- function(input, output) {
    observeEvent(input$go, {
      showPageSpinner({ some_slow_function() })
    })
    output$plot <- renderPlot({
     plot(runif(10))
    })
  }
  shinyApp(ui, server)
}
}
\seealso{
\code{\link[=withSpinner]{withSpinner()}}, \code{\link[=showSpinner]{showSpinner()}}, \code{\link[=hideSpinner]{hideSpinner()}}
}
