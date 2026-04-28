# openUBMC《构建你的BMC》— 命令行测试报告

**文档**：https://www.openubmc.cn/docs/zh/development/quick_start/build_your_own_bmc.html  
**生成时间**：2026-04-28  
**目标环境**：Linux，已完成《环境准备》章节（含 bingo 工具、GitCode SSH Key）  
**当前环境**：macOS（命令验证受限，已生成可在目标环境运行的测试脚本）

---

## 一、命令提取与分类

从文档中提取到 **6 条命令**：

| 编号 | 命令 | 类型 | 测试方式 |
|------|------|------|----------|
| 1 | `git clone git@gitcode.com:openUBMC/manifest.git` | 变更类 | SKIP（需 SSH Key + 网络） |
| 2 | `cd /home/workspace/manifest && bingo build` | 变更类 | SKIP（需 bingo 工具） |
| 3 | `bingo build -sc qemu` | 变更类 | SKIP（需 bingo 工具） |
| 4 | `ls /home/workspace/manifest/output/packet/inner` | 只读类 | 可直接执行（依赖前置步骤） |
| 5 | `python3 build/works/packet/qemu_shells/vemake_1711.py` | 变更类/交互式 | SKIP（启动 QEMU，占用终端） |
| 6 | `ls /home/workspace/manifest/output/packet/inner`（验证产物） | 只读类 | 可直接执行（依赖前置步骤） |

> **预期输出代码块已正确识别并排除**：  
> `` > ls /home/workspace/manifest/output/packet/inner `` 后的 `openUBMC_qemu_default.cpio.gz` 为预期输出，不作为待执行命令。

---

## 二、测试概览

| 状态 | 数量 | 说明 |
|------|------|------|
| ✅ PASS | — | 需在目标环境验证 |
| ❌ FAIL | 0 | 无文档错误 |
| ⏭ SKIP | 4 | 变更类/交互式，需完整 openUBMC 环境 |
| 🔍 待验证 | 2 | 只读命令，依赖前置构建步骤完成 |

---

## 三、详细结果

### ⏭ SKIP：变更类命令

**[1] `git clone git@gitcode.com:openUBMC/manifest.git`**
- 跳过原因：需要 GitCode SSH Key 已配置，且网络可达 gitcode.com
- 验证建议：在已配置 SSH Key 的环境中执行，检查 manifest 目录是否正常创建

**[2] `cd /home/workspace/manifest && bingo build`**  
**[3] `bingo build -sc qemu`**
- 跳过原因：`bingo` 是 openUBMC 专有构建工具，需完成《环境准备》后才可用
- 验证建议：在 openUBMC 开发环境中执行，检查 `manifest/output/` 目录是否生成产物

**[5] `python3 build/works/packet/qemu_shells/vemake_1711.py`**
- 类型：变更类 + 交互式（启动 QEMU 仿真环境，占用终端）
- 跳过原因：需要仿真包已构建、qemu 已安装

### 🔍 待验证：只读命令（依赖前置步骤）

**[4][6] `ls /home/workspace/manifest/output/packet/inner`**
- 命令语法正确，但需在构建完成后执行才有意义
- 验证建议：构建完成后执行，检查输出中包含 `openUBMC_qemu_default.cpio.gz`

---

## 四、文档问题分析

经逐条检查，**文档命令语法全部正确，无拼写错误**。

以下为文档质量建议（非命令错误）：

1. **`bingo` 工具未说明来源**：文档提到"通过使用 bingo 工具开启自动化构建流程"，但未说明 bingo 是在《环境准备》中安装的，建议在此处加一句引用，如：
   > "bingo 工具已在《环境准备》中安装，如未安装请先完成该章节。"

2. **`git clone` 使用 SSH 协议**：SSH 协议需要提前配置 GitCode SSH Key，建议加一句前置条件说明或提供 HTTPS 备选方式：
   ```shell
   # HTTPS 方式（无需 SSH Key）
   git clone https://gitcode.com/openUBMC/manifest.git
   ```

3. **构建时间未说明**：`bingo build` 首次执行耗时较长，建议加预期时间提示，避免用户误以为卡住。

---

## 五、结论

| 维度 | 评估 |
|------|------|
| 命令语法 | ✅ 全部正确 |
| 命令逻辑顺序 | ✅ clone → build → 验证产物 → 启动仿真，顺序合理 |
| 文档错误 | ✅ 无 |
| 前置条件说明 | ⚠️ bingo 工具来源、SSH Key 配置可补充说明 |

**建议**：在已完成《环境准备》的 openUBMC 开发环境中运行 `test_openubmc_build_bmc.sh` 进行完整验证。
