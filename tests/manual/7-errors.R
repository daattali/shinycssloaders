library(shiny)

ui <- fluidPage(
  selectInput("case", NULL, c("success", "error", "validate")),
  withSpinner(plotOutput("plot"))
)
server <- function(input, output) {
  output$plot <- renderPlot({
    Sys.sleep(1)
    validate(need(input$case != "validate", "Validation error"))
    if (input$case == "error") {
      stop("error")
    }
    plot(runif(10))
  })
}
shinyApp(ui, server)
