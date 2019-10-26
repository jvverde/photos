#!/usr/bin/env bash
SDIR=$(readlink -e "$(dirname $0)")

find . -mindepth 2 -type f -links 1
