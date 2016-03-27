#!/bin/bash
# Author lian
# lianxiaoyang.happy@163.com

HOME="/home/lian"
conf="./conf"
dest_dir="./files"
#copy="cp -rpv"
#copy="rsync -avzPSH"
copy="rsync -avPSH --delete"
#copy="echo"

# calculate the total size
size=$(
sed -n -e "/^#/!p" "${conf}" |
while read file
do
    du -sb `eval echo "${file}"`
done | awk 'BEGIN{sum=0} {sum+=$1} END{print sum}'
)

# more accurate
echo "Total size: `echo "scale=4; ${size}/1024/1024" | bc` MB"

# now copy
if [ ! -d "${dest_dir}" ]
then
    mkdir "${dest_dir}"
fi

:<<\EOF
if [ -d $dest_dir ]
then
    sudo rm -fr $dest_dir
    mkdir $dest_dir
else
    mkdir $dest_dir
fi
EOF

sed -n -e "/^#/!p" "${conf}" |
while read file
do
    eval echo "${file}"
# if some files need admin privileges
#done | awk '{for(i=1; i<=NF; i++) print $i}' | xargs -i sudo $copy {} $dest_dir
done | awk '{for(i=1; i<=NF; i++) print $i}' | xargs -i ${copy} {} ${dest_dir}

echo `du -sh | awk '{print "Total copied size: " $1}'`
