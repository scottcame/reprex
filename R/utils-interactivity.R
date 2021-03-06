## wrap clipr::clipr_available() so I can tweak its behaviour
clipboard_available <- function() {
  if (interactive()) {
    clipr::clipr_available()
  } else {
    isTRUE(as.logical(Sys.getenv("CLIPR_ALLOW", FALSE)))
  }
}

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

## this function can be replaced by rlang::is_interactive()
## if this gets merged + released
## https://github.com/r-lib/rlang/pull/761
interactive <- function() {
  rlang::is_interactive() && !is_testing()
}

## returns TRUE if user says "no"
##         FALSE otherwise
nope <- function(..., yes = "yes", no = "no") {
  if (interactive()) {
    cat(paste0(..., collapse = ""))
    return(utils::menu(c(yes, no)) == 2)
  }
  FALSE
}

## returns TRUE if user says "yes"
##         FALSE otherwise
yep <- function(..., yes = "yes", no = "no") {
  if (interactive()) {
    cat(paste0(..., collapse = ""))
    return(utils::menu(c(yes, no)) == 1)
  }
  FALSE
}
