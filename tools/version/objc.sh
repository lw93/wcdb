#!/bin/bash

root=`git rev-parse --show-toplevel`
version=`defaults read ${root}/objc/support/Info.plist CFBundleShortVersionString`
commitHash=`git rev-parse HEAD`
buildTimestamp=`date +%s`
buildTime=`date -r ${buildTimestamp} +"%Y-%m-%d %H:%M:%S UTC%z"`
script=`git rev-parse --show-prefix`$0

source=${root}/tools/version/Version.h
target=${root}/objc/source/utility/Version.h

sed -e "s/WCDB_VERSION_PLACEHOLDER/${version}/g" \
    -e "s/WCDB_COMMIT_HASH_PLACEHOLDER/${commitHash}/g" \
    -e "s/WCDB_BUILD_TIMESTAMP_PLACEHOLDER/${buildTimestamp}/g" \
    -e "s/WCDB_BUILD_TIME_PLACEHOLDER/${buildTime}/g" \
    -e "s/WCDB_VERSION_TOOL_PLACEHOLDER/${script////\\/}/g" \
    ${source} > ${target}
