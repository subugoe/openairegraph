#' Decode and store records from OpenAIRE Research Graph files
#'
#' OpenAIRE Research Graph files are json-files that contain a record identifier
#' and a BASE64 encoded text string representing the metadata. This function
#' decodes these strings and saves them locally.
#'
#' De-coding and storing the records individually from an OpenAIRE Research Graph
#' dump allows to process the records independent from each other, which is a
#' common approach when working with big data.
#'
#' Because the dumps are quite large, the function furthermore has a
#' parameter that allows setting a limit, which is helpful for inspecting
#' the output first.
#'
#'  By default, a progress bar presents the current state of the process.
#'
#' @param oaire compressed json file
#' @param limit number of records to be decoded
#' @param records_path directory for the xml files
#' @param verbose print some information on what is going on
#'
#' @return Exports de-compressed XML-formatted record, storing them locally
#'  as zip files. The file name represents the record identifier.
#'
#' @examples
#' \dontrun{
#' library(jsonlite)
#' dump_file <- system.file("extdata", "", package = "openairegraph")
#' # a dump file is in json format
#' loaded_dump <- jsonlite::stream_in(file("dump_file"))
#' # writes out each XML-formatted record as a zip file to a specified folder
#' oaire_decode(loaded_dump, limit = 10, records_path = "data/")
#' }
#' @export
#'
oarg_decode <-
  function(oaire = NULL,
           limit = NULL,
           records_path = NULL,
           verbose = TRUE) {
    # create a dataset with a record id and the binary compressed xml
    oaire_binary <-
      tibble::tibble(id = oaire$`_id`$`$oid`,
                     bin_xml = oaire$body$`$binary`)
    if (limit > nrow(oaire_binary))
       limit <- NULL
    if (!is.null(limit))
      oaire_binary <- oaire_binary[c(1:limit), ]
    if (!dir.exists(records_path))
      stop("No folder found to store the decoded record files")
    if (verbose)
      pb <- progress::progress_bar$new(total = nrow(oaire_binary))
   tt <- purrr::pmap(oaire_binary, function(bin_xml, id, verbose) {
      if (verbose)
        pb$tick()
      con <- file(paste0(records_path, id, ".zip"),  "wb")
      out <- base64enc::base64decode(what = bin_xml)
      writeBin(out, con)
      close(con)
    }, verbose)
  }
