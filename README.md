# {shinycssloaders} - Add loading animations to a Shiny output while it's recalculating 

[![CRAN](http://www.r-pkg.org/badges/version/shinycssloaders)](https://cran.r-project.org/package=shinycssloaders)
[![Travis build status](https://travis-ci.org/daattali/shinycssloaders.svg?branch=master)](https://travis-ci.org/daattali/shinycssloaders)

When a Shiny output (such as a plot, table, map, etc.) is recalculating, it remains visible but gets greyed out. Using {shinycssloaders}, you can add a loading animation ("spinner") to outputs instead of greying them out. By wrapping a Shiny output in `withSpinner()`, a spinner will automatically appear while the output is recalculating.

You can choose from one of 8 built-in animation types, and customize the colour/size. You can also use your own image instead of the built-in animations. See the [demo Shiny app](https://daattali.com/shiny/shinycssloaders-demo) online for examples.

# Table of contents

- [Example](#example)
- [How to use](#usage)
- [Installation](#install)
- [Features](#features)
- [Sponsors 🏆](#sponsors)

<h2 id="example">Example</h2>

For interactive examples and to see some of the features, [check out the demo app](https://daattali.com/shiny/shinycssloaders-demo/).

Below is a simple example of what {shinycssloaders} looks like:

![demo GIF](inst/img/demo.gif)

<h2 id="usage">How to use</h2>

Simply wrap a Shiny output in a call to `withSpinner()`. If you have `%>%` loaded, you can use it, for example `plotOutput("myplot") %>% withSpinner()`.

Basic usage:

```
library(shiny)

ui <- fluidPage(
    actionButton("go", "Go"),
    shinycssloaders::withSpinner(
        plotOutput("plot")
    )
)
server <- function(input, output) {
    output$plot <- renderPlot({
        input$go
        Sys.sleep(1.5)
        plot(runif(10))
    })
}
shinyApp(ui, server)
```

<h2 id="install">Installation</h2>

To install the stable CRAN version:

```
install.packages("shinycssloaders")
```

To install the latest development version from GitHub:

```
install.packages("remotes")
remotes::install_github("daattali/shinycssloaders")
```

<h2 id="features">Features</h2>

### 8 customizable built-in spinners

You can use the `type` parameter to choose one of the 8 built-in animations, the `color` parameter to change the spinner's colour, and `size` to make the spinner smaller or larger (2 will make the spinner twice as large). For example, `withSpinner(plotOutput("myplot"), type = 5, color = "#0dc5c1", size = 2)`. 

### Setting spinner parameters globally

If you want all the spinners in your app to have a certain type/size/colour, instead of specifying them in each call to `withSpinner()`, you can set them globally using the `spinner.type`, `spinner.color`, `spinner.size` R options. For example, setting `options(spinner.color="#0dc5c1")` will cause all your spinners to use that colour.

### Using a custom image

If you don't want to use any of the built-in spinners, you can also provide your own image (either a still image or a GIF) to use instead, using the `image` parameter.

### Specifying the spinner height

The spinner attempts to automatically figure out the height of the output it replaces, and to vertically center itself. For some outputs (such as tables), the height is unknown, so the spinner will assume the output is 400px tall. If your output is expected to be significantly smaller or larger, you can use the `proxy.height` parameter to adjust this.

### Showing a spinner on top of the output

By default, the out-dated output gets hidden while the spinner is showing. You can change this behaviour to have the spinner appear on top of the old output using the `hide.ui = FALSE` parameter.

### Background colour

Spinner types 2 and 3 require you to specify a background colour. It's recommended to use a colour that matches the background colour of the output's container, so that the spinner will "blend in". 

<h2 id="sponsors">

Sponsors 🏆

</h2>

> There are no sponsors yet

[Become the first sponsor for
{shinycssloaders}\!](https://github.com/sponsors/daattali)

## Credits

The 8 built-in animations are taken from [https://projects.lukehaas.me/css-loaders/](https://projects.lukehaas.me/css-loaders/).

The package was originally created by [Andrew Sali](https://github.com/andrewsali).
