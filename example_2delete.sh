#!/usr/bin/env bash
#Find files wit same content and desduplicate them by creating a hardlink

#Example: find /media/jvv/BRASIL1 ! -path '*/.2delete/*' -type f -links 1 -name '*.NEF' -printf "%H/./%P\0" | xargs -r0I{} rsync -aiAHR --remove-source-files "{}" /media/jvv/BRASIL1/.2delete/