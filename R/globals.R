.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(prefix = "assets",directoryPath = system.file("assets",package="shinycssloaders"))
  shiny::addResourcePath(prefix = "loaders-templates",directoryPath = system.file("loaders-templates",package="shinycssloaders"))
}
