% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots-standard_curve.R
\name{plot_standard_curve_analyte_with_model}
\alias{plot_standard_curve_analyte_with_model}
\title{Plot standard curve of a certain analyte with fitted model}
\usage{
plot_standard_curve_analyte_with_model(
  plate,
  model,
  data_type = "Median",
  decreasing_rau_order = TRUE,
  log_scale = c("all"),
  plot_asymptote = TRUE,
  plot_test_predictions = TRUE,
  plot_blank_mean = TRUE,
  plot_rau_bounds = TRUE,
  plot_legend = TRUE,
  legend_position = "bottom",
  verbose = TRUE,
  ...
)
}
\arguments{
\item{plate}{Plate object}

\item{model}{fitted \code{Model} object, which predictions we want to plot}

\item{data_type}{Data type of the value we want to plot - the same
datatype as in the plate file. By default equals to \code{Median}}

\item{decreasing_rau_order}{If \code{TRUE} the RAU values are plotted in
decreasing order, \code{TRUE} by default.}

\item{log_scale}{Which elements on the plot should be displayed in log scale.
By default \code{"all"}. If \code{NULL} or \code{c()} no log scale is used,
if \code{"all"} or \code{c("RAU", "MFI")} all elements are displayed in log scale.}

\item{plot_asymptote}{If \code{TRUE} the asymptotes are plotted, \code{TRUE} by default}

\item{plot_test_predictions}{If \code{TRUE} the predictions for the test samples are plotted, \code{TRUE} by default.
The predictions are obtained through extrapolation of the model}

\item{plot_blank_mean}{If \code{TRUE} the mean of the blank samples is plotted, \code{TRUE} by default}

\item{plot_rau_bounds}{If \code{TRUE} the RAU bounds are plotted, \code{TRUE} by default}

\item{plot_legend}{If \code{TRUE} the legend is plotted, \code{TRUE} by default}

\item{legend_position}{the position of the legend, a possible values are \code{c(right, bottom, left, top, none)}. Is not used if \code{plot_legend} equals to \code{FALSE}.}

\item{verbose}{If \code{TRUE} prints messages, \code{TRUE} by default}

\item{...}{Additional arguments passed to the \code{predict} function}
}
\value{
a ggplot object with the plot
}
\description{
Function plots the values of standard curve samples and the fitted model.
}
\examples{
path <- system.file("extdata", "CovidOISExPONTENT.csv",
  package = "SerolyzeR", mustWork = TRUE
)
layout_path <- system.file("extdata", "CovidOISExPONTENT_layout.xlsx",
  package = "SerolyzeR", mustWork = TRUE
)
plate <- read_luminex_data(path, layout_filepath = layout_path, verbose = FALSE)
model <- create_standard_curve_model_analyte(plate, analyte_name = "Spike_B16172")
plot_standard_curve_analyte_with_model(plate, model, decreasing_rau_order = FALSE)

}
