library(httr)
library(rvest)
library(stringr)

# Download web page
resp <- GET("https://streetvoice.com/music/charts/24hr/")
resp$status_code
html <- content(resp)

# Songs
songs <- html %>% html_nodes("ul.list-group-song > li")

# Rank
rank <- songs %>% 
   html_nodes(".work-item-unmber h4") %>% 
   html_text() %>%
   as.integer()

# Title
title <- songs %>% 
   html_nodes(".work-item-info h4 a") %>% 
   html_text() %>% trimws()

# Author
author <- songs %>% 
   html_nodes(".work-item-info h5 a") %>% 
   html_text() %>% trimws()

# Likes
likes <- songs %>% 
   html_nodes(".text-right button span.js-like-count") %>%
   html_text() %>%
   sapply(function(x) {
      ifelse( str_detect(x, "k"), 
              (str_remove(x, "k") %>% as.numeric()) * 1000,
              as.numeric(x)
              )
   }, USE.NAMES = FALSE)

# Merge data
d <- tibble::tibble(
   rank = rank,
   title = title,
   author = author,
   likes = likes
)
