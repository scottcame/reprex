context("venues")

test_that("venue = 'gh' works with/without leading prose", {
  skip_on_cran()
  input <- c(
    "#' Hello world",
    "## comment",
    "1:5"
  )
  output <- c(
    "Hello world",
    "",
    "``` r",
    "## comment",
    "1:5",
    "#> [1] 1 2 3 4 5",
    "```"
  )
  ret <- reprex(input = input, venue = "gh", show = FALSE, advertise = FALSE)
  expect_identical(ret, output)

  input <- grep("Hello", input, invert = TRUE, value = TRUE)
  output <- grep("Hello", output, invert = TRUE, value = TRUE)
  output <- output[nzchar(output)]
  ret <- reprex(input = input, venue = "gh", show = FALSE, advertise = FALSE)
  expect_identical(ret, output)
})

test_that("venue = 'R' works, regardless of case", {
  skip_on_cran()
  input <- c(
    "#' Hello world",
    "## comment",
    "1:5"
  )
  output <- c(
    "#' Hello world",
    "## comment",
    "1:5",
    "#> [1] 1 2 3 4 5"
  )
  ret <- reprex(input = input, venue = "R", show = FALSE, advertise = FALSE)
  expect_identical(ret[nzchar(ret)], output)
  ret <- reprex(input = input, venue = "r", show = FALSE, advertise = FALSE)
  expect_identical(ret[nzchar(ret)], output)
})

test_that("venues = 'ds' and 'so' are aliases for 'gh'", {
  skip_on_cran()
  input <- c(
    "#' Hello world",
    "## comment",
    "1:5"
  )
  ds <- reprex(input = input, venue = "ds", si = TRUE, show = FALSE, advertise = FALSE)
  so <- reprex(input = input, venue = "so", si = TRUE, show = FALSE, advertise = FALSE)
  gh <- reprex(input = input, venue = "gh", si = TRUE, show = FALSE, advertise = FALSE)
  expect_identical(so, gh)
  expect_identical(ds, gh)
})

test_that("local image link is not interrupted by hard line break for 'gh'", {
  skip_on_cran()
  input <- c(
    "#+ setup, include = FALSE",
    "knitr::opts_knit$set(upload.fun = identity)",
    "",
    "#+ incredibly-long-chunk-name-to-make-image-path-also-incredibly-long",
    "plot(1:3)"
  )
  out <- reprex(input = input, venue = "gh", show = FALSE)
  i <- grep("incredibly-long", out)
  expect_true(grepl("[)]", out[i]))
})

test_that("venue = 'html' works", {
  skip_on_cran()
  input <- c(
    "#' Hello world",
    "## comment",
    "1:5"
  )
  output <- c(
    "<p>Hello world</p>",
    "<pre class=\"r\"><code>## comment",
    "1:5",
    "#&gt; [1] 1 2 3 4 5</code></pre>"
  )
  ret <- reprex(input = input, venue = "html", show = FALSE, advertise = FALSE)
  ret <- ret[nzchar(ret)]
  expect_identical(ret, output)
})

test_that("venue = 'plain-md' has no md syntax indicator nor ad by default", {
  skip_on_cran()
  input <- c(
    "#' Hello world",
    "## comment",
    "1:5"
  )
  ret <- reprex(input = input, venue = "plain-md", show = FALSE)
  expect_equal(sum(grepl(x=ret, pattern='```')), 2)
  expect_true(!any(grepl(x=ret, pattern='```.+r')))
  expect_true(!any(grepl(x=ret, pattern='<sup>Created on.+by the.+/sup')))
  ret <- reprex(input = input, venue = "plain-md", show = FALSE, advertise = TRUE)
  expect_true(any(grepl(x=ret, pattern='<sup>Created on.+by the.+/sup')))
})
