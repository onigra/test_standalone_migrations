#!/bin/bash

# アプリのルートパス設定
script_path=`echo $(cd $(dirname $0);pwd)`
cd ${script_path} && cd ..
app_path=`pwd`

new_schema_name=$1
date=`date '+%Y%m%d'`

# 引数チェック
if [ "$new_schema_name" == "" ]; then
  echo "usage $0 schema_name"
  exit -1
fi

# ディレクトリの存在チェック
if [ -e ${app_path}/databases/${new_schema_name} ]; then
  echo "ディレクトリ ${new_schema_name} は既に存在します"
  exit -1
fi

# 新しいスキーマのディレクトリを作成し、
# テンプレートから必要なファイルをもってくる
cd ${app_path}/databases

mkdir ${new_schema_name}
cd ${new_schema_name}
cp ${app_path}/template/Gemfile ./
cp ${app_path}/template/.gemrc ./
cp ${app_path}/template/Rakefile ./

mkdir db
cp -r ${app_path}/template/db/config.yml ./db/

# bundle install
if [ -e ${app_path}/databases/${new_schema_name} ]; then
  bundle install --path vendor/bundle
else
  echo "新ディレクトリ ${new_schema_name} が存在しません。処理を中断します。"
  exit -1
fi

# .gitignoreに記述追加
cd ${app_path}
echo "# ${date} ${new_schema_name}" >> .gitignore
echo "/databases/${new_schema_name}/.bundle" >> .gitignore
echo "/databases/${new_schema_name}/vendor/bundle" >> .gitignore
echo "" >> .gitignore

