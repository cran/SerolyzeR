## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = FALSE,
  comment = "#>",
  warning = FALSE,
  message = FALSE,
  dpi = 50,
  out.width = "70%"
)

## -----------------------------------------------------------------------------
library(SerolyzeR)

plate_filepath <- system.file("extdata", "CovidOISExPONTENT.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset

layout_filepath <- system.file("extdata", "CovidOISExPONTENT_layout.xlsx", package = "SerolyzeR", mustWork = TRUE)


plate <- read_luminex_data(plate_filepath, layout_filepath) # read the data

plate

## -----------------------------------------------------------------------------
example_dir <- tempdir(check = TRUE) # create a temporary directory to store the output
df <- process_plate(plate, output_dir = example_dir)
colnames(df)

## -----------------------------------------------------------------------------
df[1:5, 1:5]

## -----------------------------------------------------------------------------
process_file(plate_filepath, layout_filepath, output_dir = example_dir, generate_report = FALSE)

## -----------------------------------------------------------------------------
plate$summary()

plate$summary(include_names = TRUE) # more detailed summary

plate$sample_names[1:5] # print some of the sample names
plate$analyte_names[1:4] # print some of the analyte names

## -----------------------------------------------------------------------------
summary(plate)

## -----------------------------------------------------------------------------
plot_standard_curve_analyte(plate, analyte_name = "OC43_S")

## -----------------------------------------------------------------------------
plot_standard_curve_analyte(plate, analyte_name = "RBD_wuhan", data_type = "Mean")
plot_standard_curve_analyte(plate, analyte_name = "RBD_wuhan", data_type = "Avg Net MFI")

## -----------------------------------------------------------------------------
plot_standard_curve_analyte(plate, analyte_name = "ME")
plot_standard_curve_analyte(plate, analyte_name = "ME", log_scale = "all")

## -----------------------------------------------------------------------------
plot_mfi_for_analyte(plate, analyte_name = "OC43_S")

plot_mfi_for_analyte(plate, analyte_name = "Spike_6P")

## -----------------------------------------------------------------------------
plate$blank_adjusted # verify if the data is already adjusted

## -----------------------------------------------------------------------------
plate$blank_adjustment()

## -----------------------------------------------------------------------------
model <- create_standard_curve_model_analyte(plate, analyte_name = "OC43_S")

model

## -----------------------------------------------------------------------------
plot_standard_curve_analyte_with_model(plate, model, log_scale = c("all"))
plot_standard_curve_analyte_with_model(plate, model, log_scale = c("all"), plot_asymptote = FALSE)

## -----------------------------------------------------------------------------
model_hdh <- create_standard_curve_model_analyte(plate, analyte_name = "RBD_omicron")
plot_standard_curve_analyte_with_model(plate, model_hdh, log_scale = c("all"))

## -----------------------------------------------------------------------------
mfi_values <- plate$data$Median$OC43_S
head(mfi_values)

predicted_rau <- predict(model, mfi_values)

head(predicted_rau)

## -----------------------------------------------------------------------------
model <- create_standard_curve_model_analyte(plate, analyte_name = "Spike_6P")
plot_standard_curve_analyte_with_model(plate, model, log_scale = c("all"))

## -----------------------------------------------------------------------------
plot_standard_curve_analyte_with_model(plate, model, log_scale = c("all"), over_max_extrapolation = 100000)

## -----------------------------------------------------------------------------
nmfi_values <- get_nmfi(plate)

# process plate with nMFI normalisation

df <- process_plate(plate, output_dir = example_dir, normalisation_type = "nMFI")
df[1:5, 1:5]

