# Article Template R-markdown

## Overview

This is a template project to render an Rmd project into HTML and PDF for
publishing to [Blogger](https://www.blogger.com/).

## Source

The primary source file: [project_name_here.Rmd](project_name_here.Rmd)

Rename this to a meaningful name based on the article you are writing.

Additional files:

- [Makefile](Makefile) - Makefile for building HTML and PDF
- [make.R](make.R) - R rendering script
- [files/article.css](files/article.css) - HTML styling
- [files/preamble.tex](files/preamble.tex) - LaTeX preamble for PDF

## Prerequisites

- [R](https://www.r-project.org/) (version 4.0 or higher recommended)
- R packages: `rmarkdown`, `ggplot2`, `knitr`
- [pandoc](https://pandoc.org/) (usually bundled with RStudio or rmarkdown)
- A TeX distribution for PDF output:
  - Linux: TeX Live (`sudo apt install texlive-xetex texlive-fonts-recommended`)
  - macOS: MacTeX
  - Windows: MiKTeX or TeX Live

### Installing R Packages

```r
install.packages(c("rmarkdown", "ggplot2", "knitr"))
```

### Limitations

To use this template and publish to Blogger, you need:

- Generate the HTML from Rmd (use the `make` command or R directly). While
  simple Rmd can be rendered to HTML via a pipeline action, often there are more
  packages required than are available in the default GitHub Actions runner.

- While there is no size limit on publishing HTML to Blogger, it does seem to
  have issues with very large HTML files (e.g., >5MB). In such cases, consider
  splitting the article into multiple parts or hosting the HTML elsewhere.

## Building

### Using Make

```bash
# Builds both HTML and PDF
make

# Builds HTML only
make project_name_here.html

# Builds PDF only
make project_name_here.pdf

# Cleans generated files
make clean
```

### Using R Directly

```r
# From R console or RStudio
rmarkdown::render("project_name_here.Rmd", "html_document")
rmarkdown::render("project_name_here.Rmd", "pdf_document")
```

## Output Files

- **HTML**: `public/index.html` - web version with custom CSS
- **PDF**: `public/project_name_here.pdf` - print version with LaTeX formatting

## Deployment

The article is automatically published to GitHub Pages via GitHub Actions when
changes are pushed to the `main` branch. See
[.github/workflows/pages.yml](.github/workflows/pages.yml) for the deployment
workflow.

## References

See the article itself for data sources and references to NSW Health reports and
related studies.

## [MIT License](LICENSE)

© Frank H Jung 2026
