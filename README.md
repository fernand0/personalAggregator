# Personal Aggregator with Jekyll

This project is a personal content aggregator built with Jekyll and Python. It automatically fetches content from various sources (like RSS feeds), generates posts, and publishes them as a static website using GitHub Pages.

This `master` branch serves as a template for anyone who wants to set up their own personal aggregator site.

**Live Demo:** [ElMundoEsImperfecto](https://elmundoesimperfecto.com)

---

## How it Works

This project uses two main branches for a clean workflow:

*   **`master`**: This branch. It contains the source code and template for the site. You do your work here.
*   **`gh-pages`**: This branch contains the content for the live, published website. The build script automatically updates this branch.

The process is managed by a build script that:
1.  Runs a Python script to fetch content and create Jekyll posts.
2.  Switches to the `gh-pages` branch.
3.  Commits the new posts and pushes them.
4.  GitHub Pages detects the changes on the `gh-pages` branch and builds/deploys the final website.

---

## Prerequisites

Before you begin, ensure you have the following installed:
*   [Git](https://git-scm.com/)
*   [Ruby](https://www.ruby-lang.org/en/downloads/) and [Bundler](https://bundler.io/)
*   [Python](https://www.python.org/downloads/) (3.x recommended)

---

## Setup and Configuration

1.  **Clone this Repository**
    ```bash
    git clone https://github.com/fernand0/personalAggregator.git
    cd your-repo-name
    ```

2.  **Get the Python Scripts**
    This template relies on external Python scripts for content aggregation. You will need to fetch them:
    *   **Aggregator Script:** [personalAggregator.py](https://github.com/fernand0/scripts/blob/master/personalAggregator.py)
    *   **Dependency:** [socialModules](https://github.com/fernand0/socialModules/)

    The build script (`_bin/build.sh`) assumes these scripts are located at specific paths. You **must** update these paths inside the script to match where you've placed them.

3.  **Set up Python Environment**
    It's recommended to use a Python virtual environment for the aggregation scripts and their dependencies.

4.  **Install Jekyll Dependencies**
    ```bash
    bundle install
    ```

5.  **Configure Your Content Sources**
    You will need to edit your local copy of `personalAggregator.py` to fetch content from your desired sources (RSS feeds, APIs, etc.).

---

## Usage

Once everything is configured, using the project is simple:

1.  **Run the Build Script**
    From the project root on the `master` branch, run:
    ```bash
    ./_bin/build.sh
    ```
    *You may need to make it executable first: `chmod +x _bin/build.sh`*

2.  **Done!**
    The script will handle everything. Check your repository's settings to find your site's URL on GitHub Pages.

---
## Credits

*   This site was originally based on [@sharu725's cards](https://github.com/sharu725/cards).
*   The Jekyll template was tweaked from Mozilla Foundation's [Solo](https://soloist.ai/).

For more themes, visit [https://jekyll-themes.com](https://jekyll-themes.com).