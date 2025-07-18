#' Verify Numeric Join
#'
#' Checks if two numeric values are equal. If either value is `NA`, returns `TRUE`.
#'
#' @param x A numeric value to be compared.
#' @param y A numeric value to be compared.
#' @return `TRUE` if the values are equal or if either value is `NA`. Returns `FALSE` otherwise.
#' @keywords internal
verify_numeric_join <- function(x, y) {
  # check if two numeric values are equal
  if (is.na(x) || is.na(y)) {
    return(TRUE)
  }
  return(x == y)
}


#' Verify Character Join
#'
#' Checks if two character values are equal. If either value is `NULL`, returns `TRUE`.
#'
#' @param x A character value to be compared.
#' @param y A character value to be compared.
#' @return `TRUE` if the values are equal or if either value is `NULL`. Returns `FALSE` otherwise.
#' @keywords internal
verify_character_join <- function(x, y) {
  # check if two character values are equal
  if (is.null(x) || is.null(y)) {
    return(TRUE)
  }
  return(x == y)
}


#' Determine the Join Value
#'
#' Returns a non-`NA`/non-`NULL` value based on the inputs. If either value is `NA` or `NULL`, it returns the non-`NA`/non-`NULL` value. If both values are equal, it returns that value.
#'
#' @param x A value to be compared.
#' @param y A value to be compared.
#' @return A non-`NA`/non-`NULL` value or the common value if `x` equals `y`. Returns `NULL` if the values differ and neither is `NA` or `NULL`.
#' @keywords internal
get_join_value <- function(x, y) {
  if (is.na(x) || is.null(x)) {
    return(y)
  }
  if (is.na(y) || is.null(y)) {
    return(x)
  }

  if (x == y) {
    return(x)
  }
}

#' Remove Empty Lists from a List
#'
#' This internal function filters out elements from a list that are empty lists.
#'
#' @param lst A list to be processed.
#' @return A list with empty lists removed.
#' @keywords internal
remove_empty_lists <- function(lst) {
  # Filter out elements that are empty lists
  result <- lst[!sapply(lst, function(x) is.list(x) && length(x) == 0)]
  return(result)
}


#' Check if a string is a number
#'
#' @param x A string to be checked.
#' @return `TRUE` if the string is a number, `FALSE` otherwise.
#' @keywords internal
is.str.number <- function(x) {
  stopifnot(is.character(x))
  all(sapply(x, function(x) grepl("^[0-9]+$", x)))
}


#' Check if a value is a scalar
#'
#' This will return FALSE for NULL and vectors of length bigger than 2.
#'
#' @param x Object to be checked.
#' @return `TRUE` if the object is a scalar, `FALSE` otherwise.
#' @keywords internal
is.scalar <- function(x) {
  is.atomic(x) && length(x) == 1L
}

#' Verbose Cat
#'
#' This function prints the input to the console if the `verbose` argument is `TRUE`.
#'
#' @param ... The input to be printed.
#' @param verbose A logical value indicating whether the input should be printed.
#' @keywords internal
verbose_cat <- function(..., verbose = TRUE) {
  if (verbose) {
    cat(..., sep = "")
  }
}


#
# colours for WARNING, NOTE, DEFAULT
#
color_codes <- list(
  yellow_start = "\033[33m",
  yellow_end = "\033[39m",
  red_start = "\033[31m",
  red_end = "\033[39m",
  green_start = "\033[32m",
  green_end = "\033[39m"
)

#' Check if a value is an outlier
#'
#' @param x Vector of numeric values from which the outliers are to be detected.
#'
#' @return A logical vector indicating whether each value is an outlier.
#'
#' @importFrom stats IQR quantile
#' @keywords internal
is_outlier <- function(x) {
  return(x < quantile(x, 0.25) - 1.5 * IQR(x) | x > quantile(x, 0.75) + 1.5 * IQR(x))
}


#' Clamp a value to a range
#'
#' @param x (`numeric()`) A numeric value to be clamped.
#' @param lower ('numeric(1)') The lower bound of the range.
#' @param upper (`numeric(1)`) The upper bound of the range.
#'
#' @return A numeric value clamped to the range \[`lower`, `upper`\].
#'
#' @keywords internal
clamp <- function(x, lower = -Inf, upper = Inf) {
  stopifnot(is.numeric(x), is.numeric(lower), is.numeric(upper))
  x[x < lower] <- lower
  x[x > upper] <- upper
  x
}


