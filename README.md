# metabolighteR

[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![R-CMD-check](https://github.com/aberHRML/metabolighteR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/aberHRML/metabolighteR/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/aberHRML/metabolighteR/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/aberHRML/metabolighteR/actions/workflows/test-coverage.yaml)
[![Test coverage](https://raw.githubusercontent.com/aberHRML/metabolighteR/coverage/badges/coverage.svg)](https://github.com/aberHRML/metabolighteR/actions/workflows/test-coverage.yaml)
![License](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg "GNU GPL v3.0")
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8362554.svg)](https://doi.org/10.5281/zenodo.8362554)
[![CRAN](https://www.r-pkg.org/badges/version/metabolighteR)](https://cran.r-project.org/web/packages/metabolighteR/index.html)
![total downloads](https://cranlogs.r-pkg.org/badges/grand-total/metabolighteR?color=red)
[![GitHub](https://img.shields.io/github/v/release/aberHRML/metabolighteR?color=brightgreen&label=GitHub%20Version)](https://github.com/aberHRML/metabolighteR/releases)

`metabolighteR` is an R interface to the [MetaboLights REST API](https://www.ebi.ac.uk/metabolights/ws/api/spec.html). It provides convenient wrappers for retrieving public study metadata, working with user-authenticated endpoints, downloading study files, and reading or writing Metabolite Annotation Format (MAF) tables.

## What it covers

- Discover public MetaboLights studies and inspect study-level metadata.
- Retrieve titles, descriptions, publications, contacts, factors, organisms, protocols, and assay details.
- List and download deposited study files.
- Access authenticated endpoints for private studies and user-owned content.
- Search metabolite names through the MetaboLights service.
- Read, create, and write MAF files in R.

## Installation

Install the current CRAN release:

```r
install.packages("metabolighteR")
```

Install the development version from GitHub:

```r
remotes::install_github("aberHRML/metabolighteR")
```

Load the package:

```r
library(metabolighteR)
```

## Authentication

Most public study queries do not require a token. Authenticated endpoints such as `get_private_studies()`, `get_user_studies()`, `get_study_audit()`, `get_study_org()`, `get_study_samples()`, and `get_isa_investigation()` require a personal MetaboLights API token.

Create a MetaboLights account at [ebi.ac.uk/metabolights](https://www.ebi.ac.uk/metabolights/newAccount), then obtain your token from your account settings.

If you want R to pick the token up automatically, add it to `.Renviron`:

```r
MTBLS_API_KEY="<your-api-token-here>"
```

Then initialise the package token option:

```r
library(metabolighteR)
mtbls_key()
```

You can also pass the token directly:

```r
mtbls_key("XXXX-0000-XXXX-0000")
```

## Quick start

List public study identifiers:

```r
library(metabolighteR)

studies <- get_studies()
head(studies)
```

Inspect available public API wrappers:

```r
all_get_methods()
```

Summarise a few public studies:

```r
study_ids <- as.vector(get_studies()$study[1:5])

study_titles <- purrr::map_chr(study_ids, get_study_title)
study_tech <- get_study_tech()

summary_tbl <- tibble::tibble(
  STUDY = study_ids,
  Title = study_titles
) |>
  dplyr::left_join(study_tech, by = "STUDY")

summary_tbl
```

## Working with study metadata

The package exposes focused accessors for common parts of the study record:

```r
get_study_title("MTBLS375")
get_study_desc("MTBLS375")
get_study_meta("MTBLS375")
get_study_protocols("MTBLS375")
get_study_pubs("MTBLS375")
get_study_contacts("MTBLS375")
get_study_factors("MTBLS375")
get_study_descriptors("MTBLS375")
```

List assay and file-level information:

```r
get_study_assay_file("MTBLS375")
get_study_assay_list("MTBLS375")
get_study_files("MTBLS375", raw_data = FALSE)
```

## Downloading deposited files

Retrieve the file listing for a public study, then download a selected file:

```r
study_files <- get_study_files("MTBLS264")
study_files

file_contents <- download_study_file("MTBLS264", study_files$file[1])
head(file_contents)
```

When `raw_data = TRUE`, `get_study_files()` uses an authenticated endpoint and therefore requires a token:

```r
mtbls_key()
raw_files <- get_study_files("MTBLS264", raw_data = TRUE)
```

## Searching metabolites

Search the MetaboLights metabolite index by compound name:

```r
search_metabolite("proline")
```

The result is returned as a tibble with fields such as metabolite name, formula, SMILES, InChI, and source database identifier.

## Working with MAF files

`metabolighteR` also includes utilities for handling Metabolite Annotation Format tables.

Read an example MAF file bundled with the package:

```r
maf_file <- system.file(
  "examples/m_MTBLS1968_LC-MS_positive_reverse-phase_metabolite_profiling_v2_maf.tsv",
  package = "metabolighteR"
)

maf <- read.MAF(maf_file)
head(maf[, 1:6])
```

Create a blank MAF template:

```r
maf_template <- create.MAF(nrow = 10)
head(maf_template)
```

Create a MAF table from an abundance matrix:

```r
abundances <- data.frame(
  sample_1 = c(12.3, 8.4),
  sample_2 = c(11.7, 8.9)
)

maf_from_abundance <- create.MAF(abundances = abundances)
```

Write a MAF table back to disk:

```r
write.MAF(maf_from_abundance, file = tempfile(fileext = ".tsv"))
```

## Authenticated endpoints

After calling `mtbls_key()`, you can access user-specific or protected resources:

```r
get_private_studies()
get_user_studies()
get_study_audit("MTBLS375")
get_study_org("MTBLS375")
get_study_samples("MTBLS375")
get_isa_investigation("MTBLS375")
```

These functions depend on your MetaboLights account permissions and on the availability of the corresponding study resources.

## Documentation

- Package vignette: `vignette("Introduction_to_metabolighteR")`
- Function help: `?get_studies`, `?get_study_files`, `?search_metabolite`
- API reference used by the package: <https://www.ebi.ac.uk/metabolights/ws/api/spec.html>

## Notes

- The package wraps `GET` endpoints only.
- Examples in this README call live MetaboLights services unless they only operate on local MAF data.
- Some endpoints may require authentication even when a study identifier is public, depending on the underlying MetaboLights API route.
