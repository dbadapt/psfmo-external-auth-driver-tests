#!/bin/bash

# This script checks external authentication 
# with the MongoDB C Driver

basedir=$(cd $(dirname "$0");pwd)

pass_suffix='9a5S'

truncate -s0 ${basedir}/external-auth.log

echo "External Authentication Test using the MongoDB C Driver"
echo "-------------------------------------------------------"

cat <<_EOU_ |
exttestro
exttestrw
extotherro
extotherrw
extbothro
extbothrw
exttestrwotherro
exttestrootherrw
_EOU_

while read user 
do
  echo "User: ${user}"
  if [[ ${user} =~ .*(both|test)ro.* ]]; then
    dr="db:test role:ro"
    ${basedir}/external-auth \
      "mongodb://$user:${user}${pass_suffix}@localhost?authMechanism=PLAIN&authSource=\$external" \
      test \
      query1 \
      ro 2>&1 >> ${basedir}/external-auth.log
    eaexit=$?
    if [ ${eaexit} -eq 0 ]; then
      printf "\t%-24s    [ok]\n" "${dr}"
    else
      printf "\t%-24s [error]\n" "${dr}"
      exit ${eaexit}
    fi
  fi
  if [[ ${user} =~ .*(both|test)rw.* ]]; then
    dr="db:test role:rw"
    ${basedir}/external-auth \
      "mongodb://$user:${user}${pass_suffix}@localhost?authMechanism=PLAIN&authSource=\$external" \
      test \
      query1 \
      rw 2>&1 >> ${basedir}/external-auth.log 
    eaexit=$?
    if [ ${eaexit} -eq 0 ]; then
      printf "\t%-24s    [ok]\n" "${dr}"
    else
      printf "\t%-24s [error]\n" "${dr}"
      exit ${eaexit}
    fi
  fi
  if [[ ${user} =~ .*(both|other)ro.* ]]; then
    dr="db:other role:ro"
    ${basedir}/external-auth \
      "mongodb://$user:${user}${pass_suffix}@localhost?authMechanism=PLAIN&authSource=\$external" \
      other \
      query1 \
      ro 2>&1 >> ${basedir}/external-auth.log 
    eaexit=$?
    if [ ${eaexit} -eq 0 ]; then
      printf "\t%-24s    [ok]\n" "${dr}"
    else
      printf "\t%-24s [error]\n" "${dr}"
      exit ${eaexit}
    fi
  fi
  if [[ ${user} =~ .*(both|other)rw.* ]]; then
    dr="db:other role:rw"
    ${basedir}/external-auth \
      "mongodb://$user:${user}${pass_suffix}@localhost?authMechanism=PLAIN&authSource=\$external" \
      other \
      query1 \
      rw 2>&1 >> ${basedir}/external-auth.log 
    eaexit=$?
    if [ ${eaexit} -eq 0 ]; then
      printf "\t%-24s    [ok]\n" "${dr}"
    else
      printf "\t%-24s [error]\n" "${dr}"
      exit ${eaexit}
    fi
  fi

done

