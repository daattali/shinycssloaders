.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(prefix = "assets",directoryPath = system.file("assets",package="shinycssloaders"))
  shiny::addResourcePath(prefix = "css-loaders",directoryPath = system.file("css-loaders",package="shinycssloaders"))
}
