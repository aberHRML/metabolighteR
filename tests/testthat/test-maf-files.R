test_that("create.MAF creates empty MAF with expected standard columns", {
  maf <- create.MAF(nrow = 3)

  expect_s3_class(maf, "data.frame")
  expect_equal(nrow(maf), 3)
  expect_equal(
    names(maf),
    c(
      "database_identifier", "chemical_formula", "smiles", "inchi",
      "metabolite_identification", "mass_to_charge", "fragmentation",
      "charge", "modifications", "retention_time", "taxid", "species",
      "database", "database_version", "reliability", "uri",
      "search_engine", "search_engine_score",
      "smallmolecule_abundance_sub",
      "smallmolecule_abundance_stdev_sub",
      "smallmolecule_abundance_std_error_sub"
    )
  )
  expect_true(all(vapply(maf, function(x) all(is.na(x)), logical(1))))
})

test_that("create.MAF appends abundance columns when abundances are supplied", {
  abundances <- data.frame(
    sample1 = c(1, 2),
    sample2 = c(3, 4),
    check.names = FALSE
  )

  maf <- create.MAF(abundances = abundances)

  expect_equal(nrow(maf), 2)
  expect_equal(maf$sample1, c(1, 2))
  expect_equal(maf$sample2, c(3, 4))
  expect_true(all(c("sample1", "sample2") %in% names(maf)))
})

test_that("create.MAF errors when neither nrow nor abundances are supplied", {
  expect_error(create.MAF(), "need either nrow or abundances")
})

test_that("write.MAF and read.MAF round-trip a MAF-like table", {
  maf <- data.frame(
    "database_identifier" = "HMDB00001",
    "metabolite_identification" = "Alanine",
    "sample name" = "sample-10",
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  path <- tempfile(fileext = ".tsv")

  write.MAF(maf, file = path)
  out <- read.MAF(path)

  expect_equal(names(out), names(maf))
  expect_equal(out[[1]], maf[[1]])
  expect_equal(out[[2]], maf[[2]])
  expect_equal(out[[3]], maf[[3]])
})
