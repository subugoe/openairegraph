test_that("affiliation parser oaarg_linked_affiliations works", {
    a <- oarg_linked_affiliations(xml2::read_xml("../multiple_projects.xml"))
    b <- oarg_linked_affiliations(xml2::read_xml("../one_project.xml"))

    expect_is(a, "tbl_df")
    expect_equal(ncol(a), 3)
    expect_equal(nrow(a), 52)

    expect_is(b, "tbl_df")
    expect_equal(ncol(b), 3)
    expect_equal(nrow(b), 0)

    # not a valid xml
    expect_error(oarg_linked_affiliations("dkdk"))
  })
