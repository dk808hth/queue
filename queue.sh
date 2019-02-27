#!/bin/bash

ZNLISTCMD_TMP=$(zelcash-cli listzelnodes 2>/dev/null)
ZNLISTCMD=$(jq -r --arg tier ${ZNTIER} '[.[] |select(.tier==$tier) |{(.txhash):(.status+" "+(.version|tostring)+" "+.addr+" "+(.lastseen|tostring)+" "+(.activetime|tostring)+" "+(.lastpaid|tostring)+" "+.ipaddress)}]|add' <<< $ZNLISTCMD_TMP)
echo "$ZNLISTCMD"