#' Format dilutions
#'
#' The function counts the number of times each dilution factor appears and sorts them in descending order based on the corresponding dilution values.
#' The output is a string that lists the dilution factors and their counts in the format `count x dilution_factor`.
#' If the dilutions vector looks like `c("1/2", "1/2", "1/2", "1/3", "1/3", "1/4")`, the output will be `"3x1/2, 2x1/3, 1x1/4"`.
#'
#' @param dilutions A vector of dilution factors, taken from plate object.
#' @param dilution_values A vector of dilution values corresponding to the dilution factors, taken from plate object. Used only for sorting purposes.
#' @param sample_types A vector of sample types taken from plate object.
#'
#' @return A formatted string that lists the dilution factors and their counts. Returns `NULL` if `dilutions` is `NULL`.
#'
#' @keywords internal
format_dilutions <- function(dilutions, dilution_values, sample_types) {
  if (is.null(dilutions)) {
    return(NULL)
  }
  # Filter out NA values from both vectors
  non_na_indices <- !is.na(dilutions) & !is.na(dilution_values) & sample_types == "STANDARD CURVE"
  filtered_dilutions <- dilutions[non_na_indices]
  filtered_dilution_values <- dilution_values[non_na_indices]

  # Count duplicates and store in a named list
  dilution_counts <- table(filtered_dilutions)
  unique_dilutions <- names(dilution_counts)

  # Create a named vector for sorting purposes
  dilution_value_map <- sapply(unique_dilutions, function(dil) {
    min(filtered_dilution_values[filtered_dilutions == dil])
  })

  # Create formatted strings for counts
  formatted_dilutions <- sapply(unique_dilutions, function(dil) {
    count <- dilution_counts[dil]
    if (count > 1) {
      paste0(count, "x", dil)
    } else {
      dil
    }
  })

  # Sort the formatted dilutions
  sorted_indices <- order(dilution_value_map, decreasing = TRUE)
  sorted_formatted_dilutions <- formatted_dilutions[sorted_indices]

  paste(sorted_formatted_dilutions, collapse = ", ")
}


#' Convert dilution to RAU
#'
#' @param predicted_dilution (`numeric()`) A numeric value representing the predicted dilution.
#'
#' @return The RAU value corresponding to the predicted dilution .
#'
#' @keywords internal
dilution_to_rau <- function(predicted_dilution) {
  return(predicted_dilution * 1e6)
}

#' @title Check if the vector is monotically decreasing
#'
#' @param x (`numeric()`) Vector of numeric values
#'
#' @return (`logical(1)`) `TRUE` if the vector is monotonically decreasing, `FALSE` otherwise
#'
#' @keywords internal
#'
is.decreasing <- function(x) {
  stopifnot(is.numeric(x) || is.null(x))
  if (any(is.na(x))) {
    stop(
      "NA values detected in the input vector for `is.decreasing` function."
    )
  }
  if (is.null(x) || (length(x) < 2)) {
    return(TRUE)
  }
  all(diff(x) < 0)
}



