#!/bin/bash

num=$1
if [[ ! "$num" =~ ^[0-9]+$ ]]; then
    echo "[ERROR]: Input must be a valid number!"
    echo "[SOURCE]: $0 <number>"
    exit 1
else
    exit 0
fi