#!/usr/bin/env python

import logging
import sys

def main():

    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG,
            format='%(asctime)s %(message)s')

    import moduleRules
    rules = moduleRules.moduleRules()
    rules.checkRules(configFile = '.rssElmundo')

    i = 0
    fileName = '_posts/2022-10-01-post-'
    for key in rules.rules.keys():
        apiSrc = rules.readConfigSrc("", key, rules.more[key])

        apiSrc.setPosts()
        posts = apiSrc.getPosts()
        if posts and apiSrc.getPostsType():
            i = i + 1
            # print(f"{i})-> Posts: {posts}")
            with open(f'{fileName}{i:02}.md','w') as fSal:
                fSal.write(f'---\n')
                fSal.write(f'layout: post\n')
                fSal.write(f'title:  "{apiSrc.getSiteTitle()}"\n')
                if 'reddit' in  apiSrc.getUrl():
                    fSal.write(f'categories: reddit\n')
                elif 'github' in  apiSrc.getUrl():
                    fSal.write(f'categories: github\n')
                elif 'flickr' in  apiSrc.getUrl():
                    fSal.write(f'categories: flickr\n')
                elif 'goodreads' in  apiSrc.getUrl():
                    fSal.write(f'categories: goodreads\n')
                elif 'youtube' in  apiSrc.getUrl():
                    fSal.write(f'categories: youtube\n')
                elif 'wordpress' in  apiSrc.getUrl():
                    fSal.write(f'categories: wordpress\n')
                elif 'dev.to' in  apiSrc.getUrl():
                    fSal.write(f'categories: devto\n')
                elif 'tumblr' in  apiSrc.getUrl():
                    fSal.write(f'categories: tumblr\n')
                else:
                    fSal.write(f'categories: {key[0]}\n')
                fSal.write(f'---\n')
                for post in posts[:10]:
                    title = apiSrc.getPostTitle(post)
                    link = apiSrc.getPostLink(post)
                    print(f"Title: {title}")
                    print(f"Link: {link}")
                    pos = title.find('http')
                    posF = title.find(' ', pos + 1)
                    if pos>=0:
                        if posF < pos:
                            posF = len(title)
                        linkT = title[pos:posF]
                        title = (f" [{title[:pos]}]({linkT})")
                    print(f"TTTitle: {title}")
                    title = title.replace('|','\|')
                    if key[0] == 'rss':
                        fSal.write(f'* [{title}]({link})\n')
                    elif key[0] == 'mastodon':
                        fSal.write(f"* {title} ([toot]({link}))\n")
                    else:
                        fSal.write(f'* {title} ([tweet]({link}))\n')

    return


if __name__ == "__main__":
    main()
