#!/bin/sh
# Author lian
# lianxiaoyang.happy@163.com

HOME="/home/lian"
conf="./conf"
src_dir="./files"
#copy="cp -rpv"
#copy="rsync -avzPSH"
copy="rsync -avPSH --delete"
#copy="echo"

# now restore
sed -n -e "/^#/!p" "${conf}" | awk -F/ '{
dir_name=$1
for(i=2; i<NF; i++)
{
    dir_name=dir_name"/"$i
}
print dir_name":"$NF
}' |
while read file
do
    #dir_name=`dirname $file`
    #dir_name=`echo "$file" | awk -F/ 'BEGIN{dir_name=$1}{for(i=1; i<NF; i++){print i,$i}}END{print dir_name}'`
    dir_name=$(eval echo `echo "${file}" | awk -F: '{print $1}'`)
    file_name=`echo "${file}" | awk -F: '{print $2}'`
    #echo $dir_name
    eval echo ${src_dir}/${file_name} |
    awk '{
    for(i=1; i<=NF; i++)
    {
        cmd="echo "$i" | xargs -i basename {}";
        cmd | getline var;
        print var;
    }
    }' |
    xargs -i echo "${copy} ${src_dir}/{} ${dir_name}" |
    sh
done

echo "Total restored size: `du -sh ${src_dir}`"
