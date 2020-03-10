#' Get publication metadata
#'
#' @param doc document of class `xml_document` from the OpenAIRE research graph publication subset
#'
#' @return data.frame with publication metadata
#' @importFrom xml2 xml_text xml_find_first
#' @importFrom tibble tibble
#' @export
oarg_publications_md <- function(doc) {
  if (!any(is(doc) == "xml_document"))
    stop("No valid XML")
  else
   pubs_node <- xml2::xml_find_first(doc,
                       "//oaf:entity//oaf:result")
  out <- tibble::tibble(
    type = xml_text(xml_find_first(pubs_node, "//resulttype//@classname")),
    title = xml_text(xml_find_first(pubs_node, "//title[@classid='main title']")),
    journal = xml_text(xml_find_first(pubs_node, "//journal")),
    publisher = xml_text(xml_find_first(pubs_node, "//publisher")),
    date_of_acceptance = xml_text(xml_find_first(pubs_node, "//dateofacceptance")),
    best_access_right =  xml_text(xml_find_first(pubs_node, "//bestaccessright//@classname")),
    embargo_enddate = xml_text(xml_find_first(pubs_node, "//embargoenddate")),
    resource_type = xml_text(xml_find_first(pubs_node, "//resoucetype//@classname")),
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

