#' Get full-text links
#'
#' OpenAIRE keep tracks of full-text links to publications including access level.
#' This parser retrieves links and corresponding metadata about the host of a resource.
#'
#' @inheritParams oarg_publications_md
#'
#' @importFrom xml2 xml_find_all xml_find_first xml_text
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#' @importFrom methods is
#'
#' @return The result is a tibble. Here are the returned columns and descriptions:
#'
#' \tabular{ll}{
#' \code{access_right}    \tab Availability of the resource \cr
#' \code{collected_from}  \tab Name of the metadata source \cr
#' \code{instance_type}   \tab Type of linked resource \cr
#' \code{hosted_by}       \tab Name of the Repository or Journal \cr
#' \code{web_urls}        \tab List-columns with links to the resource
#' }
#'
#' @examples \dontrun{
#' # sample file delivered with this package
#' dump_eg <- system.file("extdata", "multiple_projects.xml", package = "openairegraph")
#' # load xml file
#' my_record <- xml2::read_xml(dump_eg)
#' # parse full text links
#' oarg_linked_ftxt(my_record)
#' }
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
