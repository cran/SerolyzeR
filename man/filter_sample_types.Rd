% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{filter_sample_types}
\alias{filter_sample_types}
\title{Filter Samples by Sample Type}
\usage{
filter_sample_types(sample_types, sample_type_filter)
}
\arguments{
\item{sample_types}{(\code{character}) A character vector of sample types for each sample in the plate. Must by a valid sample type \cr \code{c(ALL, BLANK, TEST, NEGATIVE CONTROL, STANDARD CURVE, POSITIVE CONTROL)}.}

\item{sample_type_filter}{(\code{character}) A vector of desired sample types to select (e.g., \code{"TEST"}, \code{"BLANK"}).
If \code{"ALL"} is within the vector, it returns all the samples.}
}
\value{
A logical vector the same length as \code{sample_types}, indicating which samples match.
}
\description{
This function returns a logical vector indicating which samples in the plate
match the specified \code{sample_type_filter}. It is typically used for subsetting
sample-related data such as MFI values, layout, or names.

If \code{sample_type_filter} is set to \code{"ALL"}, all sample types are considered valid.
}
\keyword{internal}
