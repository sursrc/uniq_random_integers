isnumber() {
  CHECK=`echo ${1} | sed "s/\(^[-|+|0-9|.][.0-9]*$\)//"`
  if [ -z ${CHECK} ] ; then
    return 0
  else
    return 1
  fi
}

calc_t_len () {
    if [ $[${URD_LEN} % 4] -ne 0 ]; then
        T_LEN=$[${URD_LEN} / 4 + 1]
    else
        T_LEN=$[${URD_LEN} / 4]
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

error_message() {
    printf "\e[1;31m${1}\e[m\n"
}

generate_numbs () {
    stat_busy "Generating short random numbers"
    for((i = 1; i <= $[(${URD_NUM} * ${T_LEN})]; i = i + 1))
    do
        echo $[(${RANDOM} % 9000) + 1000] >> .URD_short_numbs
    done
    if [ -f .URD_short_numbs ]; then
        stat_done "Generating short random numbers"
    else
        stat_fail "Generating short random numbers"
        exit
    fi

    stat_busy "Generating random numbers"
    xargs -n${T_LEN} < .URD_short_numbs |sed 's/ //g' |grep -Po "^(.){${URD_LEN}}" |sed "s/^/${URD_PREFIX}/g" > uniq_rand_numbs.txt
    rm .URD_short_numbs
    if [ -f uniq_rand_numbs.txt ]; then
        stat_done "Generating random numbers"
    else
        stat_fail "Generating random numbers"
        exit
    fi

    stat_busy "Checking duplicate rows"
    if [ $(sort uniq_rand_numbs.txt|uniq -d|sed -n 1p) ]; then
        stat_fail "Checking duplicate rows"
        error_message "repeated keys:"
        echo $(sort uniq_rand_numbs.txt|uniq -d)
        rm uniq_rand_numbs.txt
    else
        stat_done "Checking duplicate rows"
    fi
}



#START HERE
if [ -z ${1} ] || [ -z ${2} ]; then
    echo Usage: ${PWD}/randomu.sh QUANTITY LENTH [PREFIX]
else
    URD_NUM=${1}
    URD_LEN=${2}
    URD_PREFIX=${3}

    stat_busy "Checking variable type"
    isnumber "${URD_NUM}"
    if [ $? -ne 0 ] &>/dev/null; then
        stat_fail "Checking variable type"
        error_message "QUANTITY should be number"
        exit
    fi
    isnumber "${URD_LEN}"
    if [ $? -ne 0 ] &>/dev/null; then
        stat_fail "Checking variable type"
        error_message "LENTH should be number"
        exit
    fi
    stat_done "Checking variable type"

    calc_t_len

    stat_busy "Checking permission"
    if [ -w ./ ]; then
        stat_done "Checking permission"
    else
        stat_fail "Checking permission"
        exit
    fi

    generate_numbs
fi
