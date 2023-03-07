server <- function(input, output, session) {
  plotnum <- reactiveVal(0)
  
  output$show_example <- renderUI({
    if (input$type == "custom") {
      params <- list(
        ui_element = plotOutput(paste0("example", plotnum())),
        image = input$image,
        image.width = if (input$image_size_default) NULL else input$image.width,
        image.height = if (input$image_size_default) NULL else input$image.height
      )
    } else {
      params <- list(
        ui_element = plotOutput(paste0("example", plotnum())),
        type = as.numeric(input$type),
        color = input$col,
        size = input$size,
        color.background = "#fafafa"
      )
    }
    do.call(shinycssloaders::withSpinner, params)
  })
  
  observeEvent(input$update, ignoreNULL = FALSE, {
    plotnum(plotnum() + 1)
    output[[paste0("example", plotnum())]] <- renderPlot({
      bg <- par(bg = "#fafafa")
      shinyjs::disable("params")
      on.exit(shinyjs::enable("params"))
      Sys.sleep(isolate(input$time))
      plot(runif(10), main = "Random Plot")
      bg <- par(bg = bg)
    })
  })
}
