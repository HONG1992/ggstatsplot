context("t_test_subtitles")

test_that("t-test subtitles work", {

  # for reproducibility
  set.seed(123)

  # loading the dataset
  data("bugs", package = "jmv")

  # expected output from jamovi
  jmv_df <- jmv::ttestPS(
    data = bugs,
    pairs = list(
      list(i1 = "HDLF", i2 = "HDHF")
    ),
    bf = TRUE,
    miss = "listwise"
  )

  # preparing long format dataframe
  bugs_long <- tibble::as.tibble(x = bugs) %>%
    dplyr::select(.data = ., HDLF, HDHF) %>%
    tidyr::gather(data = ., "key", "value", convert = TRUE)

  # output from ggstatsplot helper subtitle
  subtitle <-
    subtitle_ggbetween_t_bayes(
      data = bugs_long,
      x = key,
      y = value,
      paired = TRUE
    )

  # extracting only the numbers and creating a tibble
  subtitle_vec <- num_parser(ggstats.obj = subtitle)

  # testing values

  # t-value from student's t-test
  testthat::expect_equal(
    expected = as.data.frame(jmv_df$ttest)$`stat[stud]`,
    object = subtitle_vec[[2]],
    tolerance = 1e-3
  )
})
