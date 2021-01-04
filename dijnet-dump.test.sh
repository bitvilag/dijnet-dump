#!/usr/bin/env bash
# dijnet.hu invoice downloader tester [https://github.com/wolandmaster/dijnet-dump]
# Copyright (c) 2016-2021 Sandor Balazsi and others
# This software may be distributed under the terms of the Apache 2.0 license

set -e; cd "$(dirname "$(readlink -f "$0")")"
trap '[[ $? == 0 ]] && echo "Overall result: SUCCESS" || echo "Overall result: FAILED"' EXIT

banner() {
  TITLE="# $@ #"; EDGE=$(sed 's/./#/g' <<<"${TITLE}")
  echo -e "\n${EDGE}\n${TITLE}\n${EDGE}\n"
}

TARGETS="$@"; [[ -z "${TARGETS}" ]] && TARGETS="tests/*"
for TARGET in $(ls -d ${TARGETS} 2>/dev/null); do
  banner "${TARGET:6}"
  docker build --file ${TARGET}/Dockerfile --tag dijnet-dump:${TARGET:6} .
  docker run --tty --interactive dijnet-dump:${TARGET:6} \
    bash -c "./dijnet-dump.sh && find"
done
