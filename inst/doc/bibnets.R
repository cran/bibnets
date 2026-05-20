## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(bibnets)

## -----------------------------------------------------------------------------
data(biblio_data)
data(scopus_quantum_cloud)
data(open_alex_gold_open_access_learning_analytics)

small <- biblio_data
sc <- scopus_quantum_cloud
oa <- open_alex_gold_open_access_learning_analytics

nrow(small)
nrow(sc)
nrow(oa)

## ----eval = FALSE-------------------------------------------------------------
# data <- read_biblio("export.csv")
# data <- read_biblio("folder_with_exports/")
# data <- read_biblio(c("part_1.csv", "part_2.csv"))

## ----eval = FALSE-------------------------------------------------------------
# read_scopus("scopus.csv")
# read_wos("savedrecs.txt")
# read_openalex_csv("openalex_works.csv")
# read_dimensions("dimensions.csv")
# read_lens("lens.csv")
# read_bibtex("library.bib")
# read_ris("library.ris")

## ----eval = FALSE-------------------------------------------------------------
# data <- read_biblio(
#   "custom.csv",
#   format = "generic",
#   id = "paper_id",
#   actors = c("Authors", "Keywords"),
#   sep = ";"
# )

## -----------------------------------------------------------------------------
names(sc)[1:12]

## -----------------------------------------------------------------------------
authors_full <- author_network(oa, type = "collaboration")
head(authors_full, 5)

## -----------------------------------------------------------------------------
summary(authors_full)

## -----------------------------------------------------------------------------
authors_core <- author_network(oa, "collaboration", min_occur = 2)
nrow(authors_full)
nrow(authors_core)

## -----------------------------------------------------------------------------
head(author_network(small, "collaboration", counting = "full"), 5)

## -----------------------------------------------------------------------------
head(author_network(small, "collaboration", counting = "fractional"), 5)

## -----------------------------------------------------------------------------
head(author_network(small, "collaboration", counting = "harmonic"), 5)

## -----------------------------------------------------------------------------
head(author_network(small, "collaboration", counting = "first_last"), 5)

## -----------------------------------------------------------------------------
lead <- author_network(small, attention = "lead")
last <- author_network(small, attention = "last")

head(lead, 5)
head(last, 5)

## -----------------------------------------------------------------------------
refs <- reference_network(sc, min_occur = 2)
head(refs, 5)

## -----------------------------------------------------------------------------
refs_cos <- reference_network(sc, min_occur = 2, similarity = "cosine")
head(refs_cos, 5)

## -----------------------------------------------------------------------------
coupled_docs <- document_network(sc, type = "coupling", similarity = "cosine")
head(coupled_docs, 5)

## -----------------------------------------------------------------------------
direct_docs <- document_network(sc, type = "citation")
head(direct_docs, 5)

## -----------------------------------------------------------------------------
kw <- keyword_network(sc, min_occur = 2)
head(kw, 5)

## -----------------------------------------------------------------------------
kw_assoc <- keyword_network(sc, min_occur = 2, similarity = "association")
head(kw_assoc, 5)

## -----------------------------------------------------------------------------
country_edges <- country_network(oa, counting = "fractional")
head(country_edges, 5)

inst_edges <- institution_network(oa, counting = "fractional", min_occur = 2)
head(inst_edges, 5)

## -----------------------------------------------------------------------------
source_edges <- source_network(sc, type = "coupling", min_occur = 2)
head(source_edges, 5)

## -----------------------------------------------------------------------------
head(conetwork(sc, "keywords", min_occur = 2), 5)

## -----------------------------------------------------------------------------
head(conetwork(sc, "authors", by = "keywords", min_occur = 2), 5)

## -----------------------------------------------------------------------------
toy <- data.frame(
  id = c("P1", "P2", "P3"),
  tags = c("methods; networks", "networks; R", "methods; R")
)

conetwork(toy, "tags")

## -----------------------------------------------------------------------------
none <- keyword_network(sc, min_occur = 2, similarity = "none")
cos  <- keyword_network(sc, min_occur = 2, similarity = "cosine")

head(none[, c("from", "to", "weight", "count")], 3)
head(cos[, c("from", "to", "weight", "count")], 3)

## -----------------------------------------------------------------------------
normalize(to_matrix(keyword_network(small)), "cosine")

## -----------------------------------------------------------------------------
edges <- author_network(oa, "collaboration")

nrow(edges)
nrow(prune(edges, threshold = 2))
nrow(prune(edges, top_n = 5))
nrow(filter_top(edges, n = 50))

## -----------------------------------------------------------------------------
bb <- backbone(edges, alpha = 0.05)
nrow(bb)
head(bb, 5)

## -----------------------------------------------------------------------------
tn <- temporal_network(oa, author_network, "collaboration", window = 3)
names(tn)

## -----------------------------------------------------------------------------
tn_slide <- temporal_network(
  oa,
  author_network,
  "collaboration",
  window = 3,
  step = 1,
  strategy = "sliding"
)

names(tn_slide)

## -----------------------------------------------------------------------------
tn_cum <- temporal_network(
  oa,
  author_network,
  "collaboration",
  window = 3,
  strategy = "cumulative"
)

names(tn_cum)

## -----------------------------------------------------------------------------
lcs <- local_citations(sc)
head(lcs, 5)

## -----------------------------------------------------------------------------
h <- historiograph(sc, n = 10)
h$nodes
head(h$edges, 5)

## -----------------------------------------------------------------------------
edges <- keyword_network(sc, min_occur = 2)
head(edges, 5)

## -----------------------------------------------------------------------------
m <- to_matrix(edges)
m[1:4, 1:4]

## -----------------------------------------------------------------------------
gephi <- to_gephi(edges)
head(gephi$nodes, 3)
head(gephi$edges, 3)

## -----------------------------------------------------------------------------
xml <- to_graphml(edges)
cat(substr(xml, 1, 300))

## ----eval = FALSE-------------------------------------------------------------
# if (requireNamespace("igraph", quietly = TRUE)) {
#   g <- to_igraph(edges)
# }
# 
# if (requireNamespace("tidygraph", quietly = TRUE)) {
#   tg <- to_tbl_graph(edges)
# }
# 
# if (requireNamespace("cograph", quietly = TRUE)) {
#   cg <- to_cograph(edges)
# }

## -----------------------------------------------------------------------------
edges <- author_network(oa, "collaboration", counting = "harmonic")

attr(edges, "network_type")
attr(edges, "counting")
attr(edges, "similarity")

## -----------------------------------------------------------------------------
summary(edges)

