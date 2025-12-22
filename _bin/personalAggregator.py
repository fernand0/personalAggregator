#!/usr/bin/env python

import argparse
import dateparser
import logging
import os
import pathlib
import re
import sys

import socialModules
import socialModules.moduleRules

# You need to have installed the socialModules (branch dist provides the
# package installed with its requirements):
#
# https://github.com/exampleuser/socialModules/tree/dist
#
# You can fork or clone and install it or, if you trust the project:
# pip install social-modules@git+ssh://git@github.com/exampleuser/socialModules@dist
#
# This will change in the future, when enought test has been done
#
# Configuration example:
#
# There are mainly some RSS sites (blogs) and a Twitter account.
#
# File: ~/.myConfig/social/.rssElmundo
#
# [Blog1]
# url:http://example.blogalia.com/
# rss:rss20.xml
# posts:posts
# html:
# [Blog2]
# url:http://exampleuser.github.io/
# rss:feed.xml
# posts:posts
# html:
# [Blog4]
# url:http://example.wordpress.com/
# rss:feed/
# posts:posts
# html:
# [Blog5]
# url:https://dev.to/exampleuser
# rss:https://dev.to/feed/exampleuser
# posts:posts
# html:
# [Blog8]
# url:https://twitter.com/exampleuser
# posts:posts
# html:

# List of known services to categorize posts.
# You can add or remove services from this list.
knownServices = [
    "reddit",
    "github",
    "flickr",
    "goodreads",
    "youtube",
    "wordpress",
    "dev.to",
    "tumblr",
]

LINE_FORMATS = {
    "mastodon": "* {title} ([toot]({link}))\n",
    "twitter": "* {title} ([tweet]({link}))\n",
    "general": "* {title}\n",
}

FRONT_MATTER_TEMPLATE = """---
layout: post
title:  \"{title}\"\nsiteUrl: \"{url}\"\ndate:   {date}\ncategories: {categories}\n---
"""


def parse_arguments():
    parser = argparse.ArgumentParser(description="Personal Aggregator")
    parser.add_argument(
        "--config-file",
        dest="configFile",
        default=".rssElmundo",
        help="Configuration file path",
    )
    parser.add_argument(
        "--output-dir",
        dest="outputDir",
        default="/tmp",
        help="Output directory path",
    )
    parser.add_argument(
        "--num-posts",
        dest="numPosts",
        type=int,
        default=10,
        help="Number of posts to process",
    )
    parser.add_argument(
        "--log-level",
        dest="logLevel",
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="Set the logging level",
    )
    return parser.parse_args()


def load_rules(config_file):
    rules = socialModules.moduleRules.moduleRules()
    rules.checkRules(configFile=config_file)
    return rules


def process_rule(key, rules):
    logging.info(f"Processing rule: {key}")
    apiSrc = rules.readConfigSrc("", key, rules.more[key])
    posts = None
    try:
        apiSrc.setPosts()
        posts = apiSrc.getPosts()
    except Exception as e:
        logging.error(f"Error processing rule {key}: {e}")
    return apiSrc, posts


def _get_display_title(api_source):
    title = api_source.getSiteTitle()
    if not title:
        service = api_source.getService()
        nick = api_source.getNick()
        if service and nick:
            title = f"{service} - {nick}"
        else:
            url = api_source.getUrl()
            if service and url:
                title = f"{service} - {url}"
            else:
                title = "Unknown Title"
    return title


def _get_front_matter(api_source, post_key, post_date):
    title = _get_display_title(api_source)

    category = post_key[0]
    for service in knownServices:
        if service in api_source.getUrl():
            category = service.replace('.', '')
            break

    url = api_source.getUrl()

    return FRONT_MATTER_TEMPLATE.format(
        title=title, url=url, date=post_date, categories=category
    )


def delete_old_posts(output_dir, new_post_url, new_post_filename):
    """
    Deletes old posts from the same source.

    Args:
        output_dir (str): The directory where the posts are stored.
        new_post_url (str): The URL of the source of the new post.
        new_post_filename (str): The filename of the new post.
    """
    logging.info(f"Deleting old posts from {new_post_url} in {output_dir}")
    # logging.info(f"Files: {os.listdir(output_dir)}")
    for filename in os.listdir(output_dir):
        # logging.info(f"Filename: {filename}")
        if not filename.endswith(".md"):
            continue

        filepath = os.path.join(output_dir, filename)
        if filepath == new_post_filename:
            continue

        try:
            with open(filepath, "r") as f:
                content = f.read()
                match = re.search(r"siteUrl:\s*\"([^\"]+)\"", content)
                if match:
                    # logging.info(f"Match: {match.group(1)}")
                    site_url = match.group(1)
                    if site_url == new_post_url:
                        logging.info(f"Deleting old post: {filepath}")
                        os.remove(filepath)
        except Exception as e:
            logging.error(f"Error processing file {filepath}: {e}")


def generate_post_file(apiSrc, posts, output_dir, post_index, key, num_posts):
    myFilePath = pathlib.Path(output_dir)
    logging.info(f"Output directory is: {output_dir}")
    if not myFilePath.is_dir():
        logging.error(f"Output directory not found: {output_dir}")
        sys.exit("The path should be a directory and it should exist")

    timePost = None
    if hasattr(apiSrc, "getPostTime"):
        timePost = apiSrc.getPostTime(posts[0])
    if not timePost:
        timePost = "2024-01-01 00:00:00+00:00"
    logging.info(f"Time post: {timePost}")
    timePost = dateparser.parse(str(timePost))

    postFile = myFilePath.joinpath(f"{str(timePost)[:10]}-post-{post_index:02}.md")

    front_matter = _get_front_matter(apiSrc, key, timePost)

    with open(postFile, "w") as fSal:
        fSal.write(front_matter)

        for post in posts[:num_posts]:
            if isinstance(post, str):
                continue
            title = apiSrc.getPostTitle(post)
            title = title.replace('<', '&lt;').replace('>', '&gt;')
            link = apiSrc.getPostLink(post)

            # Some of my posts (mainly in social networks include
            # a URL in the title. In these cases we will use this
            # link for the title and the other in parentheses
            pos = title.find("http")
            posF = title.find(" ", pos + 1)
            if pos >= 0:
                if posF < pos:
                    posF = len(title)
                linkT = title[pos:posF]
                title = title[:pos]
            else:
                linkT = link

            title = f" [{title}]({linkT})"
            title = title.replace("|", "\|")

            service = apiSrc.getService()
            if service in LINE_FORMATS:
                fSal.write(LINE_FORMATS[service].format(title=title, link=link))
            else:
                fSal.write(LINE_FORMATS["general"].format(title=title, link=link))
    delete_old_posts(output_dir, apiSrc.getUrl(), str(postFile))

def main():
    args = parse_arguments()
    logging.basicConfig(
        stream=sys.stdout, level=args.logLevel, format="%(asctime)s %(levelname)s %(message)s"
    )
    rules = load_rules(args.configFile)

    i = 0
    for key in rules.rules.keys():
        apiSrc, posts = process_rule(key, rules)
        if posts and apiSrc.getPostsType():
            i = i + 1
            generate_post_file(apiSrc, posts, args.outputDir, i, key, args.numPosts)


if __name__ == "__main__":
    main()
