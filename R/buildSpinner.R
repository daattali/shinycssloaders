buildSpinner <- function(
    spinner_type = c("output", "page"),
    ui_element,
    type,
    color,
    size,
    color.background,
    proxy.height,
    id,
    image,
    image.width,
    image.height,
    hide.ui,
    caption,
    delay,
    inline,
    width,
    fill
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

  if (is.null(id)) {
    id <- paste0("spinner-", digest::digest(ui_element))
  }

  css_rules_tag <- get_spinner_css_tag(type, color, size, color.background, id,
                                       image, caption, width, output_spinner)

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
  if (inline) {
    parent_cls <- paste(parent_cls, "shiny-spinner-inline")
  }
  if (fill) {
    # in the future, when bslib becomes more mature, consider using bslib::as_fill_carrier() instead
    parent_cls <- paste(parent_cls, "html-fill-item html-fill-container")
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

  shiny::div(
    css_rules_tag,
    `data-spinner-id` = id,
    `data-spinner-delay` = if (delay == 0) NULL else delay,
    class = parent_cls,
    shiny::div(
      class = child_cls,
      spinner_el,
      caption
    ),
    proxy_element,
    ui_element
  )
}
