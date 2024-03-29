% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/maf-files.R
\name{read.MAF}
\alias{read.MAF}
\title{Read MAF file to dataframe}
\usage{
read.MAF(file)
}
\arguments{
\item{file}{A filename to a MAF file}
}
\value{
a data frame. Row and column names are NOT "fixed" via \code{make.names}
}
\description{
Read the MAF file as data frame.
}
\examples{
file <- system.file("examples/m_MTBLS1968_LC-MS_positive_reverse-phase_metabolite_profiling_v2_maf.tsv",
                    package = "metabolighteR")
maf <- read.MAF(file)
}
