#' Parse affiliations
#'
#' Obtain affiliation metadata from OpenAIRE publications
#'
#' @param doc document of class `xml_document` from the OpenAIRE research graph publication subset
#'
#' @importFrom xml2 xml_find_all xml_find_first xml_text
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#'
#' @return data.frame with affiliations linked to a publication
#'
#' @export
oarg_linked_affiliations <- function(doc) {
  if (!any(is(doc) == "xml_document"))
    stop("No valid XML")
  else
    affs_node <- xml2::xml_find_all(doc,
                                    "//oaf:entity//oaf:result//rels//rel//to[@class='hasAuthorInstitution']/..")
  tibble::tibble(
    legal_name = xml2::xml_text(xml2::xml_find_first(affs_node, "./legalname")),
    country = xml2::xml_text(xml2::xml_find_first(affs_node, "./country//@classname")),
    trust_score = xml2::xml_text(xml2::xml_find_first(affs_node, "./@trust")),
  )
}
