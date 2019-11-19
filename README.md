# metabolighteR

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Build Status](https://travis-ci.org/wilsontom/metabolighteR.svg?branch=master)](https://travis-ci.org/wilsontom/metabolighteR) [![Build status](https://ci.appveyor.com/api/projects/status/ip7naqupctsmqvc2/branch/master?svg=true)](https://ci.appveyor.com/project/wilsontom/metabolighter/branch/master) [![codecov](https://codecov.io/gh/wilsontom/metabolighteR/branch/master/graph/badge.svg)](https://codecov.io/gh/wilsontom/metabolighteR) ![License](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg "GNU GPL v3.0") [![DOI](https://zenodo.org/badge/174119954.svg)](https://zenodo.org/badge/latestdoi/174119954)

> __R Interface to the [Metabolights REST API](https://www.ebi.ac.uk/metabolights/ws/api/spec.html)__

To install the latest development version directly from GitHub;

```r
remotes::install_github('wilsontom/metabolighteR)
```

**metabolighteR** provides access to the Metabolights RESTful API. To get started you first need to [register](https://www.ebi.ac.uk/metabolights/newAccount) and then obtain an API Token from your **Account Settings** page.

This API Token is required for the vest majority of the API calls, therefore it is a good idea to add the API token to your .Renviron (**NOTE**: *this is NOT recommended if you are using a shared workstation or a workstation where you cannot guarantee the secrecy of your API Token*). 

If you are adding the API Token to your .Renviron, you should use the following format;

```r
MTBLS_API_KEY="<your-api-token-here>"
```

Then once you load the library; you can set the API Token as an option variable. 

```r
library(metabolighteR)

mtbls_key()
```

If you haven't added your API Token to the .Renviron; the the API Token can be set as an option by passing the API Token as an argumnet in the `set_api_token` function.

```r
library(metabolighteR)

mtbls_key("<your-api-token_here>")
```

