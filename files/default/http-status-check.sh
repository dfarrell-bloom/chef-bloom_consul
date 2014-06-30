#!/bin/bash

# m: max timeout    (5s)
max_timeout=5
# s: success status (200)
success_status=200
# p: port           (80)
port="" # unspecified
# h: host           (localhost)
host="localhost"
# l: location ie URL path (/)
location="/"
# S: Scheme ( http / https / something else CURL can do? )
scheme="http"

function get_int {
    if [ $# -ne 1 ]; then
        echo "error: function get_int takes exactly one argument" 1>&2  
        unset int
        return -1 
    fi
    int=`echo "0 + $1" | bc`
    return 0
}

while getopts ":m:s:p:h:l:S:" opt; do 
    case $opt in
    m) get_int $OPTARG
        max_timeout=$int
        ;;
    s) get_int $OPTARG
        success_status=$int
        ;;
    p) get_int $OPTARG
        port=":$int"
        ;;
    h) host=$OPTARG
        ;;
    l) location=$OPTARG
        ;;
    S) scheme=$OPTARG
        ;;
    *)
        echo "Error parsing command line option $opt" 1>&2
        exit 255
    esac
done

output="/tmp/$$-`date +%s`"
uri="$scheme://${host}${port}${location}"
curlcommand="curl -L -o $output -m $max_timeout -w '%{http_code}' '$uri'"
echo "$curlcommand" 1>&2
status=`bash -c "$curlcommand"`
if [ $? -ne 0 ]; then
    echo "Error executing curl.  Status: '$status'" 1>&2
    test -f "$output" && rm $output
    exit 254
else
    echo "Status: $status" 1>&2
fi
if [ -f "$output" ]; then
    cat $output
    rm $output
fi
if [ $status == "$success_status" ]; then 
    exit 0
else
    exit 2 # Consul considers 1 a warning, so we'll exit something else on failure.
fi
