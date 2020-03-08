test_that("multiplication works", {
  a <- oarg_linked_ftxt(xml2::read_xml("../multiple_projects.xml"))
  b <- oarg_linked_ftxt(xml2::read_xml("../one_project.xml"))

  expect_is(a, "tbl_df")
  expect_equal(ncol(a), 5)
  expect_equal(nrow(a), 4)

  expect_is(b, "tbl_df")
  expect_equal(ncol(b), 5)
  expect_equal(nrow(b), 3)

  expect_error(oarg_linked_ftxt("dkdk"))

})
