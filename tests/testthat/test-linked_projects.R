test_that("parser linked_projects works", {
  a <- oarg_linked_projects(xml2::read_xml("../multiple_projects.xml"))
  b <- oarg_linked_projects(xml2::read_xml("../one_project.xml"))

  expect_is(a, "tbl_df")
  expect_match(unique(a$to), "project")
  expect_equal(ncol(a), 7)
  expect_equal(nrow(a), 22)

  expect_is(b, "tbl_df")
  expect_match(unique(a$to), "project")
  expect_equal(ncol(b), 7)
  expect_equal(nrow(b), 1)

  # not a valid xml
  expect_error(linked_projects("dkdk"))
})
