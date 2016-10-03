#!/usr/bin/env r

if (is.null(argv) | length(argv)<1) {
  cat("Usage: installr_github.r pkg1 [pkg2 pkg3 ...]\n")
  q()
}

library(devtools)

install_github(argv)
