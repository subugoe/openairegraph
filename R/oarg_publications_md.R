#' Get publication metadata
#'
#' Parse basic publication metadata from a decoded OpenAIRE Research Graph record.
#'
#' @param doc document of class `xml_document` from the OpenAIRE research graph publication subset
#'
#' @return The result is a tibble with each row representing a publication.
#'   Here are the returned columns and descriptions:
#'
#'   \tabular{ll}{
#'   \code{type}               \tab Research output type (literature publication, dataset, software) \cr
#'   \code{title}              \tab Publication title \cr
#'   \code{journal}            \tab Journal title \cr
#'   \code{publisher}          \tab Publisher \cr
#'   \code{date_of_acceptance} \tab Date of acceptance for publication \cr
#'   \code{best_access_right}  \tab Access level \cr
#'   \code{embargo_enddate}    \tab Date when the publication becomes openly available \cr
#'   \code{resource_type}      \tab Type of dataset \cr
#'   \code{authors}            \tab List-column with author details including names,
#' order and ORCID \cr
#'   \code{pids}                \tab List-column with persistent identifiers (PIDS)
#' referencing the publication, e.g. DOI, PMID or PMCID.
#' PIDs are particularly useful when cross-linking to other scholarly data sources \cr
#'   \code{collected_from}     \tab Name and identifier of metadata source \cr
#'   \code{source_ids}         \tab metadata source ids like OAI identifier
#'   }
#'
#' @examples
#' \dontrun{
#' # sample file delivered with this package
#' dump_eg <- system.file("extdata", "multiple_projects.xml", package = "openairegraph")
#' # load xml file
#' my_record <- xml2::read_xml(dump_eg)
#' # parse
#' out <- openairegraph::oarg_publications_md(my_record)
#'
#' # Detailed author infos
#' openairegraph::oarg_publications_md(out)$authors
#'
#' # Obtain linked persistent identifiers (PID)
#' openairegraph::oarg_publications_md(my_record)$pids
#' }
#' @export
oarg_publications_md <- function(doc) {
  if (!any(methods::is(doc) == "xml_document"))
    stop("No valid XML")
  else
   pubs_node <- xml_find_first(doc,
                       "//oaf:entity//oaf:result")
  out <- tibble::tibble(
    type = xml_text(xml_find_first(pubs_node, "//resulttype//@classname")),
    title = xml_text(xml_find_first(pubs_node, "//title[@classid='main title']")),
    journal = xml_text(xml_find_first(pubs_node, "//journal")),
    publisher = xml_text(xml_find_first(pubs_node, "//publisher")),
    date_of_acceptance = xml_text(xml_find_first(pubs_node, "//dateofacceptance")),
    best_access_right =  xml_text(xml_find_first(pubs_node, "//bestaccessright//@classname")),
    embargo_enddate = xml_text(xml_find_first(pubs_node, "//embargoenddate")),
    resource_type = xml_text(xml_find_first(pubs_node, "//resourcetype//@classname")),
    authors = list(get_authors(pubs_node)),
    pids = list(get_pids(pubs_node)),
    collected_from = list(get_sources(pubs_node)),
    source_ids = list(xml_text(xml_find_all(pubs_node, "./originalId")))
  )
  out[out == ""] <- NA
  out
}

get_pids <- function(pubs_node) {
  tibble::tibble(
    pid_type = xml_text(xml_find_all(pubs_node, "./pid/@classid")),
    pid =  xml_text(xml_find_all(pubs_node, "./pid"))
  )
}

get_sources <- function(pubs_node) {
  tibble::tibble(
    collected_from_name = xml_text(xml_find_all(pubs_node, "./collectedfrom/@name")),
    collected_from_source_id = xml_text(xml_find_all(pubs_node, "./collectedfrom/@id"))
  )
}

get_authors <- function(pubs_node) {
  orcid_nodes <-  xml_find_all(pubs_node, "//creator")
  out <- tibble::tibble(
    author_full_name = xml_text(xml_find_all(pubs_node, "./creator")),
    author_order = as.numeric(xml_text(xml_find_all(pubs_node, "./creator/@rank"))),
    author_name = sapply(orcid_nodes, function(x) xml_text(xml_find_first(x, "@name"))),
    author_surname = sapply(orcid_nodes, function(x) xml_text(xml_find_first(x, "@surname"))),
    author_orcid = sapply(orcid_nodes, function(x) xml_text(xml_find_first(x, "@ORCID")))
  )
  out[order(out$author_order),]
}

