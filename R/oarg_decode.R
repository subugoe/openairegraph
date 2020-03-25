#' Decode and store OpenAIRE Research Graph files
#'
#'
#'
#' @param oaire compressed json file
#' @param limit number of records to be decoded
#' @param records_path directory for the xml files
#' @param verbose print some information on what is going on
#'
#' @importFrom progress progress_bar
#' @importFrom purrr pmap
#' @importFrom base64enc base64decode
#' @importFrom tibble tibble
#' @return files
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
      pb <- progress_bar$new(total = nrow(oaire_binary))
   tt <- purrr::pmap(oaire_binary, function(bin_xml, id, verbose) {
      if (verbose)
        pb$tick()
      con <- file(paste0(records_path, id, ".zip"),  "wb")
      out <- base64enc::base64decode(what = bin_xml)
      writeBin(out, con)
      close(con)
    }, verbose)
  }
