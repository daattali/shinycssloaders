.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(prefix = "assets",directoryPath = system.file("assets",package="shinycssloaders"))
  shiny::addResourcePath(prefix = "css-loaders",directoryPath = system.file("css-loaders",package="shinycssloaders"))
  if (is.null(getOption("spinner.type"))) {
    options(spinner.type = 1)
  }
  # use default size
  if (is.null(getOption("spinner.size"))) {
    options(spinner.size = 1)
  }
  # set default colour
  if (is.null(getOption("spinner.color"))) {
    options(spinner.color="#0275D8")
  }
}
