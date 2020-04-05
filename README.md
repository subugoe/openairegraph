
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openairegraph - Read and manipulate the OpenAIRE Research Graph Dump with R

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/subugoe/openairegraph.svg?branch=master)](https://travis-ci.org/subugoe/openairegraph)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test
coverage](https://codecov.io/gh/subugoe/openairegraph/branch/master/graph/badge.svg)](https://codecov.io/gh/subugoe/openairegraph?branch=master)
<!-- badges: end -->

## About

This R package provides helpers for splitting, de-compressing and
parsing OpenAIRE Research Graph dumps, a big scholarly data dump
comprising metadata about various kinds of grant-supported research
outpus, as well as the relationships between them. The package
`openairegraph` targets users who wish to conduct their own analysis
using the OpenAIRE Research Graph, but are wary of handling its large
data dumps.

More information about OpenAIRE Research Graph, the dumps and the
documentation of their structure can be found at

Manghi, Paolo, Atzori, Claudio, Bardi, Alessia, Schirrwagen, Jochen,
Dimitropoulos, Harry, La Bruzzo, Sandro, … Summan, Friedrich. (2019).
OpenAIRE Research Graph Dump (Version 1.0.0-beta) Zenodo.
<http://doi.org/10.5281/zenodo.3516918>

The data model is more thoroughly explained here:

Manghi, Paolo, Bardi, Alessia, Atzori, Claudio, Baglioni, Miriam,
Manola, Natalia, Schirrwagen, Jochen, & Principe, Pedro. (2019, April
17). The OpenAIRE Research Graph Data Model (Version 1.3). Zenodo.
<http://doi.org/10.5281/zenodo.2643199>

## Currently implemented methods

So far, `openairegraph` has been tested to work with the H2020 dump,
`h2020_results.gz`. The first set provides helpers to split a large
OpenAIRE Research Graph data dump into separate, de-coded XML records
that can be stored individually. The other set consists of parsers that
convert data from these XML files to a tibble.

For a long-form documentation including a use-case, see:

## Installation

You can install the development version of openairegraph from GitHub
using the remotes package

``` r
remotes::install_github("subugoe/openairegraph")
```

## Quick start

The workflow starts with loading a downloaded OpenAIRE Research Graph
dump. After that, the package helps you to de-code and split into
several locally stored files. Dedicated parser will obtain data from
these files.

### De-code and split OpenAIRE Research Graph dumps

OpenAIRE Research Graph dumps are json-files that contain a record
identifier and a [Base64](https://en.wikipedia.org/wiki/Base64)-encoded
text string representing the metadata.

``` r
library(jsonlite)
library(tibble)
# sample file delivered with this package
dump_file <- system.file("extdata", "h2020_results_short.gz", package = "openairegraph")
# a dump file is in json format
loaded_dump <- jsonlite::stream_in(file(dump_file), verbose = FALSE)
tibble::as_tibble(loaded_dump)
#> # A tibble: 100 x 2
#>    `_id`$`$oid`        body$`$binary`                              $`$type`
#>    <chr>               <chr>                                       <chr>   
#>  1 5dbc22f81e82127b58… UEsDBBQACAgIAIRiYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#>  2 5dbc22f9b531c546e8… UEsDBBQACAgIAIRiYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#>  3 5dbc22fa45e3122d97… UEsDBBQACAgIAIViYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#>  4 5dbc22fa45e3122d97… UEsDBBQACAgIAIViYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#>  5 5dbc22fa4e0c061a4d… UEsDBBQACAgIAIViYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#>  6 5dbc22fb81f3c12c00… UEsDBBQACAgIAIViYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#>  7 5dbc22fb895be12461… UEsDBBQACAgIAIViYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#>  8 5dbc22fbe56570673e… UEsDBBQACAgIAIViYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#>  9 5dbc22fc81f3c12bfe… UEsDBBQACAgIAIViYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#> 10 5dbc22fcb531c546e8… UEsDBBQACAgIAIZiYU8AAAAAAAAAAAAAAAAEAAAAYm… 00      
#> # … with 90 more rows
```

`openairegraph::oaire_decode()` decodes these strings and saves them
locally. It writes out each XML-formatted record as a zip file to a
specified folder.

``` r
library(openairegraph)
# writes out each XML-formatted record as a zip file to a specified folder
openairegraph::oaire_decode(loaded_dump, limit = 10, records_path = "data/")
```

These files can be loaded using the `xml2` package.

``` r
library(xml2)
library(openairegraph)
# sample file delivered with this package
dump_eg <- system.file("extdata", "multiple_projects.xml", 
                       package = "openairegraph")
my_record <- xml2::read_xml(dump_eg)
my_record
#> {xml_document}
#> <record>
#> [1] <result xmlns:dri="http://www.driver-repository.eu/namespace/dri" xm ...
```

### XML-Parsers

So far, there are four parsers available to consume the H2020 results
set:

  - `openairegraph::oarg_publications_md()` retrieves basic publication
    metadata complemented by author details and access status
  - `openairegraph::oarg_linked_projects()` parses grants linked to
    publications
  - `openairegraph::oarg_linked_ftxt()` gives full-text links including
    access information
  - `openairegraph::oarg_linked_affiliations()` parses affiliation data

#### Basic publication metadata

``` r
openairegraph::oarg_publications_md(my_record)
#> # A tibble: 1 x 12
#>   type  title journal publisher date_of_accepta… best_access_rig…
#>   <chr> <chr> <chr>   <chr>     <chr>            <chr>           
#> 1 publ… Iden… PLoS G… Public L… 2017-06-01       Open Access     
#> # … with 6 more variables: embargo_enddate <chr>, resource_type <chr>,
#> #   authors <list>, pids <list>, collected_from <list>, source_ids <list>
```

Author infos

``` r
openairegraph::oarg_publications_md(my_record)$authors
#> [[1]]
#> # A tibble: 64 x 5
#>    author_full_name  author_order author_name author_surname author_orcid  
#>    <chr>                    <dbl> <chr>       <chr>          <chr>         
#>  1 Li, He                       1 He          Li             <NA>          
#>  2 Reksten, Tove Ra…            2 Tove Ragna  Reksten        <NA>          
#>  3 Ice, John A.                 3 John A.     Ice            <NA>          
#>  4 Kelly, Jennifer …            4 Jennifer A. Kelly          <NA>          
#>  5 Adrianto, Indra              5 Indra       Adrianto       <NA>          
#>  6 Rasmussen, Astrid            6 Astrid      Rasmussen      0000-0001-774…
#>  7 Wang, Shaofeng               7 Shaofeng    Wang           <NA>          
#>  8 He, Bo                       8 Bo          He             <NA>          
#>  9 Grundahl, Kiely …            9 Kiely M.    Grundahl       <NA>          
#> 10 Glenn, Stuart B.            10 Stuart B.   Glenn          <NA>          
#> # … with 54 more rows
```

Linked persistent identifiers (PID) to a research publication

``` r
openairegraph::oarg_publications_md(my_record)$pids
#> [[1]]
#> # A tibble: 3 x 2
#>   pid_type pid                         
#>   <chr>    <chr>                       
#> 1 pmc      PMC5501660                  
#> 2 doi      10.1371/journal.pgen.1006820
#> 3 pmid     28640813
```

#### Linked projects

``` r
openairegraph::oarg_linked_projects(my_record)
#> # A tibble: 22 x 9
#>    to    project_title funder funding_level_0 funding_level_1
#>    <chr> <chr>         <chr>  <chr>           <chr>          
#>  1 proj… Genetische u… Deuts… Klinische Fors… <NA>           
#>  2 proj… Modulation o… Natio… NATIONAL INSTI… <NA>           
#>  3 proj… Functional E… Natio… NATIONAL INSTI… <NA>           
#>  4 proj… HARMONIzatio… Europ… H2020           RIA            
#>  5 proj… Genomics Core Natio… NATIONAL INSTI… <NA>           
#>  6 proj… Susceptibili… Natio… NATIONAL INSTI… <NA>           
#>  7 proj… Molecular Me… Natio… NATIONAL INSTI… <NA>           
#>  8 proj… Genetic Link… Natio… NATIONAL INSTI… <NA>           
#>  9 proj… Science in a… Natio… NATIONAL INSTI… <NA>           
#> 10 proj… A Genetic Ri… Natio… NATIONAL INSTI… <NA>           
#> # … with 12 more rows, and 4 more variables: funding_level_2 <chr>,
#> #   project_code <chr>, project_acronym <chr>, contract_type <chr>
```

#### Linked Full-Texts

``` r
openairegraph::oarg_linked_ftxt(my_record)
#> # A tibble: 4 x 5
#>   access_right collected_from       instance_type hosted_by        web_urls
#>   <chr>        <chr>                <chr>         <chr>            <list>  
#> 1 Open Access  PubMed Central       Article       Europe PubMed C… <chr [1…
#> 2 Open Access  Publikationer från … Article       Publikationer f… <chr [1…
#> 3 UNKNOWN      Sygma                Article       Unknown Reposit… <chr [1…
#> 4 Open Access  DOAJ-Articles        Article       PLoS Genetics    <chr [3…
```

#### Affiliation data

``` r
openairegraph::oarg_linked_affiliations(my_record)
#> # A tibble: 52 x 3
#>    legal_name                                       country     trust_score
#>    <chr>                                            <chr>       <chr>      
#>  1 Massachusetts Eye and Ear Infirmary              United Sta… 0.8996     
#>  2 University of Santo Tomas Hospital               Philippines 0.9        
#>  3 University of Birmingham                         United Kin… 0.8244     
#>  4 Cedars-Sinai Medical Center                      United Sta… 0.9        
#>  5 Oklahoma Baptist University                      United Sta… 0.8998     
#>  6 NATIONAL INSTITUTE OF HEALTH                     United Sta… 0.7938     
#>  7 University of Minnesota - University of Minneso… United Sta… 0.8433     
#>  8 Haukeland University Hospital                    Norway      0.9        
#>  9 Newcastle University                             United Kin… 0.9        
#> 10 Johns Hopkins University                         United Sta… 0.8998     
#> # … with 42 more rows
```

## Meta

Please note that the `openairegraph` project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.

License: MIT

Please use the issue tracker for bug reporting and feature requests.
