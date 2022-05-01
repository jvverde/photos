#!/usr/bin/env bash
#Find files wit same content and desduplicate them by creating a hardlink

exiftool -TagsFromFile "$1" "-all:all>all:all" "$2"
