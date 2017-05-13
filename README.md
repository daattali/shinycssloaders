# shinycssloaders
Add loader animations (spinners) to Shiny Outputs (e.g. plots, tables) in an automated fashion. Loading animations leverage on [Shiny JS events](https://shiny.rstudio.com/articles/js-events.html) and will show whilst the output value is not yet available or is 'out-of-date' (i.e. has been invalidated and the client hasn't received the new value). The spinners won't show if the output is not rendered (e.g. a `validate` or `req` is preventing it from being shown).

The advantages of using this package are:

* Automatic spinner showing / hiding. Just add one extra R function call (see below) and your output will have the spinner showing at just the right times
* Customizeable spinner colour (for each output or globally)
* Customizeable spinner size (for each output or globally)
* Choose from 8 different well-designed spinner types 

The CSS animations are bundled from [https://projects.lukehaas.me/css-loaders/](https://projects.lukehaas.me/css-loaders/), where you can see how they appear.

You can use it for any type of shiny output, by wrapping the UI element with the `withSpinner` tag:

```
# load the library
library(shinycssloaders)

...

withSpinner(plotOutput("my_plot")) 
# if you have `%>%` loaded, you can do plotOutput("my_plot") %>% withSpinner()

...
```

> For outputs with uknown heights (e.g. tables), a 'proxy' container will be inserted, as the spinner cannot be centered with respect to a height that is uknown to the client (e.g. you might return a really large / small table, who knows?). By default the proxy container will be of height '400px', however if your output is expected to be substantially larger / smaller, you can adjust this with `proxy.height` option.

## Installation

The package is now available on CRAN, however for the latest (and hopefully greatest!) version you can use the `devtools` package to install it from github directly:

```
devtools::install_github('andrewsali/shinycssloaders')
```
## Demo

To see how this works in action, you can check my example on [shinyapps.io](https://frontside.shinyapps.io/example/) or run the example application from github directly:

```
shiny::runGitHub('andrewsali/shinycssloaders',subdir="example")
```

To see how the spinner works for outputs with undefined height, you can check out [this example](https://frontside.shinyapps.io/table/) or run it from github directly:

```
shiny::runGitHub('andrewsali/shinycssloaders',subdir="example/table")
```


## Changing the spinner colour

You can specify a spinner colour for each output or set a variable globally. 

### Locally for each output

Just add `color` attribute to `withSpinner`:

```
plotOutput("my_plot") %>% withSpinner(color="#0dc5c1")
```

### Globally

You can use `options(spinner.color="#0dc5c1")` to set the global colour.

### Background color

Spinner types 2-3 require you to specify a background color as well, which should match the background color of the container hosting the output. The other spinners work automatically without having to specify a background color.

## Changing the spinner size

The spinners scale in a relative fashion by specifying the `size` argument of withSpinner (default value is 1, so if you need to double the spinner for example, set size to 2). You can also set the size globally using `options(spinner.size=my_size)`. 
