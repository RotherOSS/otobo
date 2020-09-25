#!/usr/bin/env bash

# generate an informative log file name
otobo_version=$(perl -lne 'print $1 if /VERSION\s*=\s*(\S+)/' < RELEASE)
time_stamp=$(date +'%F-%H%M%S')
log_file="prove_${otobo_version}_${time_stamp}.out"

# run the test suite
prove -I . -I Kernel/cpan-lib -I Custom --verbose -r scripts/test >$log_file 2>&1
