#!/bin/bash

# アプリのルートパス設定
script_path=`echo $(cd $(dirname $0);pwd)`
cd ${script_path} && cd ..
app_path=`pwd`

schema=$1
file_name=$2

# 引数チェック
if [ "$schema" == "" ]; then
  echo "usage $0 schema_name file_name"
  exit -1
elif [ "$file_name" == "" ]; then
  echo "usage $0 schema_name file_name"
  exit -1
fi

# ディレクトリの存在チェック
if [ -e ${app_path}/databases/${schema} ]; then
  : 
else
  echo "ディレクトリ ${schema} は存在しません"
  exit -1
fi

# new_migration
cd ${app_path}/databases/${schema}
bundle exec rake db:new_migration name=${file_name}

