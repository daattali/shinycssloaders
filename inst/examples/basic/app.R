library(shiny)
library(shinycssloaders)

# for spinners 2-3 match the background color of wellPanel
options(spinner.color.background="#F5F5F5")

ui <- fluidPage(
  wellPanel(
    tags$b("This example shows the loading spinner whilst the plot is loading and hides the spinner when the plot is not shown."), 
    br(),br(),
    tags$ul(
      tags$li("You can use it to wrap any kind of output."),
      tags$li("To see what happens on recalculation, click the recalculate button"),
      tags$li("To see what happens if no output should be generated, check off 'Show plots'.")
    ),
    checkboxInput("show_plot","Show plot",value=TRUE),
    actionButton("redraw_plot","Re-draw plots")
  ),
  do.call(tabsetPanel,lapply(1:8,function(.type) {
    tabPanel(paste0("Type ",.type),
             fluidRow(
               column(width=6,
                      wellPanel(
                        tags$b("With spinner:"),
                        withSpinner(plotOutput(paste0("plot",.type)),type=.type)
                      )
               ),
               column(width=6,
                      wellPanel(
                        tags$b("Without spinner (default):"),
                        plotOutput(paste0("nospin_plot",.type))
                      )
               )
             )
    )
  }))
)

server <- function(input, output,session) {
  for (i in 1:8) {
    output[[paste0("nospin_plot",i)]] <- output[[paste0("plot",i)]] <- renderPlot({
      validate(need(input$show_plot,"Show plot is unchecked. Check to see plot."))
      input$redraw_plot
      Sys.sleep(5) # just for demo so you can enjoy the animation
      plot(
        x = runif(1e4), y = runif(1e4)
      )
    })
  }
}

shinyApp(ui = ui, server = server)
