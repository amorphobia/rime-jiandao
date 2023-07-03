# 🌟️星空键道输入方案

配方：℞ jiandao

🌟️星空键道

原作者：吅吅大山，[官方仓库](https://github.com/xkinput/Rime_JD)

## 动机

旨在提供一份配置有优化、文件去冗余的键道配方仓库。初期词库将和官方一致，之后会根据需要修改。

## 安装

四种方式可以使用，前两种方式无法对 cizu 词典进行非覆盖式的修改，后两种可用补丁形式对 cizu 进行修改，请自行选择，注意每种方式都需要在 `default.custom.yaml` 里添加本方案 (jiandao)。

### 1. 下载 Zip 包

请在[发布页面](https://github.com/amorphobia/rime-jiandao/releases)下载打包好的方案，解压文件到对应的目录。

### 2. 东风破

```bash
bash rime-install amorphobia/rime-jiandao@release
```

### 3. 克隆并在本地生成词库

> Windows 用户请使用 WSL 运行

克隆仓库后，执行以下命令（详情请看[这里的介绍](scripts/README.md)）

```bash
scrips/make_dicts.sh --append <cizu_append.txt> --delete <cizu_delete.txt> --modify <cizu_modify.txt>
```

需要修改为你自己的对应文件名，也可省略选项。生成的方案在 `schema` 目录中。

### 4. 使用 Github Action 自动生成方案文件

Fork 本仓库后，可以把需要添加、删除、修改权重的词语按需要的格式放到 `dicts` 目录下的 `cizu_append.txt`, `cizu_delete.txt`, 和 `cizu_modify.txt` 文件中，当推送到 Github 的时候，可以自动生成方案文件，生成的文件可以在 Actions 里面找到。

## 与官方方案不同之处

### 配置的不同

- 微调了开关菜单，不再提供关闭630全码词的开关（取而代之的是在构建词库时把630全码词权重降低）
- 关闭了自动上屏，默认使用顶功上屏
- 次选使用分号键，单引号用作三选
- 一些开关的快捷键修改

### 词典的不同

- 删除 lianjie 词典，其中项目选择一部分放到了 fuhao 词典里
- 删除了 yingwen 词典，因其规则不明确（如有需要可以自行添加）
- 删除了「臜」字的错误形码 `zsuouv`
- 修改了「嫠」、「釐」两字的拆字，拆分为「𠩺」和剩余部分（其中「釐」字收录读音 xī 而非 lí）
- 默认降低了 630 词汇对应全码的权重（可以在构建词典时控制，不添加 `--deweight` 选项时保持原权重）

## 开源许可

原有的内容无开源许可声明，遵循[《中华人民共和国著作权法》](http://www.npc.gov.cn/npc/c30834/202011/848e73f58d4e4c5b82f69d25d46048c6.shtml)

本仓库新增内容使用 [AGPL-3.0](LICENSE) 许可
