scrape_data <- function() {
  neighborhoods_url <- c(
    'https://www.universalhub.com/crime/allston.html',
    'https://www.universalhub.com/crime/back-bay.html',
    'https://www.universalhub.com/crime/beacon-hill.html',
    'https://www.universalhub.com/crime/brighton.html',
    'https://www.universalhub.com/crime/charlestown.html',
    'https://www.universalhub.com/newcrime/9967',
    'https://www.universalhub.com/crime/dorchester.html',
    'https://www.universalhub.com/crime/downtown.html',
    'https://www.universalhub.com/crime/east-boston.html',
    'https://www.universalhub.com/crime/fenway.html',
    'https://www.universalhub.com/crime/hyde-park.html',
    'https://www.universalhub.com/crime/jamaica-plain.html',
    'https://www.universalhub.com/crime/mattapan.html',
    'https://www.universalhub.com/crime/mission-hill',
    'https://www.universalhub.com/crime/north-end.html',
    'https://www.universalhub.com/crime/roslindale.html',
    'https://www.universalhub.com/crime/roxbury.html',
    'https://www.universalhub.com/crime/south-boston.html',
    'https://www.universalhub.com/crime/south-end.html',
    'https://www.universalhub.com/crime/west-roxbury.html'
  )
  
  scrape_page <- function(url) {
    page <- read_html(url)
    crime_table <- page %>%
      html_nodes("table.views-table.cols-4") %>%
      html_table(fill = TRUE)
    
    if (length(crime_table) > 0) {
      return(crime_table[[1]])
    } else {
      return(NULL)
    }
  }
  
  scrape_neighborhood <- function(start_url) {
    all_pages <- list()
    next_url <- start_url
    page_number <- 1
    
    while (!is.null(next_url)) {
      message("Scraping page ", page_number, " of ", next_url)
      page_data <- scrape_page(next_url)
      if (!is.null(page_data)) {
        all_pages[[length(all_pages) + 1]] <- page_data
      }
      next_link <- read_html(next_url) %>%
        html_nodes(".pager-next a") %>%
        html_attr("href")
      if (length(next_link) > 0) {
        next_url <- paste0("https://www.universalhub.com", next_link)
        page_number <- page_number + 1
      } else {
        next_url <- NULL
      }
    }
    
    if (length(all_pages) > 0) {
      return(bind_rows(all_pages))
    } else {
      return(NULL)
    }
  }
  
  all_crime_data <- foreach(i = 1:length(neighborhoods_url), .combine = bind_rows, .packages = c("rvest", "dplyr")) %do% {
    neighborhood_data <- scrape_neighborhood(neighborhoods_url[i])
    if (!is.null(neighborhood_data)) {
      neighborhood_data$neighborhood <- neighborhoods_url[i]
    }
    return(neighborhood_data)
  }
  
  cleaned_data <- all_crime_data %>%
    
    mutate(
      Type = str_trim(Type),
      Type = str_replace_all(Type, "\\n", ""),
      Type = case_when(
        Type == "" ~ NA_character_,
        Type == "Stabbin" ~ "Stabbing",
        Type == "Assault with a dangeous weapon" ~ "Assault with a dangerous weapon",
        Type == "Assault and battery with a dangeous weapon" ~ "Assault and battery with a dangerous weapon",
        TRUE ~ Type
      ),
      hour = str_extract(Date, "\\d{1,2}:\\d{2} [ap]m") %>%
        parse_date_time("I:M p") %>%
        hour(),
      nbhd = tolower(gsub("https://www.universalhub.com/crime/", "", neighborhood)) %>%
        str_replace(".html$", "") %>%
        str_replace_all(" ", "-")
    ) %>%
    rename(crime = Type) %>%
    select(crime, hour, nbhd)
  
  return(cleaned_data)
}

################## Test functions: do not edit the code below ##################
test_scrape_data <- function(){
  testthat::test_that('Checking that `scrape_data()` exists', {
    testthat::expect_true(exists('scrape_data'))
  })
  
  testthat::test_that('Checking that scrape_data() returns a tibble', {
    testthat::expect_true(tibble::is_tibble(crime_data))
  })
  
  testthat::test_that('Checking that scrape_data() returns a tibble with proper column names', {
    testthat::expect_named(crime_data, 
                           expected = c('crime', 
                                        'hour', 
                                        'nbhd'), 
                           ignore.order = TRUE)
  })
  
  
}


