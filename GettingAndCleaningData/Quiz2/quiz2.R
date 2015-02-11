install.packages("httr")
library(httr)
oauth_endpoints("github")
myapp <- oauth_app("github", "cf62ff65e919124398f6")
