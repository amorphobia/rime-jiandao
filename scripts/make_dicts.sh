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

RAWDICT_ORG="${BASEDIR}/../dicts/cizu_raw.txt"
RAWDICT="${BASEDIR}/../dicts/cizu_raw_work.txt"
OUTPUT="${BASEDIR}/../schema/jiandao.base.dict.yaml"
XIAOXIAO="${BASEDIR}/../xiaoxiao/mb/jiandao.txt"
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
            rm -f ${BASEDIR}/../dicts/02.cizu.txt ${RAWDICT} $(dirname "${OUTPUT}")/*.dict.yaml temp.txt
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

if [[ ! -f ${RAWDICT_ORG} ]]; then
    echo "${RAWDICT_ORG} does not exist."
    exit
fi

cp ${RAWDICT_ORG} ${RAWDICT}

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

cat << EOF > ${XIAOXIAO}
encode=UTF-8
name=🌟️星空键道
key=zyxwvutsrqponmlkjihgfedcba
len=6
wildcard=]
assist=\` mb/pinyin.txt
user=mb/jiandao.user.txt
[data]
EOF

awk -v FS='\t' -v OFS=' ' '{print $2,$1}' <(cat ${BASEDIR}/../dicts/01.danzi.txt | tr -d '\r') >> ${XIAOXIAO}
awk -v FS='\t' -v OFS=' ' 'NR==FNR {map[$1] = $2; next} {if (!map[$1]) print $2,$1; else print $2,"$["$1"("map[$1]")]"$1}' ${BASEDIR}/../dicts/06.630.txt ${BASEDIR}/../dicts/02.cizu.txt >> ${XIAOXIAO}
awk -v FS='\t' -v OFS=' ' '{print $2,$1}' <(cat ${BASEDIR}/../dicts/03.fuhao.txt | tr -d '\r') >> ${XIAOXIAO}
awk -v FS='\t' -v OFS=' ' '{print $2,$1}' <(cat ${BASEDIR}/../dicts/04.buchong.txt | tr -d '\r') >> ${XIAOXIAO}
awk -v FS='\t' -v OFS=' ' '{print $2,$1}' <(cat ${BASEDIR}/../dicts/06.630.txt | tr -d '\r') >> ${XIAOXIAO}
cat ${BASEDIR}/../dicts/xiaoxiao.txt | tr -d '\r' >> ${XIAOXIAO}
sed -i -e 's/\\n/$\//g' ${XIAOXIAO}
sed -i -e 's/\\t/\t/g' ${XIAOXIAO}
sed -i -e 's/\\\\/\\/g' ${XIAOXIAO}

cat << EOF > $(dirname "${XIAOXIAO}")/jiandao.user.txt
# 编码必须为 GB18030
# 𮧵䶮 <- 此信息正确显示时编码大概率识别正确（不排除特殊情况）
EOF

iconv -f utf-8 -t gb18030 $(dirname "${XIAOXIAO}")/jiandao.user.txt -o temp.txt
mv temp.txt $(dirname "${XIAOXIAO}")/jiandao.user.txt
