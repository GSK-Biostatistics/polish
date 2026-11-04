fixture_gt <- function(version) {
  readRDS(test_path("fixtures", sprintf("mtcars_gt_%s.RDS", version)))
}

fixture_versions <- c("1.0.0", "1.3.0", "1.4.0")

test_that("repair_gt() brings old gt objects to the installed gt's structure", {
  skip_if_not_installed("gt")
  template <- gt::gt(data.frame())

  for (v in fixture_versions) {
    fixed <- repair_gt(fixture_gt(v))
    expect_s3_class(fixed, "gt_tbl")
    expect_identical(names(fixed), names(template))
    expect_true(all(template[["_options"]]$parameter %in% fixed[["_options"]]$parameter))
    for (n in setdiff(names(template), "_data")) {
      if (is.data.frame(template[[n]])) {
        expect_true(all(names(template[[n]]) %in% names(fixed[[n]])), info = paste(v, n))
      }
    }
  }
})

test_that("repair_gt() makes old objects renderable", {
  skip_if_not_installed("gt")

  for (v in fixture_versions) {
    expect_no_error(gt::as_raw_html(repair_gt(fixture_gt(v))))
  }
})

test_that("repair_gt() renders the same as a table rebuilt from the data", {
  skip_if_not_installed("gt")
  strip_ids <- function(x) {
    gsub('id="[a-z]+"|#[a-z]{10}', "", as.character(gt::as_raw_html(x)))
  }

  for (v in fixture_versions) {
    old <- fixture_gt(v)
    expect_identical(
      strip_ids(repair_gt(old)),
      strip_ids(repair_gt(fixture_gt("1.4.0")))
    )
  }
})

test_that("repair_gt() is idempotent and preserves existing values", {
  skip_if_not_installed("gt")

  for (v in fixture_versions) {
    old <- fixture_gt(v)
    once <- repair_gt(old)

    expect_identical(repair_gt(once), once)
    expect_identical(once[["_data"]], old[["_data"]])
    expect_identical(once[["_boxhead"]], old[["_boxhead"]])

    kept <- old[["_options"]]
    expect_identical(
      once[["_options"]]$value[match(kept$parameter, once[["_options"]]$parameter)],
      kept$value
    )
  }
})
