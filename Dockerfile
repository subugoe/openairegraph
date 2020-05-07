# needs to be the same as in .github/workflows/main.yaml
FROM rocker/rstudio:latest

LABEL "name"="openairegraph"
LABEL "maintainer"="Nako Jahn <najko.jahn@gmail.com>"
LABEL "repository"="https://github.com/subugoe/openairegraph"
LABEL "homepage"="https://subugoe.github.io/openairegraph/"

COPY DESCRIPTION DESCRIPTION

# copy in cache
# if this is run outside of github actions, will just copy empty dir
COPY deps/ /usr/local/lib/R/site-library/
# install system dependencies
RUN Rscript -e "options(warn = 2); install.packages('remotes')"
RUN Rscript -e "options(warn = 2); remotes::install_github('r-hub/sysreqs', ref='3860f2b512a9c3bd3db6791c2ff467a1158f4048')"
ENV RHUB_PLATFORM="linux-x86_64-debian-gcc"
RUN sysreqs=$(Rscript -e "cat(sysreqs::sysreq_commands('DESCRIPTION'))") && \
  eval "$sysreqs"

# install dependencies
RUN Rscript -e "options(warn = 2); remotes::install_deps(dependencies = TRUE)"
