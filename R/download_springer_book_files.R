# Generate all pdf's in the directories organized by book type

download_springer_book_files <- function(springer_books_titles = NA, springer_table = NA, destination_folder = 'springer_quarantine_books', filetype = 'pdf') {

  if (is.na(springer_table)) {
    springer_table <- springerQuarantineBooksR::download_springer_table()
  }

  if (is.na(springer_books_titles)) { springer_books_titles <- springer_table %>%
    clean_names() %>%
    pull(book_title) %>%
    unique()}

  n <- length(springer_books_titles)

  i <- 1

  print("Downloading title latest editions.")

  for (title in springer_books_titles) {

    print(paste0('Processing... ', title, ' (', i, ' out of ', n, ')'))

    en_book_type <- springer_table %>%
      filter(book_title == title) %>%
      pull(english_package_name) %>%
      unique()

    current_folder = file.path(destination_folder, en_book_type)
    if (!dir.exists(current_folder)) { dir.create(current_folder, recursive = T) }
    setwd(current_folder)
    tic('Time processed')
    if(filetype == 'pdf' || filetype == 'epub') {
      springerQuarantineBooksR::download_springer_book(title, springer_table, filetype)
    }
    else if (filetype == 'both') {
      springerQuarantineBooksR::download_springer_book(title, springer_table, 'pdf')
      springerQuarantineBooksR::download_springer_book(title, springer_table, 'epub')
    }
    toc()
    setwd(file.path('.', '..', '..'))

    i <- i + 1

  }

}
