# shinycssloaders 1.0.0 (2020-07-28)

- Add support for custom images with `image` parameter (#46)
- Add support for making the spinner show up on top of the output instead of replacing it, with a `hide.ui` parameter (#22)
- Add `id` parameter to `withSpinner()` to allow you to target a specific spinner with CSS (#19)
- Allow spinner type 0, which means no loading icon is shown (#18)
- Changed the license from GPL-3 to MIT
- Fix bug where loaders weren't working in uiOutput (#39)
- Fix bug where `withSpinner()` was causing `shiny::appendTab()` to break (#45)
- Add support for `proxy.height` to be specified as a number instead of a string (`300` vs `"300px"`)
- Fixed bug where spinner wasn't showing up for certain output IDs such as "map" (#49)
- Clarify the `custom.css` parameter which was causing confusion (#21)
- Don't expose 'assets' as a resourch path because it blocks shiny apps from having a www/assets/ folder (#48)
- Internal refactoring: Use one CSS file for all styles, and use CSS files to load custom CSS of each style (#37)
- Added a sample Shiny app "demo" that lets you experiment with all loader types and parameters
- File cleanup: Remove all files and dirs from inst/css-loaders and only keep the CSS (#38)
- Removed the default value of `proxy.height` parameter to simplify the function documentation

# shinycssloaders 0.3 (2020-01-14)

- Remove debug message from JS console (#26)
- Ensure spinner doesn't show forever when used on dynamic outputs 
- Fix bug that caused errors with outputs with special ID characters and caused errors when using shiny bookmarks (#16)
- Fix type 1 and type 7 spinners on IE11 (#1)
- Dean Attali took over as maintainer of the package

# shinycssloaders 0.2.0

## New features

* Better support for outputs with non-fixed height (e.g. tables with heights depending on the data received from the server), by embedding a 'proxy' container which contains the spinner. An attempt is made to automatically deduce if the output has fixed / variable height and in the latter case the proxy container will have a default height of '400px'. Otherwise the `proxy.height` option can be used to explicitly control the size of the proxy container.

## Bug-fixes

* Fix vertical scroll-bar appearing for Type 3 spinners
* Fix error message still showing when recalculating for htmlwidgets
 
# shinycssloaders 0.1.0

The first working version of the package. 
