library(shiny)

shinyApp(
  ui = fluidPage(
    actionButton("go", "Go"),
    withSpinner(textOutput("text"), proxy.height = 80, inline = TRUE, width = 300),
    "Test"
  ),
  server = function(input, output) {
    output$text <- renderText({
      input$go
      Sys.sleep(1.5)
      toString(sample(LETTERS, 3))
    })
  }
)
