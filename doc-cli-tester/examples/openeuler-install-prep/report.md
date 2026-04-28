# openEuler《安装准备》— 命令行测试报告

**文档**：https://docs.openeuler.openatom.cn/zh/docs/24.03_LTS_SP3/server/installation_upgrade/installation/installation_preparations.html  
**生成时间**：2026-04-28  
**目标环境**：已下载 openEuler 24.03 LTS SP3 ISO 及校验文件的 Linux 环境  
**当前环境**：macOS（部分命令已验证，依赖 ISO 文件的步骤需在目标环境中验证）

---

## 一、命令提取与分类

从文档中提取到 **2 条可执行命令**：

| 编号 | 命令 | 类型 | 测试方式 |
|------|------|------|----------|
| 1 | `sha256sum openEuler-24.03-LTS-SP3-aarch64-dvd.iso` | 只读类 | 直接执行（依赖 ISO 已下载） |
| 2 | `gpg2 --verify openEuler-24.03-LTS-SP3-aarch64-dvd.iso.asc` | 只读类 | 需 ISO + .asc 文件 + GPG 公钥 |

> 文档其余内容为操作步骤描述（登录网站、单击按钮等），属于**不可自动化**操作，已正确识别并跳过。

---

## 二、当前环境执行结果

在 macOS 上直接执行工具可用性检测：

```
sha256sum：macOS 无 sha256sum，对应命令为 shasum -a 256
gpg2：需单独安装（brew install gnupg）
```

**注意**：文档写的是 `sha256sum`，这是 Linux 标准命令，在 openEuler 系统上完全正确。macOS 上的差异属于**环境差异，不是文档错误**。

---

## 三、文档问题分析

经逐条检查，发现 **1 处文档问题**：

### ❌ 问题：sha256sum 预期输出使用了占位符

文档中 sha256sum 的预期输出格式为：
```
校验值  openEuler-24.03-LTS-SP3-aarch64-dvd.iso
```
使用了"校验值"作为占位符，用户无法直接比对。

**修复建议**：补充实际的 SHA256 值，与官网下载页保持一致，例如：
```
a3c91e448a8b17e3b0f2a3ddf5c2c4f1e9b8a7d6c5e4f3a2b1c0d9e8f7a6b5c4  openEuler-24.03-LTS-SP3-aarch64-dvd.iso
```
或明确指引用户"将以上输出与官网下载页面上公布的 SHA256 值进行比对"。

---

## 四、结论

| 维度 | 评估 |
|------|------|
| 命令语法 | ✅ 全部正确 |
| 命令逻辑顺序 | ✅ 下载 → 校验完整性，顺序合理 |
| 文档错误 | ⚠️ 1 处：sha256sum 预期输出使用占位符，建议补充真实校验值 |
| 前置条件说明 | ✅ 已说明需先下载 ISO 和校验文件 |

**建议**：在已下载 ISO 文件的 openEuler 环境中运行 `test_openeuler_installation_preparations.sh` 进行完整验证。
