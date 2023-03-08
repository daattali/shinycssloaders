# {shinycssloaders} - Add loading animations to a Shiny output while it's recalculating 

[![R-CMD-check](https://github.com/daattali/shinycssloaders/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/daattali/shinycssloaders/actions/workflows/R-CMD-check.yaml)
[![CRAN](http://www.r-pkg.org/badges/version/shinycssloaders)](https://cran.r-project.org/package=shinycssloaders)

When a Shiny output (such as a plot, table, map, etc.) is recalculating, it remains visible but gets greyed out. Using {shinycssloaders}, you can add a loading animation ("spinner") to outputs instead of greying them out. By wrapping a Shiny output in `withSpinner()`, a spinner will automatically appear while the output is recalculating. You can also manually trigger a spinner using `showSpinner()`.

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

**For most users:** To install the stable CRAN version:

```
install.packages("shinycssloaders")
```

**For advanced users:** To install the latest development version from GitHub:

```
install.packages("remotes")
remotes::install_github("daattali/shinycssloaders")
```

<h2 id="features">Features</h2>

### 8 customizable built-in spinners

You can use the `type` parameter to choose one of the 8 built-in animations, the `color` parameter to change the spinner's colour, and `size` to make the spinner smaller or larger (2 will make the spinner twice as large). For example, `withSpinner(plotOutput("myplot"), type = 5, color = "#0dc5c1", size = 2)`. 

### Using a custom image

If you don't want to use any of the built-in spinners, you can also provide your own image (either a still image or a GIF) to use instead, using the `image` parameter.

### Specifying the spinner height

The spinner attempts to automatically figure out the height of the output it replaces, and to vertically center itself. For some outputs (such as tables), the height is unknown, so the spinner will assume the output is 400px tall. If your output is expected to be significantly smaller or larger, you can use the `proxy.height` parameter to adjust this.

### Manually triggering the spinner

Any Shiny output that uses `withSpinner()` will automatically show a spinner while it's recalculating. You can also manually show/hide an output's spinner using `showSpinner()`/`hideSpinner()`. 

### Setting spinner parameters globally

If you want all the spinners in your app to share some of the options, instead of specifying them in each call to `withSpinner()`, you can set them globally using R options. For example, if you want all spinners to be of a certain type and color, you can set `options(spinner.type = 5, spinner.color = "#0dc5c1")`.

### Showing a spinner on top of the output

By default, the out-dated output gets hidden while the spinner is showing. You can change this behaviour to have the spinner appear on top of the old output using the `hide.ui = FALSE` parameter.

<h2 id="sponsors">

Sponsors 🏆

</h2>

> There are no sponsors yet

[Become the first sponsor for
{shinycssloaders}\!](https://github.com/sponsors/daattali/sponsorships?tier_id=39856)

## Credits

The 8 built-in animations are taken from [https://projects.lukehaas.me/css-loaders/](https://projects.lukehaas.me/css-loaders/).

The package was originally created by [Andrew Sali](https://github.com/andrewsali).
