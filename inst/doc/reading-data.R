## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(bibnets)

## ----read-biblio-signature, eval = FALSE--------------------------------------
# data <- read_biblio("export.csv")          # auto-detect format
# data <- read_biblio("scopus_dir/")         # entire directory, rbind'd
# data <- read_biblio(c("a.csv", "b.csv"))   # multiple files, rbind'd
# data <- read_biblio("file.csv", format = "scopus")   # force a format

## ----openalex-csv-demo--------------------------------------------------------
f <- system.file("extdata", "openalex_works.csv", package = "bibnets")
oa <- read_openalex_csv(f)
str(oa, max.level = 1)
head(oa[, c("id", "title", "year", "journal", "type")], 5)

## ----openalex-csv-lists-------------------------------------------------------
oa$authors[[1]]
oa$affiliations[[1]]
oa$countries[[1]]

## ----openalex-csv-limits------------------------------------------------------
all(vapply(oa$references, function(x) length(x) == 0 || all(is.na(x)), logical(1)))
all(is.na(oa$abstract))

## ----openalex-csv-networks----------------------------------------------------
co <- country_network(oa, counting = "fractional")
head(co, 5)

## ----scopus-call, eval = FALSE------------------------------------------------
# sc <- read_scopus("scopus.csv")

## ----wos-call, eval = FALSE---------------------------------------------------
# wos1 <- read_wos("savedrecs.txt")                       # plaintext (default)
# wos2 <- read_wos("savedrecs.tsv", format = "tab")       # tab-delimited

## ----openalex-fetch, eval = FALSE---------------------------------------------
# library(openalexR)
# raw  <- oa_fetch(entity = "works", search = "learning analytics", per_page = 200)
# data <- read_openalex(raw)

## ----dimensions-call, eval = FALSE--------------------------------------------
# dm <- read_dimensions("dimensions_export.csv")

## ----lens-call, eval = FALSE--------------------------------------------------
# ln <- read_lens("lens_export.csv")

## ----bibtex-ris-call, eval = FALSE--------------------------------------------
# bt <- read_bibtex("library.bib")
# ri <- read_ris("savedrecs.ris")

## ----crossref-call, eval = FALSE----------------------------------------------
# library(rcrossref)
# raw  <- cr_works(query = "graph neural networks", limit = 100)
# data <- read_crossref(raw$data)

## ----generic-call, eval = FALSE-----------------------------------------------
# data <- read_biblio(
#   "my_data.csv",
#   format  = "generic",
#   id      = "doc_id",
#   actors  = c("Authors", "Keywords"),
#   sep     = ";"
# )

## ----generic-demo-------------------------------------------------------------
f <- system.file("extdata", "openalex_works.csv", package = "bibnets")
generic <- read_biblio(
  f,
  format = "generic",
  id     = "id",
  actors = c("authorships.author.display_name", "primary_topic.display_name"),
  sep    = "|"
)
names(generic)[1:6]
generic$authorships.author.display_name[[1]]

## ----manual-build-------------------------------------------------------------
df <- data.frame(
  id    = c("p1", "p2", "p3"),
  title = c("Paper A", "Paper B", "Paper C"),
  year  = c(2020L, 2021L, 2022L),
  stringsAsFactors = FALSE
)
df$authors <- list(
  c("ALICE", "BOB"),
  c("BOB", "CAROL"),
  c("ALICE", "CAROL", "DAVE")
)
df$references <- list(
  c("R1", "R2"),
  c("R1", "R3"),
  c("R2", "R3", "R4")
)
df$keywords <- list(
  c("graph", "network"),
  c("network", "embedding"),
  c("graph", "embedding", "neural")
)

author_network(df, "collaboration")
keyword_network(df)
reference_network(df)

## ----split-field-demo---------------------------------------------------------
split_field(c("Alice; Bob; Carol", "Dave; Eve"))
split_field(c("a|b|c", "d|e"), sep = "|")

## ----combine-sources----------------------------------------------------------
common <- c("id", "title", "year", "journal", "doi", "cited_by_count",
            "abstract", "type", "authors", "references", "keywords")

data(biblio_data)
b1 <- biblio_data
b2 <- biblio_data
b2$id <- paste0(b2$id, "_dup")

cols <- intersect(common, names(b1))
combined <- rbind(b1[, cols], b2[, cols])
nrow(combined)

## ----sanity-check-------------------------------------------------------------
data(scopus_quantum_cloud)
sc <- scopus_quantum_cloud

range(lengths(sc$authors))
range(lengths(sc$references))
range(lengths(sc$keywords))

head(sort(table(sc$journal), decreasing = TRUE), 5)
range(sc$year, na.rm = TRUE)
table(sc$type)

