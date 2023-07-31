#!/bin/bash
echo $1
dir=$(pwd)

if  [[ $2 == "--old" ]] 
then
    rsync -a --delete $dir/.git-version-save/* $dir
    echo "OAT.Script: Версия восстановлена"
    exit 0
    fi
    
if [[ ! -d "$dir/.git-download" ]]
then
    mkdir -p $dir/.git-download
    git clone https://$1@github.com/TaigoDev/OAT.git $dir/.git-download
    rsync -a --delete $dir/.git-download/OAT/bin/Debug/net6.0/* $dir
    echo "OAT.Script: Первичная настройка выполнена. Можно запускать"
else 
    echo "OAT.Script: Установка обновления..."
    echo "OAT.Script: Сохраняю старую копию..."
    rm -rf $dir/.git-version-save
    mkdir -p $dir/.git-version-save
    rsync -av $dir/* $dir/.git-version-save --exclude .git-download --exclude .git-version-save
    git -C $dir/.git-download pull
    rsync -a --delete $dir/.git-download/OAT/bin/Debug/net6.0/* $dir
    #Восстановливаем папки
    echo "OAT.Script: Восстановление папок..."
    rsync -a --delete $dir/.git-version-save/wwwroot/images/news/* $dir/wwwroot/images/news
    rsync -a --delete $dir/.git-version-save/news/* $dir/news
    rsync -a --delete $dir/.git-version-save/schedule/* $dir/schedule
    echo "OAT.Script: Обновление загружено"
    fi
    
