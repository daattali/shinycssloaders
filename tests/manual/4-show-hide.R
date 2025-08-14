library(shiny)

ui <- fluidPage(
  shinyjs::useShinyjs(),
  actionButton("think","think"),
  actionButton("unthink","unthink"),
  actionButton("show","show"),
  actionButton("hide","hide"), br(), br(), br(),
  withSpinner(plotOutput("plot"))
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot(runif(10))
  })
  observeEvent(input$think, showSpinner("plot"))
  observeEvent(input$unthink, hideSpinner("plot"))
  observeEvent(input$show, shinyjs::show("plot"))
  observeEvent(input$hide, shinyjs::hide("plot"))
}

shinyApp(ui, server)
