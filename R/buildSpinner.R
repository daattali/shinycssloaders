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
    hide.ui,
    caption
) {
  spinner_type <- match.arg(spinner_type)
  output_spinner <- (spinner_type == "output")

  if (!is.null(image)) {
    type <- 0
  }
  if (!type %in% 0:8) {
    stop("shinycssloaders: `type` must be an integer between 0 and 8.")
  }
  if (grepl("rgb", color, fixed = TRUE)) {
    stop("shinycssloaders: `color` should be given in hex format (#XXXXXX).")
  }
  if (is.character(custom.css)) {
    stop("shinycssloaders: It looks like you provided a string to `custom.css`, but it needs to be either `TRUE` or `FALSE`. ",
         "The actual CSS needs to added to the app's UI.")
  }
  if (type == 1 && !is.null(caption)) {
    warning("shinycssloaders: `caption` is not supported for spinner type 1")
    caption <- NULL
  }

  # each spinner will have a unique id to allow separate sizing
  if (is.null(id)) {
    id <- paste0("spinner-", digest::digest(ui_element))
  }

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

  css_rules <- add_style(base_css, if (!output_spinner) "global-spinner-css")

  if (!is.null(caption)) {
    caption <- shiny::div(
      id = paste0(id, "__caption"),
      class = "shiny-spinner-caption",
      caption
    )
  }

  if (output_spinner) {
    proxy_element <- get_proxy_element(ui_element, proxy.height, hide.ui)
  } else {
    proxy_element <- NULL
  }

  parent_cls <- "shiny-spinner-output-container"
  if (hide.ui) {
    parent_cls <- paste(parent_cls, "shiny-spinner-hideui")
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
    css_rules,
    shiny::div(
      `data-spinner-id` = id,
      class = parent_cls,
      shiny::div(
        class = child_cls,
        spinner_el,
        caption
      ),
      proxy_element,
      ui_element
    )
  )
}
