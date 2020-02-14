library(shiny)
library(shinycssloaders)

ui <- fluidPage(
  selectInput("type", "Spinner type", 1:8),
  colourpicker::colourInput("col", "Color", "#0275D8", showColour = "background"),
  conditionalPanel(
    "input.type == '2' || input.type == '3'",
    colourpicker::colourInput("background", "Background Color", "white", showColour = "background")
  ),
  sliderInput("size", "Size", min = 0.5, max = 5, step = 0.5, value = 1),
  actionButton("update", "Update", class = "btn-primary"),
  uiOutput("show_example")
)

server <- function(input, output, session) {
  plotnum <- reactiveVal(0)
  
  output$show_example <- renderUI({
    withSpinner(
      plotOutput(paste0("example", plotnum())),
      type = as.numeric(input$type),
      color = input$col,
      size = input$size,
      color.background = input$background
    )
  })
  
  observeEvent(input$update, ignoreNULL = FALSE, {
    plotnum(plotnum() + 1)
    output[[paste0("example", plotnum())]] <- renderPlot({
      Sys.sleep(0.7)
      plot(runif(10), main = "Random Plot")
    })
  })
}

shinyApp(ui, server)
