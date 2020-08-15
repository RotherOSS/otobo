#!/usr/bin/env bash

prove -I . -I Kernel/cpan-lib -I Custom --verbose -r scripts/test > prove_$(date +'%F-%H%M%S').out 2>&1
