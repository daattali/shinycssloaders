# shinycssloaders
Add CSS loader animations (spinners) to Shiny Outputs (e.g. plots, tables) in an automated fashion. Loading animations leverage on [Shiny JS events](https://shiny.rstudio.com/articles/js-events.html) and will show whilst the output value is not yet available or is 'out-of-date' (i.e. has been invalidated and the client hasn't received the new value). The spinners won't show if the output is not rendered (e.g. a `validate` or `req` is preventing it from being shown).

You can use it for any type of shiny output, by wrapping the UI element with the `withSpinner` tag:

```
# load the library
library(shinycssloaders)

...

withSpinner(plotOutput("my_plot")) 
# if you have `%>%` loaded, you can do plotOutput("my_plot") %>% withSpinner()

...
```

## Installation

The package is not yet on CRAN, you can use the `devtools` package to install it from github directly:

```
devtools::install_github('andrewsali/shinycssloaders')
```
## Demo

To see how this works in action, you can run the example application from github directly:

```
shiny::runGitHub('andrewsali/shinycssloaders')
```
## Changing the spinner colour

You can specify a spinner colour for each output or set a variable globally. 

### Locally for each output

Just add `color` attribute to `withSpinner`:

```
plotOutput("my_plot") %>% withSpinner(color="rgb(100,100,100)")
```

### Globally

You can use `options(spinner.color="rgb(100,100,100)")` to set the global colour.

### Background color

Spinner types 2-3 require you to specify a background color as well, which should match the background color of the container hosting the output. The other spinners work automatically without having to specify a background color.

## Changing the spinner size

The spinners scale in a relative fashion by specifying the `size` argument of withSpinner (default value is 1, so if you need to double the spinner for example, set size to 2). You can also set the size globally using `options(spinner.size=my_size)`. 