#' @title Validate filepath and output_dir
#' @description This function validates the filepath and output_dir arguments.
#'
#' @param filename (`character(1)`) The path to the file.
#' @param output_dir (`character(1)`) The directory where the file should be saved.
#'
#' @param plate_name (`character(1)`) The name of the plate.
#' @param suffix (`character(1)`) The suffix to be added to the filename if it is not provided, e.g. `RAU`.
#' @param extension (`character(1)`) The extension to be added to the filename if it does not have one.
#' Passed without a dot, e.g. `csv`.
#'
#' @param verbose (`logical(1)`) A logical value indicating whether the function should print additional information.
#'
#' @return An absolute output path.
#' @keywords internal
#'
#' @importFrom R.utils isAbsolutePath
#' @importFrom fs path_abs
validate_filepath_and_output_dir <- function(filename, output_dir, plate_name, suffix, extension, verbose = TRUE) {
  # internal checks
  stopifnot(is.character(plate_name), is.character(suffix), is.character(extension))

  if (grepl("^\\.", extension)) {
    stop("The extension should not contain a dot in the beggining.")
  }

  if (is.null(filename)) {
    filename <- paste0(plate_name, "_", suffix, ".", extension)
  } else {
    # perform checks for the filename

    # verify the extension of the filename
    extension_regex <- paste0("\\.", extension, "$")
    if (!grepl(extension_regex, filename)) {
      filename <- paste0(filename, ".", extension)
    }

    if (R.utils::isAbsolutePath(filename)) {
      if (!is.null(output_dir)) {
        warning(
          "The provided filename is an absolute path. Ignoring the output directory.\n"
        )
      }
      output_dir <- dirname(filename)
      filename <- basename(filename)
    }
  }

  # checks for the output_dir
  if (is.null(output_dir)) {
    output_dir <- ""
  }

  # the final output path
  output_path <- file.path(output_dir, filename)

  # make sure the output path is an absolute path
  output_path <- fs::path_abs(output_path)

  # create the directories and check if the file exists
  output_dir <- dirname(output_path)
  filename <- basename(output_path)

  if (!dir.exists(output_dir)) {
    verbose_cat("Creating the output directory: '", output_dir, "'\n", verbose = verbose)
    dir.create(output_dir, recursive = TRUE, showWarnings = TRUE)
  }

  if (file.exists(output_path)) {
    warning("The specified file ", output_path, " already exists. Overwriting it.")
  }

  return(output_path)
}

#' @title
#' Check if two paths are equal
#'
#' @description
#' Function checks if two paths are equal after converting them to absolute paths.
#'
#' @param path1 (`character(1)`) The first path to be compared.
#' @param path2 (`character(1)`) The second path to be compared.
#'
#' @return (`logical(1)`) `TRUE` if the paths are equal, `FALSE` otherwise.
#'
#' @keywords internal
check_path_equal <- function(path1, path2) {
  path1 <- fs::path_abs(path1)
  path2 <- fs::path_abs(path2)
  return(identical(path1, path2))
}

#' @title
#' Check if a mba format is supported
#'
#' @description
#' Check if a given format is supported.
#'
#'
#' @param format (`character(1`) Format string
#' @param allow_nullable (`logical(1)`) Set to `TRUE` if a format can be NULL
#' Defaults to `FALSE`.
#'
#' @return (`logical(1)`) `TRUE` if the format is in the supported list, else `FALSE`
#'
#' @keywords internal
is_mba_format <- function(format, allow_nullable = FALSE) {
  if (is.null(format)) {
    return(allow_nullable)
  }
  return(format %in% SerolyzeR.env$mba_formats)
}

#' @title
#' Sort a flat list by value
#'
#' @param list_obj A list to sort
#' @param value_f Function that expects a element of the list
#' and returns a value to sort the list by.
#' @param decreasing Should the sorting by decreasing or increasing
#'
#' @keywords internal
sort_list_by <- function(list_obj, decreasing = FALSE, value_f = function(elem) elem) {
  values <- lapply(list_obj, value_f)
  values_order <- order(unlist(values), decreasing = decreasing)
  sorted_names <- names(list_obj)[values_order]
  list_obj[sorted_names]
}

#' Select Columns from a DataFrame
#'
#' @description
#' Selects specified columns from a dataframe. If a column
#' does not exist in the dataframe, it will be added with a specified replacement value.
#'
#' @param df A dataframe from which columns are to be selected.
#' @param columns A vector of column names to select.
#' @param replace_value Value to use for columns that do not exist in the dataframe. Default is NA.
#'
#' @return A dataframe containing the specified columns, with missing columns filled with the replacement value.
#'
#' @keywords internal
#'
select_columns <- function(df, columns, replace_value = NA) {
  result_df <- data.frame(lapply(columns, function(col) {
    if (col %in% names(df)) {
      df[[col]]
    } else {
      replace_value
    }
  }))
  names(result_df) <- columns
  return(result_df)
}

