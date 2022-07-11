library(shiny)
library(reactable)
library(magrittr)

slow_cars <- function() {
  Sys.sleep(3)
  random_cars <- mtcars[sample(seq_len(nrow(mtcars)), size = 10), ]
  cbind(
    model = rownames(random_cars),
    data.frame(random_cars, row.names = NULL)
  )
}

ui <- fluidPage(
  titlePanel("Show/Hide Spinners"),
  mainPanel(
    width = 12,
    shinyjs::useShinyjs(),
    tabsetPanel(
      tabPanel(
        "Without Show/Hide",
        reactableOutput("tbl_orig", height = 600) %>% 
          withSpinner(type = 5),
        helpText(
          paste(
            "Shows a typical app setup where the table's render function",
            "includes a dependency on the button."
          ),
          "Click the 'Update' button to simulate a long-running calculation.",
          paste(
            "Each time you click the button the table is completely",
            "re-rendered, so filters/sorting are lost."
          )
        ),
        actionButton("update_orig", "Update")
      ),
      tabPanel(
        "In Code",
        reactableOutput("tbl_code", height = 600) %>% 
          withSpinner(type = 5),
        helpText(
          paste(
            "Shows how re-rendering can be avoided so that the table state is",
            "maintained, while still providing visual feedback via the spinner."
          ),
          "Click the 'Update' button to simulate a long-running calculation.",
          paste(
            "This version replaces the data in the table without re-rendering,",
            "but it requires showSpinner and hideSpinner."
          )
        ),
        actionButton("update_code", "Update")
      ),
      tabPanel(
        "Via Button",
        reactableOutput("tbl_manual", height = 600) %>% 
          withSpinner(type = 5),
        helpText(
          "Shows how other app elements can be used to invoke the spinners."
        ),
        actionButton("show", "Show Spinner"),
        actionButton("hide", "Hide Spinner")
      ),
      tabPanel(
        "Caption Test",
        column(
          width = 4,
          selectInput(
            "spin_type",
            "Spinner Type:",
            choices = 0:8,
            selected = 5
          ),
          colourpicker::colourInput(
            "spin_color",
            "Main color:",
            value = "#0275D8"
          ),
          colourpicker::colourInput(
            "spin_bg",
            "Background color:",
            value = "#FFFFFF"
          ),
          textInput("spin_caption", "Caption:"),
          colourpicker::colourInput(
            "spin_cap_color",
            "Caption color:",
            value = "#0275D8"
          ),
          textInput("spin_img_url", "Image URL:"),
          checkboxInput("spin_hide_ui", "Hide UI:", TRUE),
          actionButton("cap_go", "Go")
        ),
        column(
          width = 8,
          div(id = "cap_test_container"),
          actionButton("cap_show", "Show Spinner"),
          actionButton("cap_hide", "Hide Spinner")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  ##############################################################################

  # typical app
  # table re-renders completely when data changes
  # table state (filters, sorting) is lost on re-render
  
  output$tbl_orig <- renderReactable({
    input$update_orig
    slow_cars() %>% 
      reactable(filterable = TRUE, selection = "multiple")
  })
  
  ##############################################################################
  
  # using showSpinner/hideSpinner
  # table state (filters, sorting) is maintained by replacing data
  # without re-rendering
  
  output$tbl_code <- renderReactable({
    # no dependency, data changes in observeEvent
    slow_cars() %>% 
      reactable(filterable = TRUE, selection = "multiple")
  })
  
  observeEvent(input$update_code, {
    
    showSpinner("tbl_code")
    
    x <- slow_cars()
    
    updateReactable("tbl_code", data = x)
    
    hideSpinner("tbl_code")
    
  })
  
  ##############################################################################
  
  # using showSpinner/hideSpinner via buttons
  
  output$tbl_manual <- renderReactable({
    # no dependency, data never changes
    slow_cars() %>% 
      reactable(filterable = TRUE, selection = "multiple")
  })
  
  observeEvent(input$show, showSpinner("tbl_manual"))
  
  observeEvent(input$hide, hideSpinner("tbl_manual"))
  
  ##############################################################################
  
  # caption testing
  
  output$cap <- renderReactable({
    iris %>% 
      reactable()
  })
  
  observeEvent(input$cap_go, {
    
    removeUI(
      "#cap_test_container > *",
      multiple = TRUE,
      immediate = TRUE
    )
    
    insertUI(
      "#cap_test_container",
      ui = reactableOutput("cap", height = 600) %>% 
        withSpinner(
          type = input$spin_type,
          color = input$spin_color,
          color.background = input$spin_bg,
          caption = ifelse(
            isTruthy(input$spin_caption),
            input$spin_caption,
            "Loading..."
          ),
          caption.color = input$spin_cap_color,
          hide.ui = input$spin_hide_ui,
          image = if (isTruthy(input$spin_img_url)) input$spin_img_url
        )
    )
    
  })
  
  observeEvent(input$cap_show, showSpinner("cap"))
  
  observeEvent(input$cap_hide, hideSpinner("cap"))
    
}

# Run the application 
shinyApp(ui = ui, server = server)
