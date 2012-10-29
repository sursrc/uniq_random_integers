calc_t_len () {
    if [ $[${URD_LEN}%4] -ne 0 ]; then
        T_LEN=$[$URD_LEN / 4 + 1]
    else
        T_LEN=$[$URD_LEN / 4]
    fi
}

stat_busy () {                                                                              
  printf "\e[1;36m::\e[1;37m ${1}\e[m"
  printf "    [\e[1;33mBUSY\e[m]"
}

stat_fail () {
  printf "\r\e[1;36m::\e[1;37m ${1}\e[m"
  printf "    [\e[1;31mFAIL\e[m]\n"
}

stat_done () {
  printf "\r\e[1;36m::\e[1;37m ${1}\e[m"
  printf "    [\e[1;32mDONE\e[m]\n"
}

generate_numbs () {
    stat_busy "Generating short random numbers"
    for((i = 1; i <= $[(${URD_NUM} * ${T_LEN})]; i = i + 1))
    do
        echo $[(${RANDOM} % 9000) + 1000] >> .URD_short_numbs.txt
    done
    if [ -f .URD_short_numbs.txt ]; then
        stat_done "Generating short random numbers"
    else
        stat_fail "Generating short random numbers"
        exit
    fi

    stat_busy "Generating long random numbers"
    xargs -n${T_LEN} < .URD_short_numbs.txt |sed 's/ //g' |grep -Po "^(.){$URD_LEN}" |sed "s/^/${URD_PREFIX}/g" > .URD_long_numbs.txt
    rm .URD_short_numbs.txt
    if [ -f .URD_long_numbs.txt ]; then
        stat_done "Generating long random numbers"
    else
        stat_fail "Generating long random numbers"
        exit
    fi

    stat_busy "Removing duplicate rows"
    uniq .URD_long_numbs.txt  > unique_random_numbers.txt
    rm .URD_long_numbs.txt
    if [ -f unique_random_numbers.txt ]; then
        stat_done "Removing duplicate rows"
    else
        stat_fail "Removing duplicate rows"
        exit
    fi
}



if [ -z ${1} ] || [ -z ${2} ]; then
    echo Usage: ${PWD}/randomu.sh LENTH QUANTITY [PREFIX]
else
    URD_NUM=${1}
    URD_LEN=${2}
    URD_PREFIX=${3}

    calc_t_len

    stat_busy "Checking permission"
    if [ -w ./ ]; then
        stat_done "Checking permission"
    else
        stat_fail "Checking permission"
        exit
    fi

    generate_numbs

    echo -e "\e[1;31m  NOTICE\e[1;37m：这个脚本生成的随机数的数目小于等于输入的希望生成数目，请自行验证 \e[m"
fi
