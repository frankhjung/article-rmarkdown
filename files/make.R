#!/usr/bin/env R

# Render R markdown (Rmd) to HTML or PDF.
#
# Usage:
#   R -q -f make.R --args [file.(html|pdf)] ...
#   R --quiet --slave --vanilla --file=make.R --args [file.(html|pdf)] ...

# load packages
require(rmarkdown)

# Check if pagedown is available for CSS-based PDFs
pagedown_available <- requireNamespace("pagedown", quietly = TRUE)

# require parameters: source file and output file
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 1) {
  # Legacy mode: infer source from output
  if (endsWith(args[1], "html")) {
    render(
      gsub("html$", "Rmd", args[1]),
      html_document(
        css = "files/article.css",
        theme = NULL,
        highlight = NULL,
        self_contained = TRUE
      )
    )
  } else if (endsWith(args[1], "pdf")) {
    render(gsub("pdf$", "Rmd", args[1]), pdf_document())
  }
} else if (length(args) == 2) {
  # New mode: source file and output file specified
  source_file <- args[1]
  output_file <- args[2]
  if (endsWith(output_file, "html")) {
    render(source_file,
      html_document(
        css = "files/article.css",
        theme = NULL,
        highlight = NULL,
        self_contained = TRUE
      ),
      output_file = output_file
    )
  } else if (endsWith(output_file, "pdf")) {
    # Use standard LaTeX PDF rendering to honour preamble.tex
    render(source_file, pdf_document(
      toc = TRUE,
      toc_depth = 3,
      includes = includes(in_header = "files/preamble.tex")
    ), output_file = output_file)
  }
} else {
  stop("ERROR: wrong number of arguments (expected 1 or 2)", call. = TRUE)
}
