--[[
    Unicode Translator
    Copyright (C) 2024 Xuesong Peng <pengxuesong.cn@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

local function filter(input)
  for cand in input:iter() do
    local text = string.gsub(cand.text, "\\n", "\n")
    text = string.gsub(text, "\\t", "\t")
    text = string.gsub(text, "\\\\", "\\")
    local comment = cand:get_genuine().comment
    yield(Candidate(cand.type, cand._start, cand._end, text, comment))
  end
end

return filter
