# get the shiny session object
getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()

  if (is.null(session)) {
    stop("Could not find the Shiny session object. This usually happens if you're trying to call a function outside of a Shiny app.", call. = FALSE)
  }

  session
}

# insert content into the <head> tag of the document if this is a proper
# Shiny app, but if it's inside an interactive Rmarkdown document then don't
# use <head> as it won't work
insertHead <- function(...) {
  if (requireNamespace("knitr", quietly = TRUE)) {
    runtime <- knitr::opts_knit$get("rmarkdown.runtime")
    if (!is.null(runtime) && runtime == "shiny") {
      # we're inside an Rmd document
      shiny::tagList(...)
    } else {
      # we're in a shiny app
      shiny::tags$head(...)
    }
  } else {
    # we're in a shiny app
    shiny::tags$head(...)
  }

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

get_spinner_css_tag <- function(type, color, size, color.background, custom.css, id, image, caption, output_spinner) {
  base_css <- ""
  add_default_style <- (is.null(image) && !custom.css && type != 0)
  if (add_default_style) {
    if (type %in% c(2, 3) && is.null(color.background)) {
      stop("shinycssloaders: For spinner types 2 & 3 you need to specify `color.background`.")
    }

    color.rgb <- paste(grDevices::col2rgb(color), collapse = ",")
    color.alpha0 <- sprintf("rgba(%s, 0)", color.rgb)
    color.alpha2 <- sprintf("rgba(%s, 0.2)", color.rgb)

    css_file <- system.file(glue::glue("loaders-templates/load{type}.css"), package="shinycssloaders")
    if (file.exists(css_file)) {
      base_css <- paste(readLines(css_file), collapse = " ")
      base_css <- glue::glue(base_css, .open = "{{", .close = "}}")
    }

    # get default font-size from css, and cut it by 25%, as for outputs we usually need something smaller
    size_px <- round(c(11, 11, 10, 20, 25, 90, 10, 10)[type] * size * 0.75)
    base_css <- paste(base_css, glue::glue("#{id} {{ font-size: {size_px}px; }}"))
  }

  if (!is.null(caption)) {
    base_css <- paste(base_css, glue::glue("#{id}__caption {{ color: {color}; }}"))
  }

  css_rules_tag <- NULL
  if (nzchar(base_css)) {
    css_rules_tag <- insertHead(shiny::tags$style(
      class = if (!output_spinner) "global-spinner-css",
      shiny::HTML(base_css)
    ))
  }
  css_rules_tag
}
