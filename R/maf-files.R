#' Read MAF file to dataframe
#'
#' Read the MAF file as data frame.
#'
#' @param file A filename to a MAF file
#' @return a data frame. Row and column names are NOT "fixed" via `make.names`
#' @export
#' @examples
#' file <- system.file("examples/m_MTBLS1968_LC-MS_positive_reverse-phase_metabolite_profiling_v2_maf.tsv",
#'                     package = "metabolighteR")
#' maf <- read.MAF(file)

read.MAF <- function(file) {
  maf <- read.delim(file=file,
                    comment.char="",
                    check.names=FALSE,
                    stringsAsFactors=FALSE)

  return(maf)
}

#' Write a dataframe to a MAF file
#'
#' Write a suitably formatted data frame to a MAF file.
#'
#' @param maf MAF data frame to write
#' @param file either a character string naming a file or a connection open for writing. "" indicates output to the console.
#' @importFrom utils read.delim write.table
#' @export
#' @examples
#' maf <- create.MAF(nrow=17)
#' write.MAF(maf, file=tempfile())

write.MAF <- function(maf, file="") {
  write.table(maf,
              file=file,
              row.names=FALSE, quote=TRUE, sep="\t", na="\"\"")
}

#' Create a dataframe representing a MAF file
#'
#' MAF files combine the metabolite abundance matrix,
#' the spectral data like m/z and retention time,
#' and the metabolite names, structures and database identifiers.
#'
#' If an abundance matrix is given, the the generated MAF will have
#' as many (empty) spectral and identification metadata rows as abundance rows,
#' joined to the provided abundance matrix.
#'
#' nrow and abundances should be mutually exclusive, but that is not yet tested.
#'
#' @param assaytype Currently unused, but would be used for different MAF files for NMR and MS
#' @param nrow Create the MAF with nrow empty rows.
#' @param abundances is a data frame or matrix with the metabolite abundances,
#' intensities or concentrations.
#' @export
#' @examples
#' maf <- create.MAF(nrow=17)

create.MAF <- function(assaytype="LCMS",
                                nrow=NULL,
                                abundances=NULL) {

  ##
  ## These columns are defined by MetaboLights mzTab
  ##

  maf.std.colnames <- c("database_identifier", "chemical_formula", "smiles", "inchi", "metabolite_identification",
                        "mass_to_charge", "fragmentation", "charge", "modifications", "retention_time",
                        "taxid", "species", "database", "database_version", "reliability",
                        "uri", "search_engine", "search_engine_score",
                        "smallmolecule_abundance_sub", "smallmolecule_abundance_stdev_sub",
                        "smallmolecule_abundance_std_error_sub")


  if (!missing(abundances)) {
    m1 <- as.data.frame(matrix(NA, nrow=nrow(abundances), ncol = length(maf.std.colnames)),
                              stringsAsFactors=FALSE)
    colnames(m1) <- maf.std.colnames

    maf <- cbind.data.frame(m1, abundances,
                            stringsAsFactors=FALSE)
  } else if (!missing(nrow)) {

    maf <- data.frame(matrix(NA, nrow = nrow, ncol = length(maf.std.colnames)),
                      check.names=FALSE,
                      stringsAsFactors=FALSE)
    colnames(maf) <- maf.std.colnames
  } else {
    stop("need either nrow or abundances")
  }
  return(maf)
}
