library(shiny)
library(shinycssloaders)
library(DT)

# for spinners 2-3 match the background color of wellPanel
options(spinner.color.background="#F5F5F5")

ui <- fluidPage(
  wellPanel(
    tags$b("This example shows the loading spinner whilst a data-table is loading and hides the spinner when the data-table is not shown."), 
    br(),
    br(),
    tags$b(style="color:red","Since the table height is not known ex-ante (as it depends on the rows selected), we insert a 'proxy' container that emulates the unknown table. The spinner is centered with respect to the proxy. The proxy height is configurable and should in general represent an 'expected' output height."),
    br(),
    br(),
    tags$ul(
      tags$li("You can use it to wrap any kind of output."),
      tags$li("To see what happens on recalculation, click the recalculate button"),
      tags$li("To see what happens if no output should be generated, check off 'Show plots'.")
    ),
    checkboxInput("show_plot","Show tables",value=TRUE),
    actionButton("redraw_plot","Re-draw tables"),
    br(),
    br(),
    fluidRow(
      column(
        sliderInput("n_rows","Number of rows in table",min=1,max=nrow(mtcars),value=10,step = 1),
        width=3)
    )
  ),
  do.call(tabsetPanel,lapply(1:8,function(.type) {
    tabPanel(paste0("Type ",.type),
             fluidRow(
               column(width=6,
                      wellPanel(
                        tags$b("With spinner:"),
                        withSpinner(tableOutput(paste0("table",.type)),type=.type) 
                      )
               ),
               column(width=6,
                      wellPanel(
                        tags$b("Without spinner (default):"),
                        tableOutput(paste0("nospin_table",.type))
                      )
               )
             )
    )
  }))
)

server <- function(input, output,session) {
  for (i in 1:8) {
    output[[paste0("nospin_table",i)]] <- output[[paste0("table",i)]] <- renderTable({
      validate(need(input$show_plot,"Show table is unchecked. Check to see table."))
      input$redraw_plot
      Sys.sleep(5) # just for demo so you can enjoy the animation
      mtcars[1:input$n_rows,]
    })
  }
}

shinyApp(ui = ui, server = server)
