# 词典生成脚本

## 词典说明

这个脚本会读取 `dicts` 目录下的词典文件，在 `schema` 目录下生成 `jiandao.dict.yaml`, `jiandao.base.dict.yaml`, 和 `jiandao.user.dict.yaml` 三个词典。其中 `jiandao.dict.yaml` 仅引用了其他两个文件，`jiandao.base.dict.yaml` 包含了预设的字词，`jiandao.user.dict.yaml` 交由用户添加自定义词语。

这个脚本主要工作是转换 cizu 词典，转换好 cizu 词典后会和其他词典合并，生成 Rime 需要的词典。对于 cizu 词典的转换是通过调用 Python 脚本 `convert_raw_dict.py`，从包含**词语**、**全码**、**权重**信息的原始格式的词典文件 cizu_raw.txt 转换为仅含**词语**和**实际编码**的文件。（实际编码会因为词序，由全码缩减部分形码字母）

原始格式如下所示：

```text
词语	音码	形码	权重	附加权重	注释
```

例如：

```text
并不比	bbb	ovv	1000
白板笔	bbb	uvu	899
彬彬	bbbb	vv	1000
斌斌	bbbb	oo	899
并不表示	bbbe	ov	1000
宾白	bbbh	ou	1000
宾部	bbbj	oo	1000
宾补	bbbj	oo	899
```

其中「附加权重」和「注释」为可选项，当需要两个同音码词语权重相同时，他们最终保留的形码字母也会相同，此时脚本会参考附加权重分配首选和次选：

```text
不高兴	bgx	voo	1000	2	首选
不敢想	bgx	vav	1000	1	次选
```

当需要空出编码，使用 `@@@` 作为词语可以占位，如：

```text
@@@	kls	???	1000	1	让位「IOS」
@@@	qeq	???	1000	1	平衡「这事情」飞键
```

如果需要附加、删除词语，或者是修改权重，可在脚本参数中指定对应的自定义补丁文件。

## 使用方法

> Windows 用户请使用 WSL 运行

```bash
$ script/make_dicts.sh [选项]
```

当不带任何选项时，默认转换的原始格式词典为 `dicts/cizu_raw.txt`，可使用 `--rawdict <文件>` 来指定其他文件。默认不会进行附加、删除、权重修改的操作，可以通过选项来指定：

```bash
--append <文件> # 附加词库，需要是原始格式
--delete <文件> # 要删除的词语，一行一词，格式为 "词语	音码"，注意是用 Tab 隔开的
--modify <文件> # 要修改权重的词语，一行一词，格式为 "词语	音码	+250"，使用 Tab 隔开，第三列为权重改变的值，可正可负
--deweight # 加上这个选项可以将 630 词汇降权
```

另外还有一个选项 `--clean` 可以删除生成的词典，恢复未改动的原始格式 cizu_raw.txt
