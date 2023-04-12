buildSpinner <- function(
    spinner_type = c("output", "page"),
    ui_element,
    type,
    color,
    size,
    color.background,
    custom.css,
    proxy.height,
    id,
    image,
    image.width,
    image.height,
    hide.ui
) {
  spinner_type <- match.arg(spinner_type)
  output_spinner <- (spinner_type == "output")

  if (!type %in% 0:8) {
    stop("`type` must be an integer from 0 to 8", call. = FALSE)
  }
  if (grepl("rgb", color, fixed = TRUE)) {
    stop("Color should be given in hex format")
  }
  if (is.character(custom.css)) {
    stop("It looks like you provided a string to 'custom.css', but it needs to be either `TRUE` or `FALSE`. ",
         "The actual CSS needs to added to the app's UI.")
  }

  # each spinner will have a unique id to allow separate sizing
  if (is.null(id)) {
    id <- paste0("spinner-", digest::digest(ui_element))
  }

  css_size_color <- shiny::tagList()
  add_default_style <- (is.null(image) && !custom.css && type != 0)

  if (add_default_style) {
    if (type %in% c(2, 3) && is.null(color.background)) {
      stop("For spinner types 2 & 3 you need to specify manually a background color.")
    }

    color.rgb <- paste(grDevices::col2rgb(color), collapse = ",")
    color.alpha0 <- sprintf("rgba(%s, 0)", color.rgb)
    color.alpha2 <- sprintf("rgba(%s, 0.2)", color.rgb)

    css_file <- system.file(glue::glue("loaders-templates/load{type}.css"), package="shinycssloaders")
    base_css <- ""
    if (file.exists(css_file)) {
      base_css <- paste(readLines(css_file), collapse = " ")
      base_css <- glue::glue(base_css, .open = "{{", .close = "}}")
    }

    # get default font-size from css, and cut it by 25%, as for outputs we usually need something smaller
    size <- round(c(11, 11, 10, 20, 25, 90, 10, 10)[type] * size * 0.75)
    base_css <- paste(base_css, glue::glue("#{id} {{ font-size: {size}px; }}"))
    css_size_color <- add_style(base_css)
  }

  if (output_spinner) {
    proxy_element <- get_proxy_element(ui_element, proxy.height, hide.ui)
  } else {
    proxy_element <- NULL
  }

  deps <- list(
    htmltools::htmlDependency(
      name = "shinycssloaders-binding",
      version = as.character(utils::packageVersion("shinycssloaders")),
      package = "shinycssloaders",
      src = "assets",
      script = "spinner.js",
      stylesheet = "spinner.css"
    )
  )

  if (is.null(image)) {
    deps <- append(deps, list(htmltools::htmlDependency(
      name = "cssloaders",
      version = as.character(utils::packageVersion("shinycssloaders")),
      package = "shinycssloaders",
      src = "assets",
      stylesheet = "css-loaders.css"
    )))
  }

  parent_cls <- "shiny-spinner-output-container"
  if (hide.ui) {
    parent_cls <- paste(parent_cls, "shiny-spinner-hideui")
  }
  if (!is.null(image)) {
    parent_cls <- paste(parent_cls, "shiny-spinner-custom")
  }

  child_cls <- "load-container"
  if (output_spinner) {
    child_cls <- paste(child_cls, "shiny-spinner-hidden")
  }
  if (is.null(image)) {
    child_cls <- paste(child_cls, paste0("load", type))
  }

  if (is.null(image)) {
    spinner_el <- shiny::div(id = id, class = "loader",
                             (if (type == 0) "" else "Loading..."))
  } else {
    spinner_el <- shiny::tags$img(id = id, src = image, alt = "Loading...",
                                  width = image.width, height = image.height)
  }

  shiny::tagList(
    deps,
    css_size_color,
    shiny::div(
      class = parent_cls,
      shiny::div(
        class = child_cls,
        spinner_el
      ),
      proxy_element,
      ui_element
    )
  )
}
