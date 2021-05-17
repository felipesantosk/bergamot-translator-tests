#!/bin/bash

set -eo pipefail;
BRT_INSTRUCTION=''

CPU_FEATURES_OUTPUT=cpu.features.log

# https://stackoverflow.com/a/246128/4565794
BRT_TOOLS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

$BRT_TOOLS/cpu-features/build/list_cpu_features > $CPU_FEATURES_OUTPUT

# Skip if requirements are not met
if ! grep -q -e "avx" -e "ssse3" $CPU_FEATURES_OUTPUT; then
    echo "Your CPU does not support AVX* or SSSE3, which is required" 1>&2
    exit 100
fi


# Outputs differ on CPUs supporting AVX AVX2 or AVX512
BRT_INSTRUCTION=avx
if grep -q "avx512vnni" $CPU_FEATURES_OUTPUT ; then
    BRT_INSTRUCTION=avx512_vnni
elif grep -q "avx512" $CPU_FEATURES_OUTPUT ; then
    BRT_INSTRUCTION=avx512
elif grep -q "avx2" $CPU_FEATURES_OUTPUT ; then
    BRT_INSTRUCTION=avx2
elif grep -q "ssse3" $CPU_FEATURES_OUTPUT; then
    BRT_INSTRUCTION=ssse3
fi

echo $BRT_INSTRUCTION
export BRT_INSTRUCTION=${BRT_INSTRUCTION}