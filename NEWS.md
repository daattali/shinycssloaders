# shinycssloaders 0.2.0

## New features

* Better support for outputs with non-fixed height (e.g. tables with heights depending on the data received from the server), by embedding a 'proxy' container which contains the spinner. An attempt is made to automatically deduce if the output has fixed / variable height and in the latter case the proxy container will have a default height of '400px'. Otherwise the `proxy.height` option can be used to explicitly control the size of the proxy container.

## Bug-fixes

* Fix vertical scroll-bar appearing for Type 3 spinners
* Fix error message still showing when recalculating for htmlwidgets
 
# shinycssloaders 0.1.0

The first working version of the package. 
