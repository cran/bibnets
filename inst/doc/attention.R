## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(bibnets)

## ----data---------------------------------------------------------------------
papers <- data.frame(
  id      = c("P1", "P2", "P3"),
  authors = c("Alice; Bob; Carol", "Alice; Dave", "Carol; Alice; Eve"),
  stringsAsFactors = FALSE
)

## ----full---------------------------------------------------------------------
author_network(papers, counting = "full")

## ----lead---------------------------------------------------------------------
author_network(papers, attention = "lead")

## ----last---------------------------------------------------------------------
author_network(papers, attention = "last")

## ----label--------------------------------------------------------------------
attr(author_network(papers, attention = "proximity"), "counting")

## ----where, eval = FALSE------------------------------------------------------
# author_network(data, attention = "lead")
# keyword_network(data, attention = "proximity")
# country_network(data, attention = "circular")
# institution_network(data, attention = "last")

