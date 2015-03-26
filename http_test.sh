#!/bin/bash
HTTP_SERVER=http://nginx-tweak.example.com:8000/data
HTTP_SERVER_HD=http://nginx-tweak.example.com:8000/data1
URL_FILE=/tmp/url_file
rm -rf $URL_FILE

function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(($RANDOM+1000000000))
    echo $(($num%$max+$min))
}


function create_url_file(){
echo $2 $1
SSD_NUM=$((($2*$1)/100))
echo "SSD NUMBER IS " $SSD_NUM
for ((i = 0; i <= $1; i++)); do
    rnd=$(rand 1 6000)
    dir=$((rnd%100))
    if [ $i -ge $SSD_NUM ];then
    echo "$HTTP_SERVER_HD"/$dir/$rnd >> $URL_FILE
    else
    echo "$HTTP_SERVER"/$dir/$rnd >> $URL_FILE
    fi
done
}

function help(){
    echo "$1 : To create url file,and test http server"
    echo "options: -r Test http server only once"
    echo "         -t <value> Test http server for N seconds"
    echo "         -c <value> Set the client number "
    echo "         -n <value> Set the url demo number "
    echo "         -a <value> Set the range size,default 32KB "
    echo "         -p <0-100> Set the SSD source percent in server url,default 100"
}

TEST_ONCE=0
TEST_TIME_ENABLE=1
TEST_RANGE_SIZE=32
TEST_URL_NUMBER=1500
TEST_USER_NUMBER=300
TEST_TIME=60S
SSD_PERCENT=100
while getopts ":rt:c:n:a:p:" optname
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
    "p")
        SSD_PERCENT=$OPTARG
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
create_url_file $TEST_URL_NUMBER  $SSD_PERCENT
echo "create url file over"

if [ "$TEST_ONCE" == "1" ];then 
    echo "siege -r 1 -c $TEST_USER_NUMBER -a $TEST_RANGE_SIZE -i -f $URL_FILE"
    siege -r 10 -c $TEST_USER_NUMBER -a $TEST_RANGE_SIZE -i -f $URL_FILE
    exit 0
fi

if [ "$TEST_TIME_ENABLE" == "1" ];then 
    echo "siege -t $TEST_TIME -c $TEST_USER_NUMBER -a $TEST_RANGE_SIZE -i -f $URL_FILE"
    siege -t $TEST_TIME -c $TEST_USER_NUMBER -a $TEST_RANGE_SIZE -i -f $URL_FILE
    exit 0
fi

help
exit 1
