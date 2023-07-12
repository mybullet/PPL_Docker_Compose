#!/bin/bash

default_pswd="qwer1234@@"
max_attempts=3


for arg in "$@"; do
    if [[ $arg == from=* ]]; then
        from="${arg#*=}"
    elif [[ $arg == pswd=* ]]; then
        pswd="${arg#*=}"
    elif [[ $arg == op=* ]]; then
        op="${arg#*=}"
    fi
done


attempt=1
while [[ $attempt -le $max_attempts ]]; do
    if [[ -z $pswd ]]; then
        pswd="$default_pswd"
    fi

    echo "Waiting..."
    if ! echo "$pswd" | sudo -kSv >/dev/null 2>&1; then
        echo "please enter your password"
        pswd=""
        attempt=$((attempt + 1))
        if [[ $attempt -gt $max_attempts ]]; then
            echo "fail to verify your sudo right"
            exit 1
        fi
    else
        break
    fi
done

if [[ $op == "up" ]]; then
    if [[ $from == "local" ]]; then
        sudo docker-compose -f docker-compose-local.yml up --build
    elif [[ $from == "remote" ]]; then
        sudo docker-compose -f docker-compose-remote.yml up
    else
        echo "FROM parameter is invalid"
        exit 1
    fi
elif [[ $op == "down" ]]; then
    if [[ $from == "local" ]]; then
        sudo docker-compose -f docker-compose-local.yml down
    elif [[ $from == "remote" ]]; then
        sudo docker-compose -f docker-compose-remote.yml down
    else
        echo "FROM parameter is invalid"
        exit 1
    fi
elif [[ $op == "stop" ]]; then
    if [[ $from == "local" ]]; then
        sudo docker-compose -f docker-compose-local.yml stop
    elif [[ $from == "remote" ]]; then
        sudo docker-compose -f docker-compose-remote.yml stop
    else
        echo "FROM parameter is invalid"
        exit 1
    fi
else
    echo "OP parameter is invalid"
    exit 1
fi

