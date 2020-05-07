#' Get affiliations
#'
#' Obtain affiliation metadata from authors linked to an OpenAIRE-indexed publication.
#'
#' @inheritParams oarg_publications_md
#'
#' @return The result is a tibble with project metadata.
#'  Here are the returned columns and descriptions:
#'
#'  \tabular{ll}{
#'  \code{legal_name}    \tab Name of the organisation \cr
#'  \code{country}       \tab Country of the organisation \cr
#'  \code{trust_score}   \tab Accuracy measure
#'  }
#'
#'
#' @examples \dontrun{
#' # sample file delivered with this package
#' dump_eg <- system.file("extdata", "multiple_projects.xml", package = "openairegraph")
#' # load xml file
#' my_record <- xml2::read_xml(dump_eg)
#' # parse full text links
#' oarg_linked_affiliations(my_record)
#' }
#'
#' @export
oarg_linked_affiliations <- function(doc) {
  if (!any(methods::is(doc) == "xml_document"))
    stop("No valid XML")
  else
    affs_node <- xml_find_all(doc,
                                    "//oaf:entity//oaf:result//rels//rel//to[@class='hasAuthorInstitution']/..")
  tibble::tibble(
    legal_name = xml_text(xml_find_first(affs_node, "./legalname")),
    country = xml_text(xml_find_first(affs_node, "./country//@classname")),
    trust_score = xml_text(xml_find_first(affs_node, "./@trust")),
  )
}
