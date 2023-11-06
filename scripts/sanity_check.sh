#!/usr/bin/env bash

# Sanity Check
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

export LC_ALL=C

WORK=$(pwd)

sort -k2,2 -k4,4nr -k5,5nr -k3,3 ${WORK}/dicts/cizu_raw.txt | awk '!seen[$1,$2]++' > ${WORK}/temp.txt
diff ${WORK}/dicts/cizu_raw.txt ${WORK}/temp.txt
