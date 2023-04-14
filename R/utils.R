get_proxy_element <- function(ui_element, proxy.height, hide.ui) {
  if (!hide.ui) {
    return(shiny::tagList())
  }

  if (is.null(proxy.height)) {
    if (!grepl("height:\\s*\\d", ui_element)) {
      proxy.height <- "400px"
    }
  } else {
    if (is.numeric(proxy.height)) {
      proxy.height <- paste0(proxy.height, "px")
    }
  }

  if (is.null(proxy.height)) {
    proxy_element <- shiny::tagList()
  } else {
    proxy_element <- shiny::div(style=glue::glue("height:{proxy.height}"),
                                class="shiny-spinner-placeholder")
  }
}

add_style <- function(x, class = NULL) {
  if (x == "") {
    return(NULL)
  }
  shiny::tags$head(
    shiny::tags$style(
      class = class,
      shiny::HTML(
        x
      )
    )
  )
}

# get the shiny session object
getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()

  if (is.null(session)) {
    stop("Could not find the Shiny session object. This usually happens if you're trying to call a function outside of a Shiny app.", call. = FALSE)
  }

  session
}

getDependencies <- function() {
  list(
    htmltools::htmlDependency(
      name = "shinycssloaders-binding",
      version = as.character(utils::packageVersion("shinycssloaders")),
      package = "shinycssloaders",
      src = "assets",
      script = "spinner.js",
      stylesheet = "spinner.css"
    ),
    htmltools::htmlDependency(
      name = "cssloaders",
      version = as.character(utils::packageVersion("shinycssloaders")),
      package = "shinycssloaders",
      src = "assets",
      stylesheet = "css-loaders.css"
    )
  )
}
