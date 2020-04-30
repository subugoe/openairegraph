#' Get project metadata
#'
#' Parse project metadata linked to a OpenAIRE Research Graph record
#'
#' @inheritParams oarg_publications_md
#'
#' @import xml2
#'
#' @return The result is a tibble with project metadata.
#'  Here are the returned columns and descriptions:
#'
#'  \tabular{ll}{
#'  \code{to}              \tab Link type \cr
#'  \code{project_title}   \tab Title of the project \cr
#'  \code{funder}          \tab Funder name \cr
#'  \code{funding_level_0} \tab Funding sub-category (top -level), e.g. H2020 \cr
#'  \code{funding_level_1} \tab Funding sub-category (middle-level), e.g. H2020-ERC \cr
#'  \code{funding_level_2} \tab Funding sub-category (micro-level) \cr
#'  \code{project_code}    \tab Grant ID \cr
#'  \code{project_acronym}  \tab Project's acronym \cr
#'  \code{contract_type}   \tab Type of action \cr
#'  }
#'
#' @examples \dontrun{
#' # sample file delivered with this package
#' dump_eg <- system.file("extdata", "multiple_projects.xml", package = "openairegraph")
#' # load xml file
#' my_record <- xml2::read_xml(dump_eg)
#' # parse full text links
#' oarg_linked_projects(my_record)
#' }
#'
#' @export
oarg_linked_projects <- function(doc) {
  if (!any(methods::is(doc) == "xml_document"))
    stop("No valid XML")
  else
    # get parent nodes relative to projects
    project_nodes <-
      xml_find_all(doc,
                         "//oaf:entity//oaf:result//rels//rel//to[@type='project']/..")
  # apply xpaths to each project node and return as flat tibble
  purrr::map_df(project_nodes, function(x) {
    tibble::tibble(
      to =  xml_text(xml_find_first(x, ".//to/@type")),
      project_title = xml_text(xml_find_first(x, ".//title")),
      funder = xml_text(xml_find_first(x, ".//funding/funder/@name")),
      funding_level_0 = xml_text(xml_find_first(
        x, ".//funding/funding_level_0/@name"
      )),
      funding_level_1 = xml_text(xml_find_first(
        x, ".//funding/funding_level_1/@name"
      )),
      funding_level_2 = xml_text(xml_find_first(
        x, ".//funding/funding_level_2/@name"
      )),
      project_code = xml_text(xml_find_first(x, ".//code")),
      project_acronym = xml_text(xml_find_first(x, ".//acronym")),
      contract_type = xml_text(xml_find_first(x, ".//contracttype/@classname"))
    )
  })
}
