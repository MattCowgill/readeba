#' Download and import enterprise agreements data from the Fair Work Commission
#' @param path Path to directory in which downloaded Excel file should be stored
#' @import dplyr
#' @export
#' @examples
#' read_fwc()
#'

read_fwc <- function(path = tempdir()) {

  fwc_file <- file.path(path, "fwc_ebas.xlsx")
  fwc_url <- get_fwc_link()

  utils::download.file(url = fwc_url,
                destfile = fwc_file,
                mode = "wb")

  import_result <- purrr::quietly(readxl::read_excel)(fwc_file)

  if (inherits(import_result$result, "tbl")) {
    raw_df <- import_result$result
  } else {
    stop("Could not import FWC dataframe")
  }

  tidy_fwc(raw_df)
}

get_fwc_link <- function(url = "https://www.fwc.gov.au/documents/reporting/enterprise-agreements-data.xlsx") {
  url_head <- httr::HEAD(url)

  if (url_head$status_code == 200) {
    return(url)
  }

  stop("EBA URL not working")
}

tidy_fwc <- function(raw_df) {
  header <- raw_df |>
    filter(row_number() <= 2) |>
    tidyr::pivot_longer(cols = everything(),
                        names_to = "raw_colname",
                        values_to = "indicator") |>
    mutate(union = if_else(substr(.data$raw_colname, 1, 3) == "...",
                         NA_character_,
                         .data$raw_colname)) |>
    tidyr::fill("union") |>
    filter(!is.na(.data$union)) |>
    group_by(.data$raw_colname, .data$union) |>
    summarise(indicator = paste0(.data$indicator, collapse = " ")) |>
    ungroup()

  body <- raw_df |>
    filter(row_number() > 2) |>
    filter(!is.na(.data$`Application lodged by a Union`)) |>
    rename(date = "...1") |>
    tidyr::pivot_longer(cols = -"date",
                        names_to = "raw_colname",
                        values_to = "value") |>
    mutate(value = gsub("-|n/a", "", .data$value),
           value = as.numeric(.data$value),
           date = janitor::excel_numeric_to_date(as.numeric(.data$date)))

  header |>
    left_join(body,
              by = "raw_colname",
              multiple = "all") |>
    filter(!is.na(.data$value),
           !is.na(.data$date)) |>
    select("date", "indicator", "union", "value")
}
