# 词典

基本上和官方词典一致，如有不同会在此列出。

## 1. danzi（单字）

在 `01.danzi.txt` 中做了如下改动

- 删除了「臜」的错误编码 `zsuo` 和 `zsuouv`
- 修改了「嫠」、「釐」两字的拆字，拆分为「𠩺」和剩余部分，其中「釐」字是多音字，读 lí 时是「厘」的异体字，故删除该读音，读 xī 时是规范汉字，添加该读音
- 补全了「灀」、「蝠」、「珋」、「螯」、「祂」几字缺失的全码
- 添加了「㞌」、「蚖」、「述」三字缺失的简码
- 在规范汉字中，`苎 <=> 苧`，`苧 <=> 薴` 为两对不同的简繁关系；在简体环境下，「苧」应读作 `níng` 而非 `zhù`，故修改其读音编码

## 2. cizu（词组）

在 `cizu_raw.txt` 中做了如下改动

### 音形错误

- 「立传」的音码 `lkwt` 错误，改为 `lkft`
- 「佛科」音码 `fjke` 错误，且意义不明，予以删除

#### 「血」字读音（`xiě` 或 `xuè`）相关错误

已被键道收录的词语，以《现代汉语词典》为标准，修正明确了读音的词条；未被键道收录的词语，暂不作追加收录

- 「血球」中，正确读音为 `xuè`，音码由 `xdqq` 改为 `xhqq`
- 「血水」中，正确读音为 `xuè`，删除音码 `xdeb`
- 「血晕」中，两者皆有，补充音码 `xhyw`
- 「采血」中，正确读音为 `xiě`，删除音码 `chxh`
- 「出血」中，单用这个词的时候，正确读音为 `xiě`，但考虑到在「脑出血」、「外出血」等复合词中，读作 `xuè`，保留 `jjxh` 以便拆分输入，另补充音码 `jjxd`
- 「放血」中，正确读音为 `xiě`，音码由 `fpxh` 改为 `fpxd`
- 「换血」中，正确读音为 `xiě`，音码由 `htxh` 改为 `htxd`
- 「咳血」中，正确读音为 `xiě`，音码由 `kexh` 改为 `kexd`
- 「尿血」中，正确读音为 `xiě`，音码由 `ncxh` 改为 `ncxd`
- 「气血」中，正确读音为 `xuè`，删除音码 `qkxd`
- 「验血」中，正确读音为 `xiě`，删除音码 `yfxh`

### 字词错误

- 删除了「港珠奥」、「港珠奥大桥」两个错字词
- 「酷弊了」修改为「酷毙了」
- 「唔呣」修改为「唔姆」（日语语气词「うむ」的音译）
- 《[通用规范汉字表](https://zh.wikipedia.org/zh-cn/%E9%80%9A%E7%94%A8%E8%A7%84%E8%8C%83%E6%B1%89%E5%AD%97%E8%A1%A8)》发布后，「錢鍾書」的简体之规范写法应为「钱锺书」，予以修正
- 「杨桃」之正确写法应为「阳桃」，正如「榴莲」之于「榴梿」、「芒果」之于「杧果」，因此添加「阳桃」

### 飞键问题

- 「病兆」缺失 `bgqz` 音码补全，原有的「并找」删除
- 「八爪鱼」、「广府」、「凄怆」、「爪哇」、「床褥」缺失飞键音码补全

### 无谓简码

- 「难听」的音码 `nftg` 并无重码问题，将其由简码 `nft` 改为全音码 `nftg`
- 「早了」的音码 `zzle` 并无重码问题，将其由简码 `zzl` 改为全音码 `zzle`，添加「在做了」到音码 `zzl`
- 「没人」有全音码 `mwrn`，但同时有简码 `mwr`，删除简码，添加了「没外人」

### 冗余编码

- 删除了「待在」、「含糊其辞」、「小笼包」多余的五码（实际上因为本仓库的 [sanity_check.sh 脚本](../scripts/sanity_check.sh)自动删除了靠后的编码，在一开始编写文档时并未意识到）

### 通过脚本 `make_dicts.sh` 做出的改动

- 默认降低了 630 词汇对应全音码词的权重，如「不能」有 630 简码 `ba`，则降低其全音码 `bjnr` 的权重至 10（可以在生成词典时，不添加 `--deweight` 选项来保持原有权重）

另外提供了 `cizu_append.txt.in` 和 `cizu_modify.txt.in` 作为词典补丁的例子，将其扩展名 `.in` 删除后，可以通过 Github Actions 生成补丁后的词典，详见[词典生成脚本说明](../scripts/README.md)

## 3. fuhao（符号）

在 `03.fuhao.txt` 中做了如下改动

- 整体删除了官方 lianjie（链接）词典，保留了其中几个有用的项目放到 fuhao（符号）词典里，添加了[详尽教程](https://pingshunhuangalex.gitbook.io/rime-xkjd)的链接
- 「×	ojh」改为「✗	ow」（叉），「√	og」改为「✓	og」（钩）

## 4. buchong（补充）

未做改动

## 5. chaojizici（超级字词）

### 删除重复

以下汉字在 danzi 中已存在，已删除

|汉字|编码|汉字|编码|汉字|编码|
|---|---|---|---|---|---|
|尛|`mliuiu`|祂|`tsoaai`|垚|`yzvvvv`（亦是形码错误）|

### 补全简码

以下汉字简码缺失，已补全

|汉字|简码|汉字|简码|汉字|简码|汉字|简码|
|---|---|---|---|---|---|---|---|
|弔|`dcava`|呾|`dfooi`|呾|`dsooi`|㩼|`fkuau`|
|佮|`geiiv`|椛|`hqvii`|䜰|`hzuou`|檵|`jkvaa`|
|奆|`jtvu`|䜮|`lzuo`|冇|`mzvu`|鲶|`nmuai`|
|骹|`qciao`|礐|`qhui`|惢|`sloao`|卍|`wfai`|
|卐|`wfavi`|喎|`who`|枔|`xbvi`|𬘓|`xwaau`|
|苂|`ybiio`|烎|`ybvvo`|嘢|`yeoia`|鵺|`yeovu`|
|𪩘|`yfiau`|喦|`yfooi`|囃|`zsovi`|||

### 简码冲突

- 「𭎂」（⿰土从）简码与「鬷」冲突，多加一码避重
- 「甴」（zhá）简码 `fsia` 与「眨」冲突，多加一码避重
- 「甴」（yóu）的所有可能简码均与其他单字简码冲突，仅保留全码

### 添加汉字

- 添加了元素周期表使用的未收录字：「鿔」、「𫟷」、「鿭」、「鿬」、「鿫」

## 6. 630（原 wxw）

未做改动