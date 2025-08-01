SerolyzeR.env <- new.env(parent = emptyenv())

# MBA formats
SerolyzeR.env$mba_formats <- c("xPONENT", "INTELLIFLEX")

# String patterns for declared MBA formats
SerolyzeR.env$xponent_pattern <- "xpontent|xponent"
SerolyzeR.env$intelliflex_pattern <- "intelliflex"
SerolyzeR.env$mba_pattern <- paste(
  SerolyzeR.env$xponent_pattern,
  SerolyzeR.env$intelliflex_pattern,
  sep = "|"
)

# Normalisation types
SerolyzeR.env$normalisation_types <- c("MFI", "RAU", "nMFI")

# String patterns for declared normalisation types
SerolyzeR.env$normalisation_pattern <- paste0(
  SerolyzeR.env$normalisation_types,
  collapse = "|"
)

SerolyzeR.env$legend_positions <- c("right", "bottom", "left", "top", "none")

SerolyzeR.env$filename_datetime_format <- "%Y%m%d_%H%M%S"
SerolyzeR.env$report_datetime_format <- "%d-%m-%Y %H:%M"
