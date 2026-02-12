# Rmarkdown Articles

This `rmarkdown` folder is the parent folder for all Rmarkdown articles. Each
article is in its own subfolder (`<article_name>`), and each subfolder contains
an `article.Rmd` file (e.g. `base-rate/article.Rmd`) that contains the main
content of the article. Here the article subfolder name is `base-rate`.

## Objective

We would like to set up this project so it can be re-used for multiple articles.

There are three main components to this project:

1. A pre-built GNU R Docker image (`ghcr.io/frankhjung/gnur:4.5.2`) that
   contains the Rmarkdown build tools. This will render the `Rmd` file to
   `HTML`.
2. A local Rmarkdown workflow using GNU Make to render the article as an HTML
   document. This will use the make file in the `<article_name>` subfolder to
   build the article, and the result will be an HTML file located at
   `<article_name>/public/article.html`.
3. A custom GitHub Actions workflow that uses the GNU R Docker image from part 1
   to build the article and publish it to Blogger. The GitHub Actions pipeline
   will build an HTML artifact: `article.html`. This will be published to
   Blogger. The pipeline should be parameterised by the article name, so that it
   can be reused for each article. The pipeline need only build and publish one
   article at a time, so it can be triggered manually with the article name
   (`article_name`) as a parameter.

Additionally, create a `README.md` explaining and documenting the project.

### Notes

* The Docker image publishing the HTML document exists. See
  <https://github.com/frankhjung/docker-blogger>.
* The project workflow also exists. See
  <https://github.com/frankhjung/article-markdown>. But, the top-level
  `Makefile` needs to be prepared. This can be based upon
  <https://raw.githubusercontent.com/frankhjung/article-markdown/refs/heads/main/Makefile>

## Part 1: GNU R Docker Image

The project uses a pre-built GNU R Docker image from GHCR
(`ghcr.io/frankhjung/gnur:4.5.2`) that contains the Rmarkdown build tools to
render `Rmd` to `HTML`. There is no local `Dockerfile`; the image is pulled
directly.

The image should contain the following R packages:

* `knitr`, `rmarkdown`, `ggplot2`, `dplyr`, `tidyr`, `readr`, `lubridate`,
  `forcats`, `stringr`, `purrr`, `magrittr`, `rlang`, `tibble`, `broom`,
  `scales`.

### Running Locally with Docker

#### Run from GHCR

```bash
docker run --rm \
  -v "$PWD":/workspace \
  -w /workspace \
  ghcr.io/frankhjung/gnur:4.5.2 \
  make -B base-rate
```

#### Run from DockerHub

```bash
docker run --rm \
  -v "$PWD":/workspace \
  -w /workspace \
  frankhjung/gnur:4.5.2 \
  make -B base-rate
```

## Part 2: RMarkdown Workflow

### Build

The project needs a root `Makefile` that delegates builds to individual article
sub-folders. A common `files/article.mk` file in the root directory should
contain the shared build logic. There is also a basic R make file
`files/make.R`. When `make` is run from the root with an article name (e.g.
`make -B base-rate`), it should trigger the build for that article, which will
use the `files/article.mk` and `files/make.R` files to build the article. The
result of the build should be an HTML file located at
`<article_name>/public/article.html`.

### Root Makefile

The root `Makefile` handles listing articles and triggering their specific
builds.

#### Makefile target: new-article

The `new-article` target will create a new article subfolder with the given
article name. It will:

* read the `article_name` variable from the command line (e.g.
  `make new-article article_name=base-rate`)
* create a new folder `<article_name>` in the root directory
* link the `files/article.mk` to `<article_name>/Makefile`
* link the `files/make.R` to `<article_name>/make.R`
* copy the template `files/article.Rmd` to `<article_name>/article.Rmd`
* create an `<article_name>/images` folder
* copy the banner image `images/banner.jpg` to
  `<article_name>/images/banner.jpg`
* create an `<article_name>/files` folder
* link `files/article.css` to `<article_name>/files/article.css`
* link `files/preamble.tex` to `<article_name>/files/preamble.tex`

### Article Makefile Template

Each article folder should have its own `Makefile` which is a hard link to
`files/article.mk`, and the R build script is a hard link to `files/make.R`.

### Common Files

There are some common files (`files/`) that will be used for each article:

* `files/article.css` — This file contains the CSS styles for the article.
* `files/preamble.tex` — This file contains the TeX preamble for the article.

These are hard links from the root project folder, `rmarkdown/`.

### Images

There is an image folder (`images/`) for each article, and the images should be
placed in that folder. The images can be referenced in the `article.Rmd` file
using relative paths. There will be at least one image being the article banner,
`images/banner.jpg`.

### Docs

Record project documentation in `docs/`. This is a top level folder that will
not be duplicated in each article folder. This file is `requirements.md`. Other
files may be added to this folder as needed.

## Part 3: GitHub Pipeline

The project will have one GitHub pipeline (`publish.yml`) that will build the
article and publish it to Blogger.

The pipeline will build one HTML artifact: `article.html`. This will then be
published to Blogger using the provided metadata and secrets.

The pipeline is triggered manually via `workflow_dispatch` and takes the
following parameters:

* **article_name**: The name of the article subfolder (e.g., `base-rate`).
* **article_title**: The title of the post as it will appear on Blogger.
* **article_labels**: A comma-separated list of labels for the Blogger post.

The pipeline performs the following steps:

1. **Validate Inputs**: Ensures all three parameters are provided. If all inputs
   are empty, the build is skipped. If only some inputs are provided, the
   workflow fails with an error.
2. **Build**: Uses the `ghcr.io/frankhjung/gnur:4.5.2` Docker image to run
   `make.R` with the article source, producing `article.html`.
3. **Publish**: Uses the `ghcr.io/frankhjung/blogger:v1.3` Docker image to
   upload the generated HTML to Blogger using the provided metadata and secrets.

* **Output:** `article.html` — the HTML file that is published to Blogger.

### Validate Inputs

Add a step to validate that all three parameters (`article_name`,
`article_title`, `article_labels`) are provided. If any parameter is missing,
the workflow should fail with an appropriate error message.

### Publish to Blogger

To publish to Blogger, use these secrets to authenticate with the Blogger API.
The secrets should be stored in the GitHub repository's secrets settings. The
following table lists the required secrets and their descriptions:

| Secret | Description |
| :----- | :---------- |
| `BLOGGER_BLOG_ID` | The unique identifier for your specific destination blog |
| `BLOGGER_CLIENT_ID` | The Google OAuth Client ID derived from the Cloud Console |
| `BLOGGER_CLIENT_SECRET` | The Google OAuth Client Secret used for authorisation |
| `BLOGGER_REFRESH_TOKEN` | The secure token that allows for long-term, non-interactive API access |

Use the following GitHub Action step to publish the article to Blogger:

```yaml
- name: publish to blog
  if: success()
  uses: docker://ghcr.io/frankhjung/blogger:v1.3
  with:
    args: >-
      --source-file "article.html"
      --title "${{ inputs.article_title }}"
      --labels "${{ inputs.article_labels }}"
      --blog-id "${{ secrets.BLOGGER_BLOG_ID }}"
      --client-id "${{ secrets.BLOGGER_CLIENT_ID }}"
      --client-secret "${{ secrets.BLOGGER_CLIENT_SECRET }}"
      --refresh-token "${{ secrets.BLOGGER_REFRESH_TOKEN }}"
```

The GitHub pipeline should be called `.github/workflows/publish.yml`.
