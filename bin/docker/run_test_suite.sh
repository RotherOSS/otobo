#!/usr/bin/env bash

bin/otobo.Console.pl Dev::UnitTest::Run --verbose >prove_10_1_$(date +'%F-%H%M%S').out 2>&1
