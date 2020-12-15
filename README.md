# metabolighteR

 [![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable) [![R build status](https://github.com/aberHRML/metabolighteR/workflows/R-CMD-check/badge.svg)](https://github.com/aberHRML/metabolighteR/actions) [![codecov](https://codecov.io/gh/aberHRML/metabolighteR/branch/master/graph/badge.svg)](https://codecov.io/gh/aberHRML/metabolighteR) ![License](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg "GNU GPL v3.0") [![DOI](https://zenodo.org/badge/174119954.svg)](https://zenodo.org/badge/latestdoi/174119954)

[![CRAN](https://www.r-pkg.org/badges/version/metabolighteR)](https://cran.r-project.org/web/packages/metabolighteR/index.html) ![total downloads](https://cranlogs.r-pkg.org/badges/grand-total/metabolighteR?color=red)  [![GitHub](https://img.shields.io/github/v/release/aberHRML/metabolighteR?color=brightgreen&label=GitHub%20Version)](https://github.com/aberHRML/metabolighteR/releases)

> __R Interface to the [Metabolights REST API](https://www.ebi.ac.uk/metabolights/ws/api/spec.html)__

* [Installation](#installation)
* [Creating an API Key](#api-key)

## Installation

`metabolighteR` can be installed from CRAN using;

```r
install.packages('metabolighteR')
```

Or the latest development version can be installed directly from GitHub using the `remotes` package

```r
remotes::install_github('aberHRML/metabolighteR')
```

## Creating an API Key

Some of the API methods (ie, accessing your private studies) require a personal API token. To generate a token you first need to [register](https://www.ebi.ac.uk/metabolights/newAccount) and then obtain an API Token from your **Account Settings** page.

This API Token is **not** required for the vast majority of the API calls for querying publicly available studies. 

If you are adding the API Token to your .Renviron, you should use the following format;

**NOTE**: *this is NOT recommended if you are using a shared workstation or a workstation where you cannot guarantee the secrecy of your API Token*

```r
MTBLS_API_KEY="<your-api-token-here>"
```

Then once you load the library; you can set the API Token as an option variable. 

```r
library(metabolighteR)

mtbls_key()
```



