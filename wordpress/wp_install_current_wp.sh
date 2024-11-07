#!/bin/bash
wget https://wordpress.org/latest.zip
unzip latest.zip
mv ./wordpress/wp-content/plugins ./wp-content/
rm -rf ./wordpress/wp-content
chown -R anon:anon ../
mv -f ./wordpress/* ./
rm -rf ./wordpress