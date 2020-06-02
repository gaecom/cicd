#!/bin/bash  
[ -f $HOME/myconfig ] && . $HOME/myconfig
declare -A usage


_info () {
    echo -e "\e[32m$@\e[39m"
}
_warn () {
    echo -e "\e[93m$@\e[39m"
}
_err () {
    echo -e "\e[31m$@\e[39m"
}

#script begin

#description: 
usage[i]="1db init ci/cd 参数1表示使用pg或者mysql，不传使用H2"
usage[s]="start ci/cd"
usage[fs]="force-recreate ci/cd"
usage[ss]="stop-remove-start ci/cd"
usage[st]="stop ci/cd"
usage[rm]="remove ci/cd"
usage[r]="restart ci/cd"
usage[l]="logs ci/cd"
usage[lf]="logs following ci/cd"

i(){
   #sed  -e "s/#gl_host/g.cc/" -e "s/#gl_http_port/$gl_http_port/" -e "s/#gl_https_port/$gl_https_port/" -e "s/#gl_host/g.cc/" -e "s/#gl_host/g.cc/" -e "s/#gl_host/g.cc/"  docker-compose.temp.yml > docker-compose.yml
   
   2>&1 mkdir -p {postgres,mysql,postgres,sonarqube,sonarqube8}/{data,conf,logs,extensions} >/dev/null

   cp -Rf env.temp env
   python -Bc "import ifuncs as i;import sys;i.replace(sys.argv[1])" ${1:-""}

}


sonarqube(){
    docker run --name sq -v $PWD/sonarqube/extensions:/opt/sonarqube/extensions -p 9010:9000 sonarqube
}
dist(){
    local proj=$(basename $PWD)
    rm2 -Rf dist
     [ ! -d dist ] && mkdir dist
    mkdir dist/$proj/jenkins/data/updates
    #rsync -av sonarqube/extensions dist/$proj/sonarqube
    rsync -av --exclude-from=./exclude_files . dist/$proj
    rsync -av backup/*  dist/$proj

}
r(){
    docker-compose restart
}
ps(){
   docker-compose ps
}
s(){
   docker-compose up -d
   docker-compose logs
}
fs(){
    docker-compose up -d --force-recreate
    docker-compose logs
}
rm2(){
    docker-compose stop
    docker-compose rm
}
ss(){
    docker-compose stop
    docker-compose rm
    s
}
df(){
    /bin/rm -Rf dist
    dist
    cd dist/$(basename $PWD)
    ftp

}
ftp(){
  local dir=${1:-$PWD}
  local dirName=$(basename $dir)

  echo 1|xargs -t ncftpput -U 0 -R -v -u $ML_FTP_USER  -P 33256 -p "${ML_FTP_PWD}" ectest.miaozhen.com $dirName $dir/*


  #(cd $dir;ls .|xargs -t -P4 -I {} curl  -u "${ML_FTP_USER}:${ML_FTP_PWD}"  -T {}  "ftp://ectest.miaozhen.com:33256/${dirName}/" -P 33256 --ftp-create-dirs -v)
}
usage(){
    cat - <<EOF
#初始化配置 /var/jenkins_home/updates/default.json
cd /var/jenkins_home/updates
# 替换谷歌地址
sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' default.json
# 修改镜像地址
sed -i 's/http:\/\/updates.jenkins-ci.org\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' default.json
# 管理插件->高级
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
# 重启
#离线插件安装下载
http://updates.jenkins-ci.org/download/plugins/
EOF

    /Users/i/htdocs/j/uwb_hub
}
lf(){
      docker-compose logs -f "$@"
}
l(){
     docker-compose logs "$@"
}
pa(){
    docker-compose stop
}


func=$1
isHelp=$2
MY_DIR=$HOME/my
usage["_r"]="show in finder"
usage["_c"]="open in vs code"
_r(){
    open $MY_DIR/script
}
_c(){
    local editor="vim"
    [ ! -z "$(which subl)" ] && editor="subl"
    [ ! -z "$(which code)" ] && editor="code"
    $editor $MY_DIR/script
}
    if [ "$func" = "-" -o -z "$func" ];then
echo -e "$(_info usage):\n例如: r - 显示帮助信息\n"
for key in "${!usage[@]}";do
    echo -e "$(_info $key): \n\t${usage[$key]}"
done

else


if [ "$(type -t $func)" = "function" ];then 

    shift 
    if [ "$isHelp" = "-"  ];then 
        #usage="${func}_usage"
        #echo -e "$func usage:\n ${!usage}"
        echo -e "$(_info usage:\\n$func)\n  ${usage[$func]}"
        echo "option help"
    else
       $func "$@"
    fi

fi

fi




