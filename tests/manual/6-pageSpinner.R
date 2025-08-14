library(shiny)

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
