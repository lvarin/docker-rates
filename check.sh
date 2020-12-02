#!/bin/sh

AUTH_URL='https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull'
RATES_URL='https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest'

UNAME=$1
PASS=$2

if [ -z "$PASS" ];
then
  echo >&2
  echo "Using anonymous access. To check a specific account:" >&2
  echo "Use: $0 <USERNAME> <PASSWORD>" >&2
  echo >&2
else
  export ACCESS="--user $UNAME:$PASS"
fi

TOKEN=$(curl -s "$AUTH_URL" $ACCESS | jq -r .token)
curl -s --head -H "Authorization: Bearer $TOKEN" $RATES_URL 2>&1 \
 | sed -n 's#^RateLimit-Remaining: \(.*\);w=\([0-9]*\)#{\"Pulls\":\"\1\",\"Seconds\":\"\2\"}#p'

