#
# (C) 2013 Unitech.io Inc.
#

# export PM2_RPC_PORT=4242
# export PM2_PUB_PORT=4243

node="`type -P node`"

pm2_path=`pwd`/bin/pm2

if [ ! -f $pm2_path ];
then
    pm2_path=`pwd`/../bin/pm2
    if [ ! -f $pm2_path ];
    then
        pm2_path=`pwd`/../../bin/pm2
    fi
fi

pm2="$node $pm2_path"

SRC=$(cd $(dirname "$0"); pwd)
file_path="${SRC}/../fixtures"

if [ ! -d $file_path ];
then
    file_path="${SRC}/../../fixtures"
    if [ ! -d $file_path ];
    then
        file_path="${SRC}/../../../fixtures"
    fi
fi

$pm2 link delete
$pm2 kill

function fail {
  echo -e "######## \033[31m  ✘ $1\033[0m"
  exit 1
}

function success {
  echo -e "\033[32m------------> ✔ $1\033[0m"
}

function spec {
  RET=$?
  sleep 0.1
  [ $RET -eq 0 ] || fail "$1"
  success "$1"
}

function ispec {
  RET=$?
  sleep 0.2
  [ $RET -ne 0 ] || fail "$1"
  success "$1"
}

function should {
    sleep 0.3
    $pm2 prettylist > /tmp/tmp_out.txt
    OUT=`cat /tmp/tmp_out.txt | grep -v "npm" | grep -o "$2" | wc -l`
    [ $OUT -eq $3 ] || fail "$1"
    success "$1"
}

function shouldnot {
    sleep 0.3
    $pm2 prettylist > /tmp/tmp_out.txt
    OUT=`cat /tmp/tmp_out.txt | grep -v "npm" | grep -o "$2" | wc -l`
    [ $OUT -ne $3 ] || fail "$1"
    success "$1"
}

function exists {
    sleep 0.3
    $pm2 prettylist > /tmp/tmp_out.txt
    OUT=`cat /tmp/tmp_out.txt | grep -v "npm" | grep -o "$2" | wc -l`
    [ $OUT -ge 1 ] || fail "$1"
    success "$1"
}
