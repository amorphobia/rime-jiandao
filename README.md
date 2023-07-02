# 🌟️星空键道输入方案

配方：℞ jiandao

🌟️星空键道

原作者：吅吅大山

## 动机

旨在提供一份配置有优化、文件去冗余的[键道](https://github.com/xkinput/Rime_JD)配方仓库。初期词库将和官方一致，之后会根据需要修改。

## 安装

四种方式可以使用，前两种方式无法对 cizu 词典进行非覆盖式的修改，后两种可用补丁形式对 cizu 进行修改，请自行选择

### 下载 Zip 包

请在[发布页面](https://github.com/amorphobia/rime-jiandao/releases)下载打包好的方案，解压文件到对应的目录，并在 `default.custom.yaml` 里添加本方案 (jiandao)

### 东风破

```bash
bash rime-install amorphobia/rime-jiandao@release
```

### 克隆并在本地生成词库

> Windows 用户请使用 WSL 运行

克隆仓库后，执行以下命令（详情请看[这里](scripts/README.md)）

```bash
scrips/make_dicts.sh --append <cizu_append.txt> --delete <cizu_delete.txt> --modify <cizu_modify.txt>
```

需要修改为你自己的对应文件名，也可省略选项。生成的方案在 `schema` 目录中。

### 使用 Github Action 自动生成方案文件

Fork 本仓库后，可以把需要添加、删除、修改权重的词语按需要的格式放到 `dicts` 目录下的 `cizu_append.txt`, `cizu_delete.txt`, 和 `cizu_modify.txt` 文件中，当推送到 Github 的时候，可以自动生成方案文件，生成的文件可以在 Actions 里面找到。

## 开源许可

原有的内容无开源许可声明，遵循[《中华人民共和国著作权法》](http://www.npc.gov.cn/npc/c30834/202011/848e73f58d4e4c5b82f69d25d46048c6.shtml)

本仓库新增内容使用 [AGPL-3.0](LICENSE) 许可
