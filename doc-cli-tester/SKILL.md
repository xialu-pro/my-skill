---
name: doc-cli-tester
description: 对开发者文档（Markdown）中的命令行进行自动化测试验证，生成可执行测试脚本和结构化测试报告。当用户说"帮我测试文档中的命令"、"验证文档命令能否跑通"、"检测命令行是否有效"、"文档命令测试"、"doc cli test"、"命令行验证"、"check if commands work"、"validate doc commands"、"这篇文档的命令能跑吗"、"帮我跑一下文档里的命令"、"文档里的命令有没有问题"、"命令行能否执行"时触发。只要用户提供文档并希望验证其中命令的可执行性，就应触发本 skill。与 quick-start-writer（写文档）和 doc-quality-auditor（静态质量审查）配合，形成完整文档质量工作流的动态验证环节。
---

# doc-cli-tester

开发者文档中的命令行错误是用户流失的主要原因之一。本 skill 帮助你在发布前发现并修复文档中的命令行问题。

## 工作流程

### 第一步：获取文档

询问用户提供文档内容，支持以下方式：
- 直接粘贴 Markdown 文本
- 提供本地文件路径
- 提供文档 URL（如可访问）

### 第二步：提取命令块

从文档中提取所有代码块，重点关注：
- ` ```bash ` / ` ```sh ` / ` ```shell ` 块
- 无语言标注但明显是命令的代码块
- 行内命令（如 `` `dnf update -y` ``，当文档描述其为"执行以下命令"时）

**忽略**：纯粹的"预期输出"代码块（文档中标注为"Expected output"、"预期输出"的块，不需要执行）

### 第三步：命令分类

将提取的命令按可执行性分为五类：

| 类型 | 示例 | 测试方式 |
|------|------|----------|
| **只读命令** | `cat`、`lscpu`、`free -h`、`ip addr`、`uname -a` | 直接执行，验证退出码和输出格式 |
| **变更类命令** | `dnf update`、`systemctl enable`、`timedatectl set-timezone` | 在隔离环境（容器/快照）中执行，或用 `--dry-run` 模拟 |
| **交互式命令** | `nmtui`、`vim`、`top`、`htop` | 仅验证命令存在（`which <cmd>`） |
| **专有工具命令** | `bingo build`、`repo sync`、项目自定义 CLI | 验证工具是否存在（`which <tool>`），SKIP 实际执行并说明安装来源 |
| **不可自动化** | BIOS 操作、图形界面、需要硬件的步骤、iBMC 操作 | 标记为 SKIP，注明原因 |

**前置条件依赖**：命令语法正确，但依赖上一步骤产物（如 ISO 文件、构建产物、已运行的服务）时，标记为"待验证"并在测试脚本中用条件判断（`if [ -f xxx ]`）自动跳过，不算文档错误。

### 第四步：环境检测

在执行测试前，先检测当前环境是否与文档要求匹配：

```bash
# 检测 OS 类型和版本
cat /etc/os-release 2>/dev/null || uname -s

# 检测架构
uname -m

# 检测文档中提到的关键工具是否存在
# 例如文档要求 openEuler，但当前是 Ubuntu，需告知用户
```

如果环境不匹配，给出明确提示（如"当前为 macOS，部分命令无法验证，建议在 openEuler 24.03 LTS SP3 环境中运行"）并继续生成测试脚本。

### 第五步：生成测试脚本

生成一个名为 `test_<文档名>.sh` 的 bash 脚本，结构如下：

```bash
#!/bin/bash
# test_<docname>.sh — <文档标题> 命令行验证脚本
# 生成时间：<日期>
# 目标环境：<文档要求的OS/版本>
# 用法：bash test_<docname>.sh 2>&1 | tee test_report.log

PASS=0; FAIL=0; SKIP=0
RESULTS=()

