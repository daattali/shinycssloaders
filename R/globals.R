.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(prefix = "shinycssloaders-assets", directoryPath = system.file("assets", package = "shinycssloaders"))
}
