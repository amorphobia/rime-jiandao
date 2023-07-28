#!/usr/bin/env bash

# Make Dicts
# Copyright (C) 2023  Xuesong Peng <pengxuesong.cn@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

BASEDIR=$(dirname "$0")

usage() {
    echo ""
    echo "Usage:"
    echo " $(basename $0) [options]"
    echo ""
    echo "Make Jiandao dicts."
    echo ""
    echo "Options:"
    echo " -a, --append <file>    the raw dict file to be appended"
    echo " -d, --delete <file>    the file of terms to be deleted"
    echo " -m, --modify <file>    the file of terms to be modified and their weight delta"
    echo " -r, --rawdict <file>   the raw dict file, default is \"${BASEDIR}/../dicts/cizu_raw.txt\""
    echo " -v, --version <string> the target version"
    echo "     --deweight         reduce the weight of 630 phrases"
    echo "     --clean            clean generated files and restore the raw dict"
    echo ""
    echo " -h, --help             display this help"
}

RAWDICT="${BASEDIR}/../dicts/cizu_raw.txt"
OUTPUT="${BASEDIR}/../schema/jiandao.base.dict.yaml"
VERSION="master"
DEWEIGHT=0

ARGS=$(getopt -o a:d:m:r:v:h --long append:,delete:,modify:,rawdict:,version:,deweight,clean,help -n "$(basename $0)" -- "$@")
if [[ $? -ne 0 ]]; then
    usage
    exit
fi

eval set -- "${ARGS}"

while true; do
    case "$1" in
        -a | --append )
            APPEND=$2
            shift 2
            ;;
        -d | --delete )
            DELETE=$2
            shift 2
            ;;
        -m | --modify )
            MODIFY=$2
            shift 2
            ;;
        -r | --rawdict )
            RAWDICT=$2
            shift 2
            ;;
        -v | --version )
            VERSION=$2
            shift 2
            ;;
        --deweight )
            DEWEIGHT=1
            shift
            ;;
        --clean )
            if [[ -f "${RAWDICT}.bak" ]]; then
                mv "${RAWDICT}.bak" ${RAWDICT}
            fi
            rm -f ${BASEDIR}/../dicts/02.cizu.txt $(dirname "${OUTPUT}")/*.dict.yaml temp.txt
            exit
            ;;
        -- )
            shift
            break
            ;;
        * )
            usage
            exit
            ;;
    esac
done

if [[ ! -f ${RAWDICT} ]]; then
    echo "${RAWDICT} does not exist."
    exit
fi

cp ${RAWDICT} "${RAWDICT}.bak"

if [[ ! -f ${APPEND} ]]; then
    APPEND=""
fi

cat ${RAWDICT} ${APPEND} | awk '!seen[$1,$2]++' > temp.txt
mv temp.txt ${RAWDICT}

if [[ "${DEWEIGHT}" -eq 1 ]]; then
    awk -v OFS='\t' 'NR==FNR {map[$1]++; next} {if (!map[$1]) print $0; else print $1,$2,$3,10,$5,$6}' ${BASEDIR}/../dicts/06.630.txt ${RAWDICT} > temp.txt
    mv temp.txt ${RAWDICT}
fi

if [[ -f ${DELETE} ]]; then
    awk 'NR==FNR {map[$1,$2]++; next} {if (!map[$1,$2]) print $0}' ${DELETE} ${RAWDICT} > temp.txt
    mv temp.txt ${RAWDICT}
fi

if [[ -f ${MODIFY} ]]; then
    awk -v OFS='\t' 'NR==FNR {map[$1,$2] = $3; next} {print $1,$2,$3,$4+map[$1,$2],$5,$6}' ${MODIFY} ${RAWDICT} > temp.txt
    mv temp.txt ${RAWDICT}
fi

sort -k2,2 -k4,4nr -k5,5nr -k3,3 ${RAWDICT} > temp.txt
mv temp.txt ${RAWDICT}

python3 ${BASEDIR}/convert_raw_dict.py ${RAWDICT} | sort -k2 -s > ${BASEDIR}/../dicts/02.cizu.txt

cat << EOF > ${OUTPUT}
# Rime dictionary
# encoding: utf-8
---
name: jiandao.base
version: ${VERSION}
sort: original
...
EOF

cat ${BASEDIR}/../dicts/0*.txt >> ${OUTPUT}

cat << EOF > $(dirname "${OUTPUT}")/jiandao.user.dict.yaml
# Rime dictionary
# encoding: utf-8
---
name: jiandao.user
version: ${VERSION}
sort: original
...
EOF

cat << EOF > $(dirname "${OUTPUT}")/jiandao.dict.yaml
# Rime dictionary
# encoding: utf-8
---
name: jiandao
version: ${VERSION}
sort: original
use_preset_vocabulary: false
import_tables:
  - jiandao.base
  - jiandao.user
...
EOF
