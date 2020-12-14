#!/bin/sh

cat <<-EOF > /root/cloudreve/conf.ini
[System]
; 运行模式
Mode = master
; 监听端口
Listen = :${PORT}
; 是否开启 Debug
Debug = false
; Session 密钥, 一般在首次启动时自动生成
SessionSecret = 23333
; Hash 加盐, 一般在首次启动时自动生成
HashIDSalt = something really hard to guss

[Redis]
Server = ${REDIS_URL##*@}
Password = ${REDIS_URL:9:65}
DB = 0

[Database]
; 数据库类型，目前支持 sqlite | mysql
Type = mysql
; 数据库地址
Host = ${JAWSDB_URL:42:57}
; MySQL 端口
Port = 3306
; 用户名
User = ${JAWSDB_URL:8:16}
; 密码
Password = ${JAWSDB_URL:25:16}
; 数据库名称
Name = ${JAWSDB_URL##*/}
; 数据表前缀
TablePrefix = V3
EOF

trackerlist=`wget -qO- https://trackerslist.com/all.txt |awk NF|sed ":a;N;s/\n/,/g;ta"`
sed -i '$a bt-tracker='${trackerlist} /root/aria2/aria2.conf
nohup aria2c --conf-path=/root/aria2/aria2.conf  &

/root/cloudreve/cloudreve -c /root/cloudreve/conf.ini