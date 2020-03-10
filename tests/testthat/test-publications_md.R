test_that("publication parser publications_md works", {
  a <- oarg_publications_md(xml2::read_xml("../multiple_projects.xml"))
  b <- oarg_publications_md(xml2::read_xml("../one_project.xml"))
  c <- oarg_publications_md(xml2::read_xml("../5dbc233b6dd7e56a3977efdf.xml"))
  d <- oarg_publications_md(xml2::read_xml("../5dbc230696a3706d45b5a2ff.xml"))

  expect_is(a, "tbl_df")
  expect_is(a$authors, "list")
  expect_equal(ncol(data.frame(a$collected_from)), 2)
  expect_equal(ncol(data.frame(a$pids)), 2)
  expect_equal(ncol(data.frame(a$authors)), 5)
  expect_equal(ncol(a), 12)
  expect_equal(nrow(a), 1)

  expect_is(b, "tbl_df")
  expect_is(b$authors, "list")
  expect_equal(ncol(b), 12)
  expect_equal(ncol(data.frame(b$collected_from)), 2)
  expect_equal(ncol(data.frame(b$pids)), 2)
  expect_equal(ncol(data.frame(b$authors)), 5)
  expect_equal(nrow(b), 1)
  expect_equal(is.na(b$publisher), TRUE)

  expect_is(c, "tbl_df")
  expect_is(c$authors, "list")
  expect_equal(ncol(data.frame(c$collected_from)), 2)
  expect_equal(ncol(data.frame(c$pids)), 2)
  expect_equal(ncol(data.frame(c$authors)), 5)
  expect_equal(ncol(c), 12)
  expect_equal(nrow(c), 1)

  expect_is(d, "tbl_df")
  expect_is(d$authors, "list")
  expect_equal(ncol(data.frame(d$collected_from)), 2)
  expect_equal(ncol(data.frame(d$pids)), 2)
  expect_equal(ncol(data.frame(d$authors)), 5)
  expect_equal(ncol(d), 12)
  expect_equal(nrow(d), 1)
  # can deal with missing author attributes
  expect_equal(is.na(unique(data.frame(d$authors)$author_surname)), TRUE)

  # not a valid xml
  expect_error(publications_md("dkdk"))
})
