library(testthat)

test_that("Test finding layout file", {
  plate_filepath <- system.file("extdata", "CovidOISExPONTENT_CO.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  random_plate_filepath <- system.file("extdata", "random_intelliflex.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  layout_filepath <- system.file("extdata", "CovidOISExPONTENT_CO_layout.xlsx", package = "SerolyzeR", mustWork = TRUE)

  output <- find_layout_file(plate_filepath)
  expect_true(check_path_equal(output, layout_filepath))

  output <- find_layout_file(plate_filepath, layout_filepath)
  expect_true(check_path_equal(output, layout_filepath))

  expect_warning(find_layout_file(random_plate_filepath))

  expect_error(find_layout_file("non_existing_file.csv"))
  expect_error(find_layout_file("non_existing_file.csv", "incorrect_layout.xlsx"))
})

test_that("Test checking for mba file", {
  plate1_filepath <- system.file("extdata", "CovidOISExPONTENT.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  plate2_filepath <- system.file("extdata", "CovidOISExPONTENT_CO.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  plate3_filepath <- system.file("extdata", "random_intelliflex.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  non_matched_filepath <- system.file("extdata", "random.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  layout_filepath <- system.file("extdata", "CovidOISExPONTENT_CO_layout.xlsx", package = "SerolyzeR", mustWork = TRUE)

  expect_true(is_mba_data_file(plate1_filepath))
  expect_true(is_mba_data_file(plate2_filepath))
  expect_true(is_mba_data_file(plate3_filepath))
  expect_false(is_mba_data_file(non_matched_filepath))
  expect_false(is_mba_data_file(layout_filepath))
})

test_that("Test detecting format", {
  plate1_filepath <- system.file("extdata", "CovidOISExPONTENT.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  plate2_filepath <- system.file("extdata", "CovidOISExPONTENT_CO.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  plate3_filepath <- system.file("extdata", "random_intelliflex.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset

  expect_equal(detect_mba_format(plate1_filepath), "xPONENT")
  expect_equal(detect_mba_format(plate2_filepath), "xPONENT")
  expect_equal(detect_mba_format(plate3_filepath), "INTELLIFLEX")
  expect_equal(detect_mba_format(NULL, format = "INTELLIFLEX"), "INTELLIFLEX")
})

test_that("Test obtaining an output directory", {
  plate_filepath <- system.file("extdata", "multiplate_mock", "other", "random2_xponent.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  input_dir <- fs::path_dir(plate_filepath)
  input_dir_parent <- fs::path_dir(input_dir)
  specified_output_dir <- fs::path(tempdir(check = TRUE))
  specified_output_dir_plus <- fs::path_join(c(specified_output_dir, fs::path("other")))

  expect_equal(get_output_dir(plate_filepath, input_dir), input_dir)
  expect_equal(get_output_dir(
    plate_filepath, input_dir_parent,
    flatten_output_dir = FALSE
  ), input_dir)
  expect_equal(get_output_dir(
    plate_filepath, input_dir_parent,
    flatten_output_dir = TRUE
  ), input_dir_parent)
  expect_equal(get_output_dir(
    plate_filepath, input_dir_parent,
    output_dir = specified_output_dir
  ), specified_output_dir_plus)
  expect_equal(get_output_dir(
    plate_filepath, input_dir_parent,
    output_dir = specified_output_dir,
    flatten_output_dir = TRUE
  ), specified_output_dir)

  expect_error(get_output_dir(plate_filepath, "no_dir", "bad_dir"))

  expect_error(process_dir(input_dir, output = "non-existing"))
})


test_that("Test processing a mock directory", {
  dir <- system.file("extdata", "multiplate_mock", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  expect_no_error(capture.output(
    process_dir(dir, dry_run = TRUE, recurse = TRUE, flatten_output_dir = TRUE)
  ))
  expect_no_error(capture.output(
    process_dir(dir, dry_run = TRUE, recurse = FALSE, flatten_output_dir = TRUE)
  ))
  expect_no_error(capture.output(
    process_dir(dir, dry_run = TRUE, recurse = TRUE, flatten_output_dir = FALSE)
  ))
  expect_no_error(capture.output(
    process_dir(dir, dry_run = TRUE, recurse = TRUE, flatten_output_dir = FALSE, output_dir = tempdir(check = TRUE))
  ))

  expect_no_error(capture.output(
    process_dir(dir,
      dry_run = TRUE, recurse = TRUE, flatten_output_dir = FALSE, output_dir = tempdir(check = TRUE),
      generate_reports = TRUE, generate_multiplate_reports = TRUE
    )
  ))

  # Test with relative path
  rel_path <- fs::path_rel(dir, getwd())
  expect_no_error(capture.output(
    process_dir(rel_path, dry_run = TRUE, recurse = TRUE, flatten_output_dir = FALSE, output_dir = tempdir(check = TRUE))
  ))


  dir <- tempdir(check = TRUE)
  # Clean up the tmp directory
  unlink(dir, recursive = TRUE)
  dir.create(dir)

  expect_no_error(capture.output(
    process_dir(dir, dry_run = TRUE, recurse = FALSE, output_dir = dir)
  ))
})

test_that("Test processing a directory with a single plate", {
  dir <- system.file("extdata", "multiplate_lite", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  output_dir <- tempdir(check = TRUE)
  plates <- process_dir(dir, return_plates = TRUE, output_dir = output_dir)
  expect_length(plates, 2)

  layout_filepath <- system.file("extdata", "CovidOISExPONTENT_CO_layout.xlsx", package = "SerolyzeR", mustWork = TRUE)

  expect_no_error(capture.output(
    process_dir(dir, output_dir = output_dir, dry_run = TRUE, format = "xPONENT", layout_filepath = layout_filepath)
  ))


  expect_no_error(capture.output(
    process_dir(dir,
      output_dir = output_dir, format = "xPONENT",
      generate_reports = TRUE, generate_multiplate_reports = TRUE
    )
  ))
})

test_that("Test processing a reallife directory with merge output", {
  dir <- system.file("extdata", "multiplate_reallife_reduced", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  output_dir <- tempdir(check = TRUE)

  # Clean up the tmp directory
  unlink(output_dir, recursive = TRUE)
  dir.create(output_dir)

  plates <- process_dir(dir, return_plates = TRUE, output_dir = output_dir, merge_outputs = TRUE)
  expect_length(plates, 3)
  expect_true(
    length(fs::dir_ls(output_dir, type = "file", glob = "*merged*")) >= 2
  ) # The gte is used to account for the possibility of the file being created in the previous test
})

test_that("Test validation checks", {
  dir <- system.file("extdata", "multiplate_mock", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  expect_error(process_dir(dir, format = "random_format"))

  # Test with a non-existing directory
  expect_error(process_dir("non_existing_dir", format = "xPONENT"))

  # Test with a non-existing layout file
  expect_error(process_dir(dir, format = "xPONENT", layout_file = "non_existing_layout.xlsx"))
})
