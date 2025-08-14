library(shiny)
library(bslib)

ui <- page_fluid(
  layout_columns(
    card(
      full_screen = TRUE,
      card_header("without spinner"),
      card_body(plotOutput("plot1"))
    ),
    card(
      full_screen = TRUE,
      card_header("with spinner"),
      card_body(withSpinner(plotOutput("plot2"), fill = TRUE))
    )
  ),
  actionButton("go", "go")
)

server <- function(input, output) {

  output$plot1 <- output$plot2 <- renderPlot({
    input$go
    Sys.sleep(0.2)
    plot(runif(20))
  })

}

shinyApp(ui, server)
