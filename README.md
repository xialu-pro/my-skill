# My Skills — 开发者文档写作技能包

面向开发者生态文档的 AI Agent Skills 合集，覆盖「写 → 查 → 测」完整工作流。

| Skill | 一句话说明 | 阶段 |
|-------|-----------|------|
| [quick-start-writer](#1-quick-start-writer--写) | 写快速入门文档 | ✍️ 写 |
| [doc-quality-auditor](#2-doc-quality-auditor--查) | 检视文档质量 | 🔍 查 |
| [doc-cli-tester](#3-doc-cli-tester--测) | 测试文档中的命令行 | 🧪 测 |

三个 Skill 可独立使用，也可串联成完整工作流：

quick-start-writer → doc-quality-auditor → doc-cli-tester 写文档 静态质量审查 动态命令验证


plainText

---

## 快速安装

### 方式一：手动复制

```bash
git clone https://github.com/xialu-pro/my-skill.git

# 复制到项目级目录（仅当前项目生效，可提交到 git 团队共享）
cp -r my-skill/quick-start-writer  .claude/skills/
cp -r my-skill/doc-quality-auditor .claude/skills/
cp -r my-skill/doc-cli-tester      .claude/skills/

# 或复制到用户级目录（所有项目生效）
cp -r my-skill/quick-start-writer  ~/.claude/skills/
cp -r my-skill/doc-quality-auditor ~/.claude/skills/
cp -r my-skill/doc-cli-tester      ~/.claude/skills/
```

### 方式二：npx skills CLI

```bash
# 安装全部
npx skills add https://github.com/xialu-pro/my-skill --all

# 只装一个
npx skills add https://github.com/xialu-pro/my-skill --skill quick-start-writer
```

### 方式三：gh skill CLI

```bash
gh skill install xialu-pro/my-skill --skill quick-start-writer
gh skill install xialu-pro/my-skill --skill doc-quality-auditor
gh skill install xialu-pro/my-skill --skill doc-cli-tester
```

安装完成后，在 Claude Code / Cursor / GitHub Copilot 等支持 Agent Skills 的工具中，用触发词即可激活。

---

## Skill 详解

### 1. quick-start-writer — ✍️ 写

> 帮你写高质量的「快速入门」文档

**触发词**：我要写快速入门 / 帮我写 Quick Start / 快速上手文档 / Getting Started

**目录结构**：

quick-start-writer/ ├── SKILL.md # 主指令文件 ├── templates/ │ └── developer-quick-start.md # 开发者快速入门模板 └── evals/ └── evals.json # 评测用例


plainText

**核心能力**：

- **6 种文档范式**，覆盖不同产品形态：

  | 范式 | 适用场景 | 特点 |
  |------|---------|------|
  | 单页叙事型 | 概念密集型产品（React） | 无安装墙，Sandbox 直接运行 |
  | 向导步骤型 | 工具型产品（Docker） | 严格编号步骤，单一示例贯穿 |
  | 分流枢纽型 | 受众多元产品（Kubernetes） | 首屏问题引导分流 |
  | 极简安装型 | 工具链产品（Rust） | 5 分钟通读，OS 自动检测 |
  | 索引目录型 | 文档体系庞大（Fedora） | 纯目录索引，按需深入 |
  | 分层索引-向导型 | 复杂企业级产品 | 先选路再引路 |

- **范式选择决策树**：

Q1: 用户是否需要先理解概念才能操作？ ├─ 是 → 概念密集 → 单页叙事型 / 向导步骤型 └─ 否 → Q2: 存在多条路径吗？ ├─ 无 → 极简安装型 / 向导步骤型 └─ 有 → 路径维度 1-2层 → 分流枢纽型 路径维度 ≥3层 → 分层索引-向导型


plainText

- **5 条核心规律**：
1. 首屏必须回答「我能得到什么」
2. 个性化发生在用户第一个动作
3. 代码示例四个质量标准（可复制、可运行、有输出、有注释）
4. 安装墙是设计决策
5. 结尾离场设计同等重要

**使用示例**：

帮我写一份 openEuler 的快速入门文档，产品是一个操作系统， 面向开发者，需要覆盖安装和首次使用。


plainText

---

### 2. doc-quality-auditor — 🔍 查

> 用 42 项 CORE-EEAT 指标 + 5 维度文档框架检视文档质量

**触发词**：文档质量检视 / 检视文档质量 / 内容质量评分 / 42项指标检视 / 文档写得怎么样 / audit document quality

**目录结构**：

doc-quality-auditor/ ├── SKILL.md # 主指令文件 └── references/ └── 42-item-checklist.md # 42项详细检查清单


plainText

**来源**：衍生自 [CORE-EEAT Content Benchmark](https://github.com/aaron-he-zhu/core-eeat-content-benchmark)

**双轨评分系统**：

| 评分轨道 | 维度 | 满分 | 说明 |
|---------|------|------|------|
| **文档框架** | 结构逻辑性 (D01) | 20 | 章节顺序、层级嵌套、命名规范 |
| | 内容完整性 (D02) | 20 | 前置条件、核心覆盖、错误处理 |
| | 可操作性 (D03) | 20 | 命令示例、参数解释、验证步骤 |
| | 新手友好度 (D04) | 20 | 零基础能否看懂 |
| | 版本一致性 (D05) | 20 | 版本信息是否一致 |
| **CORE-EEAT** | C-上下文清晰度 | 100 | 10 项 |
| | O-组织结构 | 100 | 9 项 |
| | R-可引用性 | 100 | 9 项 |
| | Exp-经验 | 100 | 5 项 |
| | Ept-专业性 | 100 | 8 项 |
| | A-权威性 | 100 | 5 项 |
| | T-信任 | 100 | 4 项 |

**5 阶段工作流**：

阶段1: 设置 → 阶段2: Veto检查（紧急刹车）→ 阶段3: 维度检视 → 阶段4: 评分 → 阶段5: 输出报告


plainText

- **Veto 检查**：3 个关键项（T04 推广链接未披露 / C01 标题与内容不符 / R10 核心数据自相矛盾），有失败立即停止并警告
- **GEO/SEO 分离**：区分 GEO 优先（AI 引用）和 SEO 优先（搜索排名）建议

**3 种输出格式**：

- `report`（默认）：完整检视报告，含逐项评分和改进建议
- `scorecard`：评分卡，快速总览
- `markdown`：精简 Markdown 清单

**使用示例**：

检视 /path/to/document.md

评分这个文档的 GEO 可见性

audit document quality --format scorecard


plainText

---

### 3. doc-cli-tester — 🧪 测

> 自动测试文档中的命令行能否跑通

**触发词**：帮我测试文档中的命令 / 验证文档命令 / 文档命令测试 / doc cli test / 这篇文档的命令能跑吗

**目录结构**：

doc-cli-tester/ ├── SKILL.md # 主指令文件 ├── examples/ │ ├── openubmc-build-bmc/ │ │ ├── test_script.sh # 示例测试脚本 │ │ └── report.md # 示例测试报告 │ └── openeuler-install-prep/ │ ├── test_script.sh │ └── report.md └── evals/ └── evals.json # 评测用例


plainText

**6 步工作流**：

获取文档 → 提取命令块 → 命令分类 → 环境检测 → 生成测试脚本 → 执行并输出报告


plainText

**核心能力**：

- 从 Markdown 文档中自动提取命令行（bash/sh/shell 代码块 + 行内命令）
- 按可执行性分为 5 类：

  | 类型 | 示例 | 测试方式 |
  |------|------|----------|
  | 只读命令 | `cat`、`lscpu`、`uname -a` | 直接执行 |
  | 变更类命令 | `dnf update`、`systemctl enable` | 隔离环境或 `--dry-run` |
  | 交互式命令 | `nmtui`、`vim`、`top` | 仅验证命令存在 |
  | 专有工具命令 | `bingo build`、`repo sync` | 验证工具是否存在 |
  | 不可自动化 | BIOS 操作、图形界面 | 标记 SKIP |

- 检测当前环境是否匹配文档要求（OS / 架构 / 工具）
- 生成可执行的 Bash 测试脚本（`test_<文档名>.sh`）
- **严格区分**「文档问题」vs「环境限制」，不把环境差异判定为文档错误
- 报告按日期归档，支持多次迭代对比

**使用示例**：

帮我测试这份文档里的命令能不能跑通：/path/to/quick-start.md


plainText

---

## 完整工作流示例

以写一份 openEuler 快速入门为例，串联三个 Skill：

### Step 1：写文档

帮我写一份 openEuler 24.03 LTS 的快速入门文档， 面向开发者，需要覆盖系统安装和基本配置。


plainText

→ 触发 `quick-start-writer`，根据产品特点推荐范式，生成文档初稿

### Step 2：检视质量

帮我检视这份快速入门文档的质量


plainText

→ 触发 `doc-quality-auditor`，走 5 阶段检视流程，输出评分报告和 Top 5 改进建议

### Step 3：验证命令

帮我测试文档里的命令能不能跑通


plainText

→ 触发 `doc-cli-tester`，提取命令、生成测试脚本、执行并输出测试报告

### Step 4：迭代改进

根据 Step 2 和 Step 3 的报告修改文档，再跑一轮，直到评分和命令通过率达标。

---

## 归档与参考

### 检视报告（audits/）

`audits/` 目录存放 `doc-quality-auditor` 生成的检视报告：

| 文件 | 文档 |
|------|------|
| `openEuler-24.03-LTS-SP3-快速入门-CORE-EEAT检视报告.md` | openEuler 快速入门 |
| `openEuler官网快速入门-CORE-EEAT检视报告.md` | openEuler 官网 |
| `openEuler-官网-vs-改写版对比检视报告.md` | 对比检视 |
| `openUBMC-快速入门-CORE-EEAT检视报告-v2.md` | openUBMC 快速入门 |
| `openUBMC-快速入门-改写版.md` | openUBMC 改写版 |
| `AtomGit新版-vs-官网-对比检视报告.md` | AtomGit 对比 |
| `AtomGit新版-快速入门原文.md` | AtomGit 原文 |

### 命令行测试报告（doc-cli-tester/audits/ & examples/）

| 目录 | 文档 | 说明 |
|------|------|------|
| `doc-cli-tester/audits/MindSpore-AutoParallel.pipeline-命令行测试报告.md` | MindSpore AutoParallel | 发现 3 处文档错误 |
| `doc-cli-tester/examples/openubmc-build-bmc/` | openUBMC 构建 BMC | 含测试脚本和报告 |
| `doc-cli-tester/examples/openeuler-install-prep/` | openEuler 安装准备 | 含测试脚本和报告 |

### 研究报告

- `快速上手文档信息架构研究报告-完整版.md` — 基于 React / Kubernetes / Docker / Rust / Fedora / NVIDIA CUDA / openEuler / MindIE 等 8 个产品的快速上手文档研究，提炼出 6 种范式和 5 条核心规律，是 `quick-start-writer` Skill 的理论基础

---

## 兼容性

| 工具 | Skills 目录 | 支持情况 |
|------|------------|----------|
| Claude Code | `.claude/skills/` | ✅ |
| Cursor | `.cursor/skills/` | ✅ |
| GitHub Copilot | `.github/skills/` | ✅ |
| Windsurf | `.windsurf/skills/` | ✅ |
| Codex CLI | `.codex/skills/` | ✅ |
| OpenCode | `.opencode/skills/` | ✅ |

---

## 许可证

Apache-2.0
