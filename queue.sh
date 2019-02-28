#!/bin/bash

ZNLISTCMD_TMP=$(zelcash-cli listzelnodes 2>/dev/null)
ZNLISTCMD=$(jq -r --arg tier "${ZNTIER}" '[.[] |select(.tier==$tier) |{(.txhash):(.status+" "+(.version|tostring)+" "+.addr+" "+(.lastseen|tostring)+" "+(.activetime|tostring)+" "+(.lastpaid|tostring)+" "+.ipaddress)}]|add' <<< "$ZNLISTCMD_TMP")
ZNLISTPAGE="$(printf %s\\n "$ZNLISTCMD" | wc -l)"

ZNTIER=$1
ZNADDR=$2

echo '                                               '
echo -e '\033[1;34m                       #                   \033[0m   ' 
echo -e '\033[1;34m                     #####                     \033[0m   ' 
echo -e '\033[1;34m                   #########                   \033[0m   ' 
echo '        __  ___            __   __   ___       '
echo '         / |__  |    |\ | /  \ |  \ |__        '
echo '        /_ |___ |___ | \| \__/ |__/ |___       '
echo ''
echo -e '\033[1;34m         #   #####################   #         \033[0m   ' 
echo -e '\033[1;34m       #####   #################   #####       \033[0m   ' 
echo -e '\033[1;34m     #########   #############   #########     \033[0m   ' 
echo -e '\033[1;34m   #############   #########   #############   \033[0m   ' 
echo -e '\033[1;34m #################  #######  ################# \033[0m   ' 
echo -e '\033[1;34m #################  #######  ################# \033[0m   ' 
echo -e '\033[1;34m #################  #######  ################# \033[0m   ' 
echo -e '\033[1;34m #################   #####   ################# \033[0m   ' 
echo -e '\033[1;34m #################     #     ################# \033[0m   ' 
echo -e '\033[1;34m   #############               #############   \033[0m   ' 
echo -e '\033[1;34m     #########                   #########     \033[0m   ' 
echo -e '\033[1;34m       #####         V0.1          #####       \033[0m   ' 
echo -e '\033[1;34m         #                           #         \033[0m   ' 
echo '            __        ___       ___                                    '
echo '           /  \ |  | |__  |  | |__                                     '
echo '           \__X \__/ |___ \__/ |___                                    '

if [ -z "$ZNTIER" ]; then
    echo ""
    echo "usage   : $0 <tier> <zelnode address>"
    echo ""
    echo "example : $0 -BASIC t1cUKkWws83twyvAbj6fWEAfsvp14JDjr87"
    echo "example : $0 -SUPER t1U4mLtUuiSwfVFS8rHCY1nANXD5fweP911"
    echo "example : $0 -BAMF t1MK2mtU8Wuoq22Z2FsMUMN41DsrGcFxcCo"
    echo ""
    exit 1
fi


if [ -z "$ZNADDR" ]; then
    echo ""
    echo "usage   : $0 <tier> <zelnode address>"
    echo ""
    echo "example : $0 -BASIC t1cUKkWws83twyvAbj6fWEAfsvp14JDjr87"
    echo "example : $0 -SUPER t1U4mLtUuiSwfVFS8rHCY1nANXD5fweP911"
    echo "example : $0 -BAMF t1MK2mtU8Wuoq22Z2FsMUMN41DsrGcFxcCo"
    echo ""
    exit 1
fi


if [ "$ZNTIER" == -BASIC ] ; then
    ZNTIER=BASIC
fi

if [ "$ZNTIER" == -SUPER ] ; then
    ZNTIER=SUPER
fi

if [ "$ZNTIER" == -BAMF ] ; then
    ZNTIER=BAMF
fi

function _cache_command(){

    # cache life in minutes
    AGE=2

    FILE=$1
    AGE=$2
    CMD=$3

    OLD=0
    CONTENTS=""
    if [ -e "$FILE" ]; then
        OLD=$(find "$FILE" -mmin +"$AGE" -ls | wc -l)
        CONTENTS=$(cat "$FILE");
    fi
    if [ -z "$CONTENTS" ] || [ "$OLD" -gt 0 ]; then
        echo "REBUILD"
        CONTENTS=$(eval "$CMD")
        echo "$CONTENTS" > "$FILE"
    fi
    echo "$CONTENTS"
}



ZN_LIST=$(_cache_command /tmp/cached_znlistfull 2 "$ZNLISTPAGE")
SORTED_ZN_LIST=$(echo "$ZNLISTPAGE" | sed -e 's/[}|{]//' -e 's/"//g' -e 's/,//g' | grep -v ^$ | \
awk ' \
{
    if ($7 == 0) {
        TIME = $6
        print $_ " " TIME
    }
    else {
        xxx = ("'"$NOW"'" - $7)
        if ( xxx >= $6) {
            TIME = $6
        }
        else {
            TIME = xxx
        }
        print $_ " " TIME
    }
}' |  sort -k10 -n)

ZN_VISIBLE=$(echo "$SORTED_ZN_LIST" | grep -c "$ZNADDR")
ZN_QUEUE_LENGTH=$(echo "$SORTED_ZN_LIST" | wc -l)
ZN_QUEUE_POSITION=$(echo "$SORTED_ZN_LIST" | grep -c -A9999999 "$ZNADDR")
ZN_QUEUE_IN_SELECTION=$(( $ZN_QUEUE_POSITION <= $(( $ZN_QUEUE_LENGTH / 10 )) ))

echo ""
echo "Zelnode :" "$ZNADDR"
if [ "$ZN_VISIBLE" -gt 0 ]; then
    echo "Tier    : $ZNTIER"
        echo "         -> queue position $ZN_QUEUE_POSITION/$ZN_QUEUE_LENGTH"
        echo ""
    if [ $ZN_QUEUE_IN_SELECTION -gt 0 ]; then
        echo " -> SELECTION PENDING"
    fi
else
    echo "is not in Zelnode list"
fi
    echo "example : $0 -BAMF t1MK2mtU8Wuoq22Z2FsMUMN41DsrGcFxcCo"
    echo ""
    exit 1
fi
