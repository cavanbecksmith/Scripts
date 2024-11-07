#!/bin/sh   

# bash ./link_scaper.sh tmp_file | grep '^a' | head -n 5

function test_two(){
    # print a list of all html tags
    xmlgetnext () {
        local IFS='>'
        read -d '<' TAG VALUE
    }

    curl https://devhints.io/bash > tmp_file
    #curl https://www.youtube.com/playlist?list=PLMC9KNkIncKtPzgY-5rmhvj7fax8fdxoj > tmp_file
    cat $1 | while xmlgetnext ; do echo $TAG ; done
}

url=$1

function link_scraper() {
    #!/usr/bin/env bash

    html=$( curl -# -L "${url}" 2> '/dev/null' )
    # html="<a href="google.com">test</a><a>test 2</a>sasdasdadsa"

    test=$(
    <<< "${html}" \
    grep -Po '(?<=<a)(.*?)(?=<\/a>)' \
    )

    # (?<=<a(?:.*)>)(.*?)(?=<\/a>)
    # (?<=<a(?:\K[A-Z][0-9])>)(.*?)(?=<\/a>)


    test_two=$(
    <<< "${html}" \
    grep -Pol "(?<=[href=\"'])(.*?)(?=[\"'])" \
    )
    echo "${test}"
}

link_scraper
