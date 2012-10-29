URD_NUM=$1
URD_PREFIX=$2

if [ -z $URD_NUM ]; then

    echo -e "\e[30;47m 用法: /PATH/TO/FILE/randomu.sh 生成数量 [前缀] \e[m"

else

    echo -e "\e[30;47m 在生成4位随机数.... \e[m"
    for((i = 1; i <= $URD_NUM*3; i = i + 1))
    do
        echo $[($RANDOM % 9000) + 1000] >> URD_short_numbs.txt
    done

    echo -e "\e[30;47m 把三个4位随机数合并成12位.... \e[m"
    xargs -n3 < URD_short_numbs.txt |sed 's/ //g' |sed 's/^/'$URD_PREFIX'/g' >> URD_long_numbs.txt
    rm URD_short_numbs.txt

    echo -e "\e[30;47m 删除重复行.... \e[m"
    sort URD_long_numbs.txt |uniq > unique_random_numbers.txt
    rm URD_long_numbs.txt

    echo -e "\e[31;47m 注意：这个脚本生成的随机数的数目小于等于输入的希望生成数目，请自行验证 \e[m"

fi
