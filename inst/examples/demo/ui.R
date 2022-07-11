library(shiny)

share <- list(
  title = "{shinycssloaders} package",
  url = "https://daattali.com/shiny/shinycssloaders-demo/",
  image = "https://daattali.com/shiny/img/shinycssloaders.png",
  description = "Add loading animations to a Shiny output while it's recalculating",
  twitter_user = "daattali"
)

fluidPage(
  shinyjs::useShinyjs(),
  title = paste0("{shinycssloaders} package ", as.character(packageVersion("shinycssloaders"))),
  tags$head(
    includeCSS(file.path('www', 'style.css')),
    # Favicon
    tags$link(rel = "shortcut icon", type="image/x-icon", href="https://daattali.com/shiny/img/favicon.ico"),
    # Facebook OpenGraph tags
    tags$meta(property = "og:title", content = share$title),
    tags$meta(property = "og:type", content = "website"),
    tags$meta(property = "og:url", content = share$url),
    tags$meta(property = "og:image", content = share$image),
    tags$meta(property = "og:description", content = share$description),
    
    # Twitter summary cards
    tags$meta(name = "twitter:card", content = "summary_large_image"),
    tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:title", content = share$title),
    tags$meta(name = "twitter:description", content = share$description),
    tags$meta(name = "twitter:image", content = share$image)
  ),
  
  shinydisconnect::disconnectMessage2(),
  
  div(
    id = "header",
    div(id = "pagetitle",
        "{shinycssloaders} package"
    ),
    div(id = "subtitle",
        "Add loading animations to a Shiny output while it's recalculating"),
    div(id = "subsubtitle",	
        "Maintained by",	
        tags$a(href = "https://deanattali.com/", "Dean Attali"),	
        HTML("&bull;"),	
        "Code",	
        tags$a(href = "https://github.com/daattali/shinycssloaders", "on GitHub"),	
        HTML("&bull;"),	
        tags$a(href = "https://github.com/sponsors/daattali", "Support my work"), "❤"	
    )
  ),
  
  fluidRow(
    column(
      3,
      id = "params",
      selectInput("type", "Spinner type",
                  c("<Custom image>" = "custom", "0 (no spinner)" = "0", 1:8), 1),
      conditionalPanel(
        "input.type == 'custom'",
        textInput(
          "image",
          div("Image URL", 
              helpText("Only publicly available URLs are supported in this demo, but you can also use local images in your own apps.")
          ),
          "https://github.com/daattali/shinycssloaders/blob/master/inst/img/custom.gif?raw=true"
        ),
        checkboxInput("image_size_default", "Use original image width/height", TRUE),
        conditionalPanel(
          "input.image_size_default == false",
          fluidRow(
            column(6, numericInput("image.width", "Image width", 100)),
            column(6, numericInput("image.height", "Image height", 100))
          )
        )
      ),
      conditionalPanel(
        "input.type != 'custom'",
        colourpicker::colourInput("col", "Color", "#0275D8", showColour = "background"),
        sliderInput("size", "Size", min = 0.5, max = 5, step = 0.5, value = 1)
      ),
      numericInput("time", "Seconds to show spinner", 1.5),
      actionButton("update", "Update", class = "btn-primary btn-lg"),
    ),
    column(
      6,
      uiOutput("show_example")
    )
  )
)
