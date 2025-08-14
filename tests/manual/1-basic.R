library(shiny)

shinyApp(
  ui = fluidPage(
    actionButton("go", "Go"),
    withSpinner(plotOutput("plot"))
  ),
  server = function(input, output) {
    output$plot <- renderPlot({
      input$go
      Sys.sleep(1.5)
      plot(runif(10))
    })
  }
)
