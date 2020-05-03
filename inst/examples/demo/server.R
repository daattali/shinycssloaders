server <- function(input, output, session) {
  plotnum <- reactiveVal(0)
  
  output$show_example <- renderUI({
    shinycssloaders::withSpinner(
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
      bg <- par(bg = "#fafafa")
      Sys.sleep(isolate(input$time))
      plot(runif(10), main = "Random Plot")
      bg <- par(bg = bg)
    })
  })
}
