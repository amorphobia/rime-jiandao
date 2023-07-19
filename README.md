# 🌟️星空键道输入方案

配方：℞ jiandao

🌟️星空键道

原作者：吅吅大山，官方仓库（[GitHub](https://github.com/xkinput/Rime_JD)，[Gitee](https://gitee.com/xkinput/Rime_JD)）

## 动机

旨在提供一份配置有优化、文件去冗余的键道配方仓库。初期词库将和官方一致，之后会根据需要修改。

## 安装

五种方式可以使用，前两种可用补丁形式对 cizu 进行修改，后三种方式无法对 cizu 词典进行非覆盖式的修改，请自行选择，注意有可能需要手动在 `default.custom.yaml` 里添加本方案 (jiandao)。

### 1. 使用 Github Actions 自动生成方案文件

Fork 本仓库后，可以把需要添加、删除、修改权重的词语按需要的格式放到 `dicts` 目录下的 `cizu_append.txt`, `cizu_delete.txt`, 和 `cizu_modify.txt` 文件中，当推送到 Github 的时候，可以自动生成方案文件，生成的文件可以在 Actions 里面找到。

### 2. 克隆并在本地生成词库

> Windows 用户请使用 WSL 运行

克隆仓库后，执行以下命令（详情请看[词典生成脚本说明](scripts/README.md)）

```bash
scrips/make_dicts.sh --append <cizu_append.txt> --delete <cizu_delete.txt> --modify <cizu_modify.txt>
```

需要修改为你自己的对应文件名，也可省略选项。生成的方案在 `schema` 目录中。

### 3. 使用 PowerShell 命令安装（小狼毫）

在 PowerShell 中执行以下命令之一，然后按照提示安装即可。

```PowerShell
# GitHub 源，需要上网环境
irm tinyurl.com/installer-ps1 | iex

# Gitee 源
irm https://gitee.com/amorphobia/rime-jiandao/raw/master/scripts/installer.ps1 | iex
```

如果遇到错误，运行一次 `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` 再试。

### 4. 下载 Zip 包

请在发布页面（[GitHub](https://github.com/amorphobia/rime-jiandao/releases)，[Gitee](https://gitee.com/amorphobia/rime-jiandao/releases)）下载打包好的方案，解压文件到对应的目录。

### 5. 东风破

```bash
bash rime-install amorphobia/rime-jiandao@release
```

## 与官方方案不同之处

### 配置的不同

- 微调了开关菜单，不再提供关闭630全码词的开关（取而代之的是在构建词库时把630全码词权重降低）
- 关闭了自动上屏，默认使用顶功上屏
- 次选使用分号键，单引号用作三选
- 一些开关的快捷键修改
- 将 lua 脚本统一放入 `jiandao` 子目录，避免冲突
- 提供了一个统一码翻译器（Unicode Translator），可以通过 ``u`​`` 引导统一码来输入

### 词典的不同

详见[词典说明](dicts/README.md)

## 开源许可

原有的内容无开源许可声明，遵循[《中华人民共和国著作权法》](http://www.npc.gov.cn/npc/c30834/202011/848e73f58d4e4c5b82f69d25d46048c6.shtml)

本仓库新增内容使用 [AGPL-3.0](LICENSE) 许可
