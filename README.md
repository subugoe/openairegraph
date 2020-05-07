# openairegraph - Read and manipulate the OpenAIRE Research Graph Dump with R

<!-- badges: start -->
[![Main](https://github.com/subugoe/openairegraph/workflows/main/badge.svg)](https://github.com/subugoe/openairegraph/actions)
[![R CMD check](https://github.com/subugoe/openairegraph/workflows/R-CMD-check/badge.svg)](https://github.com/subugoe/openairegraph/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/openairegraph)](https://CRAN.R-project.org/package=openairegraph)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test coverage](https://codecov.io/gh/subugoe/openairegraph/branch/master/graph/badge.svg)](https://codecov.io/gh/subugoe/openairegraph?branch=master)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3744651.svg)](https://doi.org/10.5281/zenodo.3744651)
<!-- badges: end -->


This R package provides helpers for splitting, de-compressing and parsing OpenAIRE Research Graph dumps, a big scholarly data dump comprising metadata about various kinds of grant-supported research outputs, as well as the relationships between them. 
The package {openairegraph} targets users who wish to conduct their own analysis using the OpenAIRE Research Graph, but are wary of handling its large data dumps.

More information about OpenAIRE Research Graph, the dumps and the documentation of their structure can be found at 

Manghi, Paolo, Atzori, Claudio, Bardi, Alessia, Schirrwagen, Jochen, Dimitropoulos, Harry, La Bruzzo, Sandro, … Summan, Friedrich. (2019). OpenAIRE Research Graph Dump (Version 1.0.0-beta) Zenodo. <http://doi.org/10.5281/zenodo.3516918>

The data model is more thoroughly explained here:

Manghi, Paolo, Bardi, Alessia, Atzori, Claudio, Baglioni, Miriam, Manola, Natalia, Schirrwagen, Jochen, & Principe, Pedro. (2019, April 17). The OpenAIRE Research Graph Data Model (Version 1.3). Zenodo. <http://doi.org/10.5281/zenodo.2643199>


## Currently implemented methods

So far, `openairegraph` has been tested to work with the H2020 dump, `h2020_results.gz`. 
The first set provides helpers to split a large OpenAIRE Research Graph data dump into separate, de-coded XML records that can be stored individually. 
The other set consists of parsers that convert data from these XML files to a tibble.

For a long-form documentation including a use-case, see:

<https://subugoe.github.io/openairegraph/articles/intro_h2020/oaire_graph_post.html>


## Installation

You can install the development version of openairegraph from GitHub using the remotes package

``` r
remotes::install_github("subugoe/openairegraph")
```

## Acknowledgments

This work is supported by [OpenAIRE-Advance](https://www.openaire.eu/). OpenAIRE-Advance receives funding from the European Union's Horizon 2020 Research and Innovation programme under Grant Agreement No. 777541.
