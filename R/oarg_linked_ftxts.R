#' Get full-text links
#'
#' Obtain full-text links to OpenAIRE publications including access level
#'
#' @param doc document of class `xml_document` from the OpenAIRE research graph publication subset
#'
#' @importFrom xml2 xml_find_all xml_find_first xml_text
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#' @importFrom methods is
#'
#' @return data.frame with full-text links to a publication inlcuding access level
#'
#' @export
oarg_linked_ftxt <- function(doc) {
  if (!any(is(doc) == "xml_document"))
    stop("No valid XML")
  else
    instance_nodes <- xml2::xml_find_all(doc,
                                    "//oaf:entity//oaf:result//instance")
  tibble::tibble(
    access_right = xml2::xml_text(xml_find_first(instance_nodes, "./accessright/@classname")),
    collected_from = xml2::xml_text(xml_find_first(instance_nodes, "./collectedfrom/@name")),
    instance_type = xml2::xml_text(xml_find_first(instance_nodes, "./instancetype/@classname")),
    hosted_by = xml2::xml_text(xml_find_first(instance_nodes, "./hostedby/@name")),
    web_urls = lapply(instance_nodes, function(x) xml_text(xml_find_all(x, "./webresource/url")))
  )
}
