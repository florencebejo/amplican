% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/amplican.R
\name{amplicanPipeline}
\alias{amplicanPipeline}
\title{Wraps main package functionality into one function.}
\usage{
amplicanPipeline(
  config,
  fastq_folder,
  results_folder,
  knit_reports = TRUE,
  write_alignments_format = "txt",
  average_quality = 30,
  min_quality = 0,
  use_parallel = FALSE,
  scoring_matrix = Biostrings::nucleotideSubstitutionMatrix(match = 5, mismatch = -4,
    baseOnly = TRUE, type = "DNA"),
  gap_opening = 25,
  gap_extension = 0,
  fastqfiles = 0.5,
  primer_mismatch = 0,
  donor_mismatch = 3,
  PRIMER_DIMER = 30,
  event_filter = TRUE,
  cut_buffer = 5,
  promiscuous_consensus = TRUE,
  normalize = c("guideRNA", "Group"),
  min_freq = min_freq_default
)
}
\arguments{
\item{config}{(string) The path to your configuration file. For example:
\code{system.file("extdata", "config.txt", package = "amplican")}.
Configuration file can contain additional columns, but first 11 columns
have to follow the example config specification.}

\item{fastq_folder}{(string) Path to FASTQ files. If not specified,
FASTQ files should be in the same directory as config file.}

\item{results_folder}{(string) Where do you want to store results?
The package will create files in that folder so make sure you have writing
permissions.}

\item{knit_reports}{(boolean) whether function should "knit" all
reports automatically for you (it is time consuming, be patient), when false
reports will be prepared, but not knitted}

\item{write_alignments_format}{(character vector) Whether
\code{amplicanPipeline} should write alignments results to separate files.
Alignments are also always saved as .rds object of
\code{\link{AlignmentsExperimentSet}} class.
Possible options are:
\itemize{
 \item{"fasta"}{ outputs alignments in fasta format where header indicates
experiment ID, read id and number of reads}
 \item{"txt"}{ simple format, read information followed by forward read and
 amplicon sequence followed by reverse read with its amplicon sequence
 eg.: \cr
\preformatted{
ID: ID_1 Count: 7
ACTGAAAAA--------
ACTG-----ACTGACTG

------G-ACTG
ACTGACTGACTG
}}
\item{"None"}{ Don't write any alignments to files.}
\item{c("fasta", "txt")}{ There are also possible combinations of
above formats, pass a vector to get alignments in multiple formats.}
}}

\item{average_quality}{(numeric) The FASTQ file have a quality for each
nucleotide, depending on sequencing technology there exist many formats.
This package uses \code{\link[ShortRead]{readFastq}} to parse the reads.
If the average quality of the reads fall below value of
\code{average_quality} then sequence is filtered. Default is 0.}

\item{min_quality}{(numeric)  Similar as in average_quality, but depicts
the minimum quality for ALL nucleotides in given read. If one of nucleotides
has quality BELLOW \code{min_quality}, then the sequence is filtered.
Default is 20.}

\item{use_parallel}{(boolean) Set to TRUE, if you have registered
multicore back-end.}

\item{scoring_matrix}{(matrix) Default is 'NUC44'. Pass desired matrix using
\code{\link{nucleotideSubstitutionMatrix}}.}

\item{gap_opening}{(numeric) The opening gap score.}

\item{gap_extension}{(numeric) The gap extension score.}

\item{fastqfiles}{(numeric) Normally you want to use both FASTQ files. But in
some special cases, you may want to use only the forward file, or only
the reverse file. Possible options:
\itemize{
 \item{0}{ Use both FASTQ files.}
 \item{0.5}{ Use both FASTQ files, but only for one of the reads (forward or
 reverse) is required to have primer perfectly matched to sequence - eg. use
 when reverse reads are trimmed of primers, but forward reads have forward
 primer in the sequence.}
 \item{1}{ Use only the forward FASTQ file.}
 \item{2}{ Use only the reverse FASTQ file.}
}}

\item{primer_mismatch}{(numeric) Decide how many mismatches are allowed
during primer matching of the reads, that groups reads by experiments.
When \code{primer_mismatch = 0} no mismatches are allowed, which can increase
number of unasssigned read.}

\item{donor_mismatch}{(numeric) How many events of length 1 (mismatches,
deletions and insertions of length 1) are allowed when aligning toward the
donor template. This parameter is only used when donor template is specified.
The higher the parameter the less strict will be algorithm accepting read as
HDR. Set to 0 if only perfect alignments to the donor template marked as HDR,
unadvised due to error rate of the sequencers.}

\item{PRIMER_DIMER}{(numeric) Value specifying buffer for PRIMER DIMER
detection. For a given read it will be recognized as PRIMER DIMER when
alignment will introduce gap of size bigger than: \cr
\code{length of amplicon - (lengths of PRIMERS + PRIMER_DIMER value)}}

\item{event_filter}{(logical) Whether detection of offtarget reads,
should be enabled.}

\item{cut_buffer}{The number of bases by which extend expected cut sites
(specified as UPPER case letters in the amplicon) in 5' and 3' directions.}

\item{promiscuous_consensus}{(boolean) Whether rules of
\code{\link{amplicanConsensus}} should be \code{promiscuous}. When
promiscuous, we allow indels that have no confirmation on the other strand.}

\item{normalize}{(character vector) If column 'Control' in config table
has all FALSE/0 values then normalization is skipped. Otherwise,
normalization is strict, which means events that are
found in 'Control' TRUE group will be removed in 'Control' FALSE group.
This parameter by default uses columns 'guideRNA' and 'Group' to impose
additional restrictions on normalized events eg. only events created by the
same 'guideRNA' in the same 'Group' will be normalized.}

\item{min_freq}{(numeric) All events below this frequency are treated as
sequencing errors and rejected. This parameter is used during normalization
through \code{\link{amplicanNormalize}}.}
}
\value{
(invisible) results_folder path
}
\description{
amplicanPipeline is convenient wrapper around all functionality of the
package with the most robust settings. It will generate all results in the
\code{result_folder} and also knit prepared reports into 'reports' folder.
}
\examples{
# path to example config file
config <- system.file("extdata", "config.csv", package = "amplican")
# path to example fastq files
fastq_folder <- system.file("extdata", package = "amplican")
# output folder
results_folder <- tempdir()

#full analysis, not knitting files automatically
amplicanPipeline(config, fastq_folder, results_folder, knit_reports = FALSE)

}
\seealso{
Other analysis steps: 
\code{\link{amplicanAlign}()},
\code{\link{amplicanConsensus}()},
\code{\link{amplicanFilter}()},
\code{\link{amplicanMap}()},
\code{\link{amplicanNormalize}()},
\code{\link{amplicanOverlap}()},
\code{\link{amplicanPipelineConservative}()},
\code{\link{amplicanReport}()},
\code{\link{amplicanSummarize}()}
}
\concept{analysis steps}
