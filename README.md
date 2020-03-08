
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openairegraph - Read and manipulate the OpenAIRE Research Graph Dump

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/njahn82/openairegraph.svg?branch=master)](https://travis-ci.org/njahn82/openairegraph)
<!-- badges: end -->

The goal of openairegraph is to provide parsing functions to consume
metadata from the OpenAIRE Research Graph.

Dump: Manghi, Paolo, Atzori, Claudio, Bardi, Alessia, Shirrwagen,
Jochen, Dimitropoulos, Harry, La Bruzzo, Sandro, … Summan, Friedrich.
(2019). OpenAIRE Research Graph Dump (Version 1.0.0-beta) \[Data set\].
Zenodo. <http://doi.org/10.5281/zenodo.3516918>

Documentation: <https://api.openaire.eu/graph-dumps.html>

## Installation

You can install the development version of openairegraph from GitHub
using the remotes package

``` r
remotes::install_github("openairegraph")
```

## Example

OpenAIRE data are provided as XML files.

``` r
library(xml2)
library(openairegraph)
dump_eg <- system.file("extdata", "multiple_projects.xml", package = "openairegraph")
my_record <- xml2::read_xml(dump_eg)
```

### Parse publication metadata

``` r
openairegraph::publications_md(my_record)
#> # A tibble: 1 x 10
#>   title journal publisher date_of_accepta… best_access_rig… embargo_enddate
#>   <chr> <chr>   <chr>     <chr>            <chr>            <chr>          
#> 1 Iden… PLoS G… Public L… 2017-06-01       Open Access      <NA>           
#> # … with 4 more variables: resource_type <chr>, authors <list>,
#> #   pids <list>, collected_from <list>
```

Author infos

``` r
openairegraph::publications_md(my_record)$authors
#> [[1]]
#> # A tibble: 64 x 5
#>    author_full_name  author_name author_surname author_order author_orcid  
#>    <chr>             <chr>       <chr>                 <dbl> <chr>         
#>  1 Li, He            He          Li                        1 <NA>          
#>  2 Reksten, Tove Ra… Tove Ragna  Reksten                   2 <NA>          
#>  3 Ice, John A.      John A.     Ice                       3 <NA>          
#>  4 Kelly, Jennifer … Jennifer A. Kelly                     4 <NA>          
#>  5 Adrianto, Indra   Indra       Adrianto                  5 <NA>          
#>  6 Rasmussen, Astrid Astrid      Rasmussen                 6 0000-0001-774…
#>  7 Wang, Shaofeng    Shaofeng    Wang                      7 <NA>          
#>  8 He, Bo            Bo          He                        8 <NA>          
#>  9 Grundahl, Kiely … Kiely M.    Grundahl                  9 <NA>          
#> 10 Glenn, Stuart B.  Stuart B.   Glenn                    10 <NA>          
#> # … with 54 more rows
```

Linked persistent identifier (PID) to research publication

``` r
openairegraph::publications_md(my_record)$pids
#> [[1]]
#> # A tibble: 3 x 2
#>   pid_type pid                         
#>   <chr>    <chr>                       
#> 1 pmc      PMC5501660                  
#> 2 doi      10.1371/journal.pgen.1006820
#> 3 pmid     28640813
```

### Linked projects

``` r
openairegraph::linked_projects(my_record)
#> # A tibble: 22 x 7
#>    to    project_title funder funding_stream project_code project_acronym
#>    <chr> <chr>         <chr>  <chr>          <chr>        <chr>          
#>  1 proj… Genetische u… Deuts… Klinische For… 160564869 /… <NA>           
#>  2 proj… Modulation o… Natio… NATIONAL INST… 5U19AI05636… <NA>           
#>  3 proj… Functional E… Natio… NATIONAL INST… 5R01AR06595… <NA>           
#>  4 proj… HARMONIzatio… Europ… H2020          731944       HarmonicSS     
#>  5 proj… Genomics Core Natio… NATIONAL INST… 1P30GM11076… <NA>           
#>  6 proj… Susceptibili… Natio… NATIONAL INST… 5R01DE01820… <NA>           
#>  7 proj… Molecular Me… Natio… NATIONAL INST… 5P20GM10345… <NA>           
#>  8 proj… Genetic Link… Natio… NATIONAL INST… 4R37AI02471… <NA>           
#>  9 proj… Science in a… Natio… NATIONAL INST… 8P30GM10351… <NA>           
#> 10 proj… A Genetic Ri… Natio… NATIONAL INST… 5P01AR04908… <NA>           
#> # … with 12 more rows, and 1 more variable: contract_type <chr>
```

### Linked Full-Texts

``` r
oarg_linked_ftxt(my_record)
#> # A tibble: 4 x 5
#>   access_right collected_from       instance_type hosted_by        web_urls
#>   <chr>        <chr>                <chr>         <chr>            <list>  
#> 1 Open Access  PubMed Central       Article       Europe PubMed C… <chr [1…
#> 2 Open Access  Publikationer från … Article       Publikationer f… <chr [1…
#> 3 UNKNOWN      Sygma                Article       Unknown Reposit… <chr [1…
#> 4 Open Access  DOAJ-Articles        Article       PLoS Genetics    <chr [3…
```

### Affiliation data

``` r
oarg_linked_affiliations(my_record)
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

Please note that the ‘openairegraph’ project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.
