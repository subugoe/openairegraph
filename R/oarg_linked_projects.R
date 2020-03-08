#' Parse projects
#'
#' Obtain project metadata linked to OpenAIRE publications
#'
#' @param doc document of class `xml_document` from the OpenAIRE research graph publication subset
#'
#' @importFrom xml2 xml_find_all xml_find_first xml_text
#' @importFrom tibble tibble
#' @importFrom purrr map_df
#'
#' @return data.frame with project information linked to a publication
#'
#' @export
linked_projects <- function(doc) {
  if (!any(is(doc) == "xml_document"))
    stop("No valid XML")
  else
    # get parent nodes relative to projects
    project_nodes <-
      xml2::xml_find_all(doc,
                         "//oaf:entity//oaf:result//rels//rel//to[@type='project']/..")
  # apply xpaths to each project node and return as flat tibble
  purrr::map_df(project_nodes, function(x) {
    tibble::tibble(
      to =  xml_text(xml_find_first(x, ".//to/@type")),
      project_title = xml_text(xml_find_first(x, ".//title")),
      funder = xml_text(xml_find_first(x, ".//funding/funder/@name")),
      funding_stream = xml_text(xml_find_first(
        x, ".//funding/funding_level_0/@name"
      )),
      project_code = xml_text(xml_find_first(x, ".//code")),
      project_acronym = xml_text(xml_find_first(x, ".//acronym")),
      contract_type = xml_text(xml_find_first(x, ".//contracttype/@classname"))
    )
  })
}
