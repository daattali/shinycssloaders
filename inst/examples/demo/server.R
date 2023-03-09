server <- function(input, output, session) {
  plotnum <- reactiveVal(0)

  spinner_params <- reactive({
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

    params
  })

  output$show_example <- renderUI({
    do.call(shinycssloaders::withSpinner, spinner_params())
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

  observeEvent(input$show, {
    params <- spinner_params()
    params$ui_element <- NULL
    params$background <- input$bg
    ui <- do.call(shinycssloaders::pageSpinner, params)
    insertUI("body", "afterBegin", immediate = TRUE, ui = ui)
    showPageSpinner(Sys.sleep(input$time))

    # Remove the fullpage spinner so that it won't interfere with the next ones
    removeUI("#shinycssloaders-global-spinner", immediate = TRUE)
    shinyjs::runjs('$("head > style").last().remove()')
  })
}
