#!/bin/bash

URL="http://data.statmt.org/bergamot/models/deen"
MODEL="ende.student.tiny.for.regression.tests"
FILE="${MODEL}.tar.gz"
OUTPUT_DIR="deen"

mkdir -p ${OUTPUT_DIR}

if [ -f "$FILE" ]; then
    echo "File ${FILE} already downloaded."
else
    echo "Downloading ${FILE}"
    wget --quiet --continue $URL/${FILE}
    tar xf $FILE -C $OUTPUT_DIR/
    # wasm build doesnt support zipped input
    ( cd ${OUTPUT_DIR}/${MODEL} && gunzip -f lex.s2t.gz )
fi

test -f ${OUTPUT_DIR}/${MODEL}/vocab.deen.spm || exit 1
test -f ${OUTPUT_DIR}/${MODEL}/model.intgemm.alphas.bin || exit 1
test -f ${OUTPUT_DIR}/${MODEL}/lex.s2t || exit 1

# Get ssplit non-breaking prefix file.
# TODO: Bundle this in the archive.

wget https://raw.githubusercontent.com/ugermann/ssplit-cpp/master/nonbreaking_prefixes/nonbreaking_prefix.en -O ${OUTPUT_DIR}/${MODEL}/nonbreaking_prefix.en || exit 1
test -f ${OUTPUT_DIR}/${MODEL}/nonbreaking_prefix.en || exit 1

URL="http://data.statmt.org/bergamot/models/eten"
MODEL="enet.student.tiny11"
FILE="${MODEL}.tar.gz"
OUTPUT_DIR="enet"

mkdir -p ${OUTPUT_DIR}

if [ -f "${FILE}" ]; then
    echo "File ${FILE} already downloaded."
else
    echo "Downloading ${FILE}"
    wget --quiet --continue ${URL}/${FILE}
    tar xf ${FILE} -C ${OUTPUT_DIR}/
fi

wget https://raw.githubusercontent.com/felipesantosk/students/quality_model/eten/enet.quality.lr/quality_model.bin -O ${OUTPUT_DIR}/${MODEL}/quality_model.bin || exit 1
