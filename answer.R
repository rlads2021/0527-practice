library(httr)
library(rvest)
library(stringr)

# Download web page
resp <- GET('https://streetvoice.com/music/charts/24hr/') 
resp$status_code
html <- content(resp)

# Get top 50 songs
songs <- html %>% 
   html_nodes("ul.list-group-song") %>%
   html_nodes("li")

# Rank
rank <- songs %>% 
   html_nodes("div.work-item-unmber h4") %>% 
   html_text()

# title
title <- songs %>% 
   html_nodes("div.work-item-info h4") %>% 
   html_text() %>%
   trimws()

# author
author <- songs %>% 
   html_nodes("div.work-item-info h5") %>% 
   html_text()

# Likes
likes <- songs %>%
   html_nodes("div.text-right span.js-like-count") %>%
   html_text() %>%
   sapply(function(x) {
      ifelse(str_detect(x, "k"), 
             as.numeric(str_remove(x, "k")) * 1000, x)},
      USE.NAMES = FALSE)

# Merge data
d <- tibble::tibble(
   rank = rank,
   title = title,
   author = author,
   likes = likes
)
