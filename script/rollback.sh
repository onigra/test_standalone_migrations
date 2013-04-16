#!/bin/bash

# アプリのルートパス設定
script_path=`echo $(cd $(dirname $0);pwd)`
cd ${script_path} && cd ..
app_path=`pwd`

schema=$1
env=$2

# 引数チェック
if [ "$schema" == "" ]; then
  echo "usage $0 schema_name env"
  exit -1
elif [ "$env" == "" ]; then
  echo "usage $0 schema_name env"
  exit -1
fi

# ディレクトリの存在チェック
if [ -e ${app_path}/databases/${schema} ]; then
  :
else
  echo "ディレクトリ ${schema} は存在しません"
  exit -1
fi

# rollback
cd ${app_path}/databases/${schema}
read -s -p "Enter $1 Database Password: " password
echo

if [ "$password" == "" ]; then
  echo "パスワードを入力してください"
  exit -1
fi

bundle exec rake db:rollback DB=${env} DB_PASSWORD=${password}

