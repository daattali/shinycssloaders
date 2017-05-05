.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(prefix = "assets",directoryPath = system.file("assets",package="shinycssloaders"))
  shiny::addResourcePath(prefix = "css-loaders",directoryPath = system.file("css-loaders",package="shinycssloaders"))
  options(spinner.type = 1)
  # use default size
  options(spinner.size = 1)
  # set default colour
  options(spinner.color="#0275D8")
}
