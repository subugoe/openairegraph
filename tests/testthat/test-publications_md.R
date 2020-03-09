test_that("publication parser publications_md works", {
  a <- oarg_publications_md(xml2::read_xml("../multiple_projects.xml"))
  b <- oarg_publications_md(xml2::read_xml("../one_project.xml"))

  expect_is(a, "tbl_df")
  expect_is(a$authors, "list")
  expect_equal(ncol(data.frame(a$collected_from)), 3)
  expect_equal(ncol(data.frame(a$pids)), 2)
  expect_equal(ncol(data.frame(a$authors)), 5)
  expect_equal(ncol(a), 10)
  expect_equal(nrow(a), 1)

  expect_is(b, "tbl_df")
  expect_is(b$authors, "list")
  expect_equal(ncol(b), 10)
  expect_equal(ncol(data.frame(b$collected_from)), 3)
  expect_equal(ncol(data.frame(b$pids)), 2)
  expect_equal(ncol(data.frame(b$authors)), 5)
  expect_equal(nrow(b), 1)
  expect_equal(is.na(b$publisher), TRUE)

  # not a valid xml
  expect_error(publications_md("dkdk"))
})
