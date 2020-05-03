library(shiny)

share <- list(
  title = "shinycssloaders package",
  url = "https://daattali.com/shiny/shinycssloaders-demo/",
  image = "https://daattali.com/shiny/img/shinycssloaders.png",
  description = "Add loading animations to a Shiny output while it's recalculating",
  twitter_user = "daattali"
)

fluidPage(
  title = paste0("shinycssloaders package ", as.character(packageVersion("shinycssloaders"))),
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
    tags$meta(name = "twitter:card", content = "summary"),
    tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:title", content = share$title),
    tags$meta(name = "twitter:description", content = share$description),
    tags$meta(name = "twitter:image", content = share$image)
  ),
  tags$a(
    href="https://github.com/daattali/shinycssloaders",
    tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
             src="github-green-right.png",
             alt="Fork me on GitHub")
  ),

  div(
    id = "header",
    div(id = "pagetitle",
        "shinycssloaders package"
    ),
    div(id = "subtitle",
        "Add loading animations to a Shiny output while it's recalculating"),
    div(id = "subsubtitle",
        "Maintained by",
        tags$a(href = "https://deanattali.com/", "Dean Attali"),
        HTML("&bull;"),
        "Available",
        tags$a(href = "https://github.com/daattali/shinycssloaders", "on GitHub"),
        HTML("&bull;"),
        tags$a(href = "https://daattali.com/shiny/", "More apps"), "by Dean"
    )
  ),
  
  fluidRow(
    column(
      3,
      selectInput("type", "Spinner type", c("0 (no spinner)" = "0", 1:8), 1),
      colourpicker::colourInput("col", "Color", "#0275D8", showColour = "background"),
      conditionalPanel(
        "input.type == '2' || input.type == '3'",
        colourpicker::colourInput("background", "Background Color", "white", showColour = "background")
      ),
      numericInput("time", "Seconds to show spinner", 1.5),
      sliderInput("size", "Size", min = 0.5, max = 5, step = 0.5, value = 1),
      actionButton("update", "Update", class = "btn-primary"),
    ),
    column(
      9,
      uiOutput("show_example")
    )
  )
)