run_test() {
    local id="$1" desc="$2" cmd="$3" expect_keyword="$4"
    echo "--- [TEST $id] $desc"
    echo "CMD: $cmd"
    output=$(eval "$cmd" 2>&1)
    code=$?
    if [ $code -ne 0 ]; then
        echo "FAIL (exit=$code): $output"
        FAIL=$((FAIL+1)); RESULTS+=("FAIL|$id|$desc|exit=$code")
    elif [ -n "$expect_keyword" ] && ! echo "$output" | grep -q "$expect_keyword"; then
        echo "FAIL (missing '$expect_keyword'): $output"
        FAIL=$((FAIL+1)); RESULTS+=("FAIL|$id|$desc|missing keyword")
    else
        echo "PASS"
        PASS=$((PASS+1)); RESULTS+=("PASS|$id|$desc|")
    fi
}

skip_test() {
    echo "--- [SKIP $1] $2 — $3"
    SKIP=$((SKIP+1)); RESULTS+=("SKIP|$1|$2|$3")
}

# === 测试用例（由 doc-cli-tester 自动生成）===
# ... 此处填充具体测试

# === 汇总 ===
echo ""
echo "========================================"
echo "PASS: $PASS  FAIL: $FAIL  SKIP: $SKIP  总计: $((PASS+FAIL+SKIP))"
echo "========================================"
```

每条 `run_test` 调用对应文档中一条命令，包含：
- 编号（对应文档章节，如 `4.2-1`）
- 描述（命令用途）
- 命令本身
- 期望输出中的关键字（可选，用于验证输出内容）

### 第六步：执行并输出测试报告

如果用户当前环境可以运行脚本，直接执行并收集结果。否则提示用户在目标环境中执行。

测试报告格式：

```
═══════════════════════════════════════════════
  <文档名> 命令行测试报告
═══════════════════════════════════════════════
文档：<文档名>
环境：<实际执行环境>
时间：<执行时间>
───────────────────────────────────────────────

一、测试概览
  PASS：X    FAIL：X    SKIP：X    总计：X

二、详细结果
  ✅ [4.2-1] cat /etc/os-release — PASS
  ❌ [4.3-1] lscpu — FAIL（命令不存在）
  ⏭ [2.1]   iBMC 操作 — SKIP（需要物理硬件）

三、失败项分析
  [编号] 命令：<cmd>
  - 实际输出：<output>
  - 根因：<分析>
  - 修复建议：<建议>（文档问题 or 环境问题）

四、文档改进建议
  - <具体建议，区分"文档写错了"和"环境不满足"两类>

五、结论
  □ 所有命令验证通过，文档可发布
  □ 存在以下问题需处理：<列表>
═══════════════════════════════════════════════
```

## 重要区分：文档问题 vs 环境限制

在输出报告时，务必区分两类失败：

- **文档问题**：命令语法错误、命令名写错、参数不对、预期输出与实际不符 → 需要修改文档
- **环境限制**：在 Docker 容器中运行 systemctl 失败、在 macOS 上运行 lscpu 失败 → 不需要修改文档，需要在正确环境中重测

不要把环境限制导致的失败判定为文档错误，这会误导文档作者。

## 报告归档

测试完成后，按以下结构归档，方便追溯和多次迭代对比：

```
doc-cli-tester-reports/
└── <文档名>/
    ├── <YYYY-MM-DD>/
    │   ├── test_<文档名>.sh       # 测试脚本
    │   ├── report.md              # 测试报告
    │   └── test_report.log        # 实际执行日志（脚本运行后生成）
    └── <YYYY-MM-DD>/              # 下次迭代
        ├── test_<文档名>.sh
        ├── report.md
        └── test_report.log
```

**归档位置**：默认保存到当前工作目录下的 `doc-cli-tester-reports/`。如用户指定了其他路径，以用户指定为准。

**命名规则**：
- 文档名取文件名去掉扩展名，或 URL 最后一段路径，如 `quick_start_new`、`build_your_own_bmc`
- 日期使用执行日期，格式 `YYYY-MM-DD`

**多次迭代时**：每次执行生成新的日期目录，不覆盖历史记录。报告开头注明"第 N 次验证"及与上次相比的变化（新增 PASS / 修复的 FAIL）。

## 与其他 skill 的协作

- 运行本 skill **之前**，建议先用 `quick-start-writer` 生成文档，再用 `doc-quality-auditor` 做静态质量审查
- 本 skill 专注**动态验证**，不评价文档结构、语言质量等静态维度
- 如发现文档质量问题（非命令问题），可提示用户使用 `doc-quality-auditor`
