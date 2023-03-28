test_that("read_fwc() works", {
  skip_if_offline()
  skip_on_cran()

  df <- expect_silent(read_fwc())
  expect_length(df, 5)
  expect_gt(nrow(df), 300)
  expect_identical(colnames(df),
                   c("date", "indicator", "union", "value"))
})
