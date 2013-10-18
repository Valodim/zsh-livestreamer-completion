#!/bin/zsh

# a client id of mine
clientid=1kje8zxca01bweo1cc4lt4ln0c5saxi

cat << EOF
    This is a simple script which can be used to locally retrieve a twitch api
    oauth token. It will first start a python SimpleHTTPServer (standard
    module), then open a twitch oauth page in a browser window. You will need
    to log in there and confirm the OAuth access. After that, you will be
    redirected to a local page which simply shows the zstyle you need to put in
    your .zshrc to make completion work.

    usage: $0 [browser]

EOF

if [[ -n $1 ]]; then
    browser=$1
elif (( $+commands[sensible-browser] )); then
    browser=sensible-browser
else
    echo 'error: no browser specified, and sensible-browser command not available.' >&2
    exit 1
fi

if ! read -q '?Continue [y/N] '; then
    exit
fi

echo
echo 'Starting SimpleHTTPServer on localhost:3456 for callback...'
python -m SimpleHTTPServer 3456 &
httpid=$?

echo 'Opening OAuth request using sensible-browser...'
$browser "https://api.twitch.tv/kraken/oauth2/authorize?response_type=token&client_id=$clientid&redirect_uri=http://localhost:3456/auth.htm&scope=user_read"

echo 'Hit enter to kill SimpleHTTPServer'
read
kill $httpid
