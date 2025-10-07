# Personal Aggregator

> **Note:** Changes should only be made in the `master` branch, as `gh-pages` is the publishing branch.

`personalAggregator.py` is a Python script designed to aggregate content from various sources based on user-defined rules, and generate markdown files suitable for static site generators like Jekyll.

## Prerequisites

*   Python 3.x
*   pip (Python package installer)

## Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/personalAggregator.git
    cd personalAggregator
    ```

2.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

## Configuration (`rules.json`)

The script uses a JSON file (e.g., `rules.json`) to define the aggregation rules. This file should contain a list of rule objects, where each object specifies how to fetch and process content from a particular URL.

Each rule object can have the following properties:

*   `url` (string, required): The URL of the page to scrape.
*   `selector` (string, required): A CSS selector to identify the main content block for each item.
*   `title_selector` (string, required): A CSS selector to extract the title of each item within its content block.
*   `date_selector` (string, required): A CSS selector to extract the date of each item within its content block.
*   `date_format` (string, optional): The format of the date string (e.g., `%Y-%m-%d`). If omitted, `dateparser` will attempt to parse the date automatically.
*   `tags` (array of strings, optional): A list of tags to apply to the generated markdown post.
*   `output_filename_prefix` (string, optional): A prefix to use for the generated markdown filename.

**Example `rules.json`:**

```json
[
  {
    "url": "https://example.com/blog",
    "selector": ".post-item",
    "title_selector": ".post-title a",
    "date_selector": ".post-date",
    "date_format": "%Y-%m-%d",
    "tags": ["blog", "example"],
    "output_filename_prefix": "example-blog"
  },
  {
    "url": "https://anothersite.com/news",
    "selector": "article.news-entry",
    "title_selector": "h2.entry-title",
    "date_selector": ".entry-meta .date",
    "tags": ["news"],
    "output_filename_prefix": "another-news"
  }
]
```

## Usage

Run the `personalAggregator.py` script from the root of the repository.

```bash
python _bin/personalAggregator.py [OPTIONS]
```

**Options:**

*   `--config-file <path>`: Path to your JSON configuration file (e.g., `rules.json`). **Required.**
*   `--output-dir <path>`: Directory where the generated markdown post files will be saved (e.g., `_posts/`). **Required.**
*   `--num-posts <number>`: The maximum number of posts to generate for each rule. Defaults to 1.
*   `--log-level <level>`: Set the logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL). Defaults to INFO.

**Example Command:**

To generate 5 posts from your `rules.json` file and save them to the `_posts/` directory with INFO level logging:

```bash
python _bin/personalAggregator.py --config-file rules.json --output-dir _posts/ --num-posts 5 --log-level INFO
```