library(shiny)

shinyApp(
  ui = fluidPage(
    actionButton("go", "Go"),
    withSpinner(plotOutput("plot"), type = 2, color = "darkblue", size = 2,
                color.background = "blue", caption = "Test", delay = 300)
  ),
  server = function(input, output) {
    output$plot <- renderPlot({
      input$go
      Sys.sleep(1.5)
      plot(runif(10))
    })
  }
)
