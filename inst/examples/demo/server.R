server <- function(input, output, session) {
  plotnum <- reactiveVal(0)
  plotdata <- reactiveValues( data = runif(10) )

  
  output$show_example <- renderUI({
    if (input$type == "custom") {
      params <- list(
        ui_element = plotOutput(paste0("example", plotnum())),
        image = input$image,
        image.width = if (input$image_size_default) NULL else input$image.width,
        image.height = if (input$image_size_default) NULL else input$image.height,
        show.delay = input$delaytime
      )
    } else {
      params <- list(
        ui_element = plotOutput(paste0("example", plotnum())),
        type = as.numeric(input$type),
        color = input$col,
        size = input$size,
        color.background = "#fafafa",
        show.delay = input$delaytime
      )
    }
    do.call(shinycssloaders::withSpinner, params)
  })
  
  observeEvent(input$update, ignoreNULL = FALSE, {
    if (input$time > 5) {
      shinyjs::alert("In order to not block my server for too long, please use a time of no more than 5 seconds")
      return()
    }
    plotnum(plotnum() + 1)
    output[[paste0("example", plotnum())]] <- renderPlot({
      bg <- par(bg = "#fafafa")
      shinyjs::disable("params")
      on.exit(shinyjs::enable("params"))
      Sys.sleep(isolate(input$time))
      plot(plotdata$data, main = "Random Plot")
      bg <- par(bg = bg)
    })
  })
  
  observeEvent(input$refresh, ignoreNULL = FALSE, {
    if (input$time > 5) {
      shinyjs::alert("In order to not block my server for too long, please use a time of no more than 5 seconds")
      return()
    }

    plotdata$data <- runif(10) 
    Sys.sleep(isolate(input$time))
  })
  
}
