## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(bibnets)

## -----------------------------------------------------------------------------
parse_names(c("Saqr, Mohammed", "Lopez-Pernas, Sonsoles"))

## -----------------------------------------------------------------------------
parse_names(c("Saqr, Mohammed", "WANG Y", "Mohammed Saqr"))

## -----------------------------------------------------------------------------
parse_names("Wang Yong", surname_first = "yes")   # force surname-first
parse_names("WANG Y",    surname_first = "no")    # force given-first

## -----------------------------------------------------------------------------
parse_names(c("van der Berg, Jan", "Smith, John, Jr.",
              "DE LA CRUZ, ANA", "VAN DER BERG J"))

## -----------------------------------------------------------------------------
parse_names(c("WHO Collaborating Group", NA, ""))

## -----------------------------------------------------------------------------
nm <- c("Saqr, Mohammed", "van der Berg, Jan", "Garcia Marquez, Gabriel Jose")
data.frame(
  first_last    = parse_names(nm),
  last_initials = parse_names(nm, format = "last_initials"),
  last          = parse_names(nm, format = "last")
)

## -----------------------------------------------------------------------------
x <- parse_names(c("van der Berg, Jan", "Smith, John, Jr."))
attr(x, "parts")

## -----------------------------------------------------------------------------
papers <- data.frame(id = c("P1", "P2", "P3"), stringsAsFactors = FALSE)
papers$authors <- list(
  c("Saqr, Mohammed", "Lopez, Ana"),
  c("SAQR M",         "Lopez, Ana"),
  c("Saqr, Mohammed", "Chen, Wei"))
papers$authors

## -----------------------------------------------------------------------------
papers$authors <- lapply(papers$authors, parse_names,
                          format = "last_initials")
papers$authors

## -----------------------------------------------------------------------------
parse_names(c("WANG Y", "AYALA-ROMERO JA"))

## -----------------------------------------------------------------------------
net <- author_network(papers, type = "collaboration")
net

## -----------------------------------------------------------------------------
class(net)
is.data.frame(net)

## -----------------------------------------------------------------------------
net$from <- as.vector(parse_names(net$from, format = "last"))
net$to   <- as.vector(parse_names(net$to,   format = "last"))
net

