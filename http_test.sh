#!/bin/bash
HTTP_SERVER=http://nginx-tweak.example.com:8000/data
URL_FILE=/tmp/url_file
rm -rf $URL_FILE

function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(($RANDOM+1000000000))
    echo $(($num%$max+$min))
}


function create_url_file(){
for ((i = 0; i <= $1; i++)); do
    rnd=$(rand 1 6000)
    dir=$((rnd%100))
    echo "$HTTP_SERVER"/$dir/$rnd >> $URL_FILE
done
}

function help(){
    echo "$1 : To create url file,and test http server"
    echo "options: -r Test http server only once"
    echo "         -t <value> Test http server for N seconds"
    echo "         -c <value> Set the client number "
    echo "         -n <value> Set the url demo number "
    echo "         -a <value> Set the range size,default 32KB "
}

TEST_ONCE=0
TEST_TIME_ENABLE=1
TEST_RANGE_SIZE=32
TEST_URL_NUMBER=1500
TEST_USER_NUMBER=300
TEST_TIME=60
while getopts ":rt:c:n:a:" optname
do
    case "$optname" in
    "r")
        TEST_ONCE=1
        TEST_TIME_ENABLE=0
        ;;
    "t")
        TEST_TIME_ENABLE=1
        TEST_ONCE=0
        TEST_TIME=$OPTARG
        ;;
    "c")
        TEST_USER_NUMBER=$OPTARG
        ;;
    "n")
        TEST_URL_NUMBER=$OPTARG
        ;;
    "a")
        TEST_RANGE_SIZE=$OPTARG
        ;;
    *)
        # Should not occur
        help $0
        exit 0
        ;;
    ?)
        help $0
        exit 0
        ;;
    esac
done

echo "creating url file ... "
create_url_file $TEST_URL_NUMBER
echo "create url file over"

if [ "$TEST_ONCE" == "1" ];then 
    echo "siege -r 1 -c $TEST_USER_NUMBER -a $TEST_RANGE_SIZE -i -f $URL_FILE"
    siege -r 1 -c $TEST_USER_NUMBER -a $TEST_RANGE_SIZE -i -f $URL_FILE
    exit 0
fi

if [ "$TEST_TIME_ENABLE" == "1" ];then 
    echo "siege -t $TEST_TIME -c $TEST_USER_NUMBER -a $TEST_RANGE_SIZE -i -f $URL_FILE"
    siege -t $TEST_TIME -c $TEST_USER_NUMBER -a $TEST_RANGE_SIZE -i -f $URL_FILE
    exit 0
fi

help
exit 1
