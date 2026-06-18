## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(bibnets)

## ----quick-df-----------------------------------------------------------------
papers <- data.frame(
  `Author Names` = c("Smith J, Doe A, Lee K", "Smith J, Lee K",
                     "Doe A, Lee K", "Smith J, Doe A"),
  check.names = FALSE
)

author_network(papers, authors = "Author Names", sep = ",")

## ----quick-reader, eval = FALSE-----------------------------------------------
# data    <- read_biblio("scopus.csv")
# authors <- author_network(data, type = "collaboration")

## ----read-files, eval = FALSE-------------------------------------------------
# data <- read_biblio("export.csv")
# data <- read_biblio("folder_with_exports/")
# data <- read_biblio(c("part_1.csv", "part_2.csv"))

## ----read-generic, eval = FALSE-----------------------------------------------
# data <- read_biblio(
#   "custom.csv",
#   id       = "paper_id",
#   authors  = "Author Names",
#   keywords = "Tags",
#   sep      = ","
# )

## ----read-direct, eval = FALSE------------------------------------------------
# author_network(my_df, authors = "Author Names", sep = ",")
# keyword_network(my_df, keywords = "Tags",       sep = ",")

## ----schema-------------------------------------------------------------------
data(scopus_quantum_cloud)
sc <- scopus_quantum_cloud
names(sc)[1:12]

## ----data---------------------------------------------------------------------
data(biblio_data)
data(learning_analytics)

small <- biblio_data            # tiny, synthetic
oa    <- learning_analytics     # 1,508 OpenAlex records on learning analytics

c(small = nrow(small), scopus = nrow(sc), openalex = nrow(oa))

## ----author-basic-------------------------------------------------------------
authors <- author_network(oa, type = "collaboration")
head(authors, 5)
summary(authors)

## ----author-minoccur----------------------------------------------------------
nrow(author_network(oa, type = "collaboration"))
nrow(author_network(oa, type = "collaboration", min_occur = 2))

## ----counting-----------------------------------------------------------------
head(author_network(small, type = "collaboration", counting = "full"), 3)
head(author_network(small, type = "collaboration", counting = "fractional"), 3)
head(author_network(small, type = "collaboration", counting = "harmonic"), 3)
head(author_network(small, type = "collaboration", counting = "first_last"), 3)

## ----attention----------------------------------------------------------------
head(author_network(small, attention = "lead"), 3)

## ----cocitation---------------------------------------------------------------
refs <- reference_network(sc, min_occur = 2)
head(refs, 5)

## ----cocitation-cosine--------------------------------------------------------
head(reference_network(sc, min_occur = 2, similarity = "cosine"), 3)

## ----coupling-----------------------------------------------------------------
head(document_network(sc, type = "coupling", similarity = "cosine"), 5)

## ----citation-----------------------------------------------------------------
head(document_network(sc, type = "citation"), 5)

## ----keywords-----------------------------------------------------------------
kw <- keyword_network(sc, min_occur = 2)
head(kw, 5)

## ----keywords-assoc-----------------------------------------------------------
head(keyword_network(sc, min_occur = 2, similarity = "association"), 3)

## ----geo----------------------------------------------------------------------
head(country_network(oa, counting = "fractional"), 5)
head(institution_network(oa, counting = "fractional", min_occur = 2), 5)
head(source_network(sc, type = "coupling", min_occur = 2), 5)

## ----conetwork----------------------------------------------------------------
head(conetwork(sc, "keywords", min_occur = 2), 3)
head(conetwork(sc, "authors", by = "keywords", min_occur = 2), 3)

## ----normalize----------------------------------------------------------------
none <- keyword_network(sc, min_occur = 2, similarity = "none")
cos  <- keyword_network(sc, min_occur = 2, similarity = "cosine")
head(none[, c("from", "to", "weight", "count")], 3)
head(cos[,  c("from", "to", "weight", "count")], 3)

## ----reduce-------------------------------------------------------------------
edges <- author_network(oa, type = "collaboration")
c(all        = nrow(edges),
  threshold  = nrow(prune(edges, threshold = 2)),
  top_n      = nrow(prune(edges, top_n = 5)),
  top_nodes  = nrow(filter_top(edges, n = 50)))

## ----backbone-----------------------------------------------------------------
bb <- backbone(edges, alpha = 0.05)
nrow(bb)

## ----temporal-----------------------------------------------------------------
tn <- temporal_network(oa, author_network, "collaboration", window = 3)
names(tn)

## ----historiograph------------------------------------------------------------
head(local_citations(sc), 5)

h <- historiograph(sc, n = 10)
h$nodes
head(h$edges, 5)

## ----parse-names--------------------------------------------------------------
parse_names(c("Saqr, Mohammed", "WANG Y", "Mohammed Saqr"))

## ----export-------------------------------------------------------------------
edges <- keyword_network(sc, min_occur = 2)

m <- to_matrix(edges)            # sparse adjacency matrix
m[1:4, 1:4]

gephi <- to_gephi(edges)         # Gephi node/edge tables
head(gephi$edges, 3)

cat(substr(to_graphml(edges), 1, 200))   # GraphML, no XML dependency

## ----attrs--------------------------------------------------------------------
edges <- author_network(oa, type = "collaboration", counting = "harmonic")
c(type     = attr(edges, "network_type"),
  counting = attr(edges, "counting"),
  sim      = attr(edges, "similarity"))

summary(edges)