#' @title
#' Merge dataframes
#'
#' @description
#' Merges a list of dataframes by handling column collisions
#' through specified strategies: "intersection" or "union".
#'
#' @param dataframes A list of dataframes to merge.
#' @param column_collision_strategy A string specifying how to handle column collisions.
#'        "intersection" keeps only columns present in all dataframes,
#'        "union" includes all columns from all dataframes, filling missing values.
#' @param fill_value Value to fill in missing columns if `column_collision_strategy` is "union".
#'
#' @return Merged dataframe
#'
#' @keywords internal
#'
merge_dataframes <- function(dataframes, column_collision_strategy = "intersection", fill_value = NA) {
  columns <- lapply(dataframes, FUN = function(x) colnames(x))
  if (column_collision_strategy == "intersection") {
    columns_intersection <- Reduce(columns, f = base::intersect)
    dataframes <- lapply(
      dataframes, function(df) select_columns(df, columns_intersection)
    )
  } else if (column_collision_strategy == "union") {
    columns_union <- Reduce(columns, f = base::union)
    dataframes <- lapply(
      dataframes, function(df) select_columns(df, columns_union)
    )
  } else {
    stop("Invalid column collision strategy.")
  }
  output_df <- do.call(rbind, dataframes)
  return(output_df)
}

#' @title
#' Format Y-axis label
#'
#' @description
#' Returns a generic y-axis label for the plot based on the data type and scale.
#'
#' @param data_type A string indicating the type of data (e.g., "Median", "Mean").
#' @param scale_y A string indicating the scale of the y-axis (e.g., "log10", "linear").
#'
#' @return A formatted y-axis label.
#'
#' @keywords internal
#'
format_ylab <- function(data_type, scale_y) {
  if (scale_y == "identity") {
    scale_y <- "linear"
  }

  if (data_type == "Median") {
    if (scale_y == "log10") {
      ylab <- "Median Fluorescence Intensity"
    } else {
      ylab <- paste0("MFI", " (", scale_y, " scale)")
    }
  } else {
    if (scale_y == "log10") {
      ylab <- paste0("MFI (", data_type, ")")
    } else {
      ylab <- paste0("MFI (", data_type, ") (", scale_y, " scale)")
    }
  }
  return(ylab)
}

#' @title
#' Format X-axis label
#'
#' @description
#' Returns a generic x-axis label for the plot based on the prefix and scale.
#'
#' @param prefix A string indicating the prefix for the x-axis label.
#' @param prefix_short A shorter version of the prefix for the x-axis label.
#' @param scale_y A string indicating the scale of the x-axis (e.g., "log10", "linear").
#'
#' @return A formatted x-axis label.
#'
#' @keywords internal
#'
format_xlab <- function(prefix, prefix_short, scale_y) {
  if (scale_y == "identity") {
    scale_y <- "linear"
  }

  if (scale_y == "log10") {
    xlab <- paste0(prefix)
  } else {
    xlab <- paste0(prefix_short, " (", scale_y, " scale)")
  }
  return(xlab)
}


#' @title Filter Samples by Sample Type
#'
#' @description
#' This function returns a logical vector indicating which samples in the plate
#' match the specified `sample_type_filter`. It is typically used for subsetting
#' sample-related data such as MFI values, layout, or names.
#'
#' If `sample_type_filter` is set to `"ALL"`, all sample types are considered valid.
#'
#' @param sample_types (`character`) A character vector of sample types for each sample in the plate. Must by a valid sample type \cr \code{c(`r toString(VALID_SAMPLE_TYPES)`)}.
#' @param sample_type_filter (`character`) A vector of desired sample types to select (e.g., `"TEST"`, `"BLANK"`).
#' If `"ALL"` is within the vector, it returns all the samples.
#'
#' @return A logical vector the same length as `sample_types`, indicating which samples match.
#'
#' @keywords internal
filter_sample_types <- function(sample_types, sample_type_filter) {
  # check if the sample_type is a valid sample type
  if (!all(is.null(sample_types)) && !all(is.na(sample_types))) {
    if (!all(is_valid_sample_type(sample_types))) {
      stop("Sample types ", sample_types, " is not a valid sample type")
    }
  } else {
    stop("Passed sample types is either NULL or NA")
  }


  if (!is.character(sample_type_filter)) {
    stop("`sample_type_filter` must be a character vector.")
  }

  # check if the sample_type_filter is a valid sample type
  if (!all(is.null(sample_type_filter)) && !all(is.na(sample_type_filter))) {
    if (!all(is_valid_sample_type(sample_type_filter) | sample_type_filter == "ALL")) {
      stop("Sample type ", sample_type_filter, " is not a valid sample type")
    }
  } else {
    stop("Passed sample_type_filter is either NULL or NA")
  }


  if ("ALL" %in% sample_type_filter) {
    return(rep(TRUE, length(sample_types)))
  } else {
    return(sample_types %in% sample_type_filter)
  }
}
