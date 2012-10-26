echo "在生成4位随机数...."
for((i=1;i<=90300;i=i+1))
do
    echo $[($RANDOM % 9000) + 1000] >> URD_short_numbs.txt
done
echo "把三个4位随机数合并成12位...."
xargs -n3 < URD_short_numbs.txt >> URD_long_numbs.txt

echo "删除重复行...."
cat |uniq URD_long_numbs.txt > unique_random_numbers.txt
rm URD_short_numbs.txt URD_long_numbs.txt

echo 注意：：这个脚本生成的随机数的数目小于等于输入的希望生成数目 
echo 用以下三个步骤去除随机数中的空格以及插入prefix
echo '  1. vi d.txt'
echo '  2. :%s/ //g'
echo '  3. :%s/^/prefix/g'
