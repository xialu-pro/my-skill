#!/bin/bash
# test_openubmc_build_bmc.sh — openUBMC《构建你的BMC》命令行验证脚本
# 文档链接：https://www.openubmc.cn/docs/zh/development/quick_start/build_your_own_bmc.html
# 生成时间：2026-04-28
# 目标环境：Linux（已完成 openUBMC 环境准备，已配置 SSH Key 到 GitCode）
# 用法：bash test_openubmc_build_bmc.sh 2>&1 | tee test_report.log

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
        echo "FAIL (missing '$expect_keyword' in output)"
        FAIL=$((FAIL+1)); RESULTS+=("FAIL|$id|$desc|missing keyword: $expect_keyword")
    else
        echo "PASS"
        PASS=$((PASS+1)); RESULTS+=("PASS|$id|$desc|")
    fi
    echo ""
}

skip_test() {
    echo "--- [SKIP $1] $2"
    echo "    原因: $3"
    SKIP=$((SKIP+1)); RESULTS+=("SKIP|$1|$2|$3")
    echo ""
}

# ============================================================
# 环境检测
# ============================================================
echo "========================================"
echo "环境检测"
echo "========================================"
echo "OS: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d= -f2 || uname -s)"
echo "架构: $(uname -m)"
echo "git: $(git --version 2>/dev/null || echo '未安装')"
echo "python3: $(python3 --version 2>/dev/null || echo '未安装')"
echo "bingo: $(which bingo 2>/dev/null || echo '未安装（需要 openUBMC 环境准备）')"
echo ""

# ============================================================
# 获取 manifest（变更类 — 需要 SSH Key + 网络）
# ============================================================
skip_test "1-clone" \
    "git clone git@gitcode.com:openUBMC/manifest.git" \
    "变更类：需要已配置 GitCode SSH Key 且网络可达；克隆会修改本地文件系统"

# ============================================================
# 整包构建（变更类 — 依赖 bingo 工具 + manifest 已存在）
# ============================================================
skip_test "2-build" \
    "cd /home/workspace/manifest && bingo build" \
    "变更类：依赖 bingo 工具（openUBMC 专有）和已克隆的 manifest 仓库，需在完整 openUBMC 开发环境中执行"

# ============================================================
# 仿真包构建（变更类 — 同上）
# ============================================================
skip_test "3-build-qemu" \
    "bingo build -sc qemu" \
    "变更类：依赖 bingo 工具，需在完整 openUBMC 开发环境中执行"

# ============================================================
# 验证构建产物（只读类 — 依赖前置步骤完成）
# ============================================================
run_test "4-check-output" \
    "ls 验证构建产物目录" \
    "ls /home/workspace/manifest/output/packet/inner 2>/dev/null" \
    ""
# 注：此命令仅在构建完成后有意义，当前环境大概率 FAIL 属正常

# ============================================================
# 启动仿真环境（变更类 — 需要 qemu 和仿真包）
# ============================================================
skip_test "5-start-qemu" \
    "python3 build/works/packet/qemu_shells/vemake_1711.py" \
    "变更类/交互式：启动 QEMU 仿真环境，需要仿真包已构建、qemu 已安装，且会占用终端"

# ============================================================
# 工具可用性检测（只读类 — 验证关键工具是否存在）
# ============================================================
run_test "6-check-git" \
    "git 命令可用性" \
    "git --version" \
    "git version"

run_test "7-check-python3" \
    "python3 命令可用性" \
    "python3 --version" \
    "Python"

run_test "8-check-bingo" \
    "bingo 工具可用性（openUBMC 专有工具）" \
    "which bingo" \
    "bingo"

# ============================================================
# 汇总
# ============================================================
echo "========================================"
echo "测试完成"
echo "PASS: $PASS  FAIL: $FAIL  SKIP: $SKIP  总计: $((PASS+FAIL+SKIP))"
echo "========================================"
echo ""
echo "详细结果："
for r in "${RESULTS[@]}"; do
    IFS='|' read -r status id desc reason <<< "$r"
    case $status in
        PASS) echo "  ✅ [$id] $desc" ;;
        FAIL) echo "  ❌ [$id] $desc ($reason)" ;;
        SKIP) echo "  ⏭  [$id] $desc — $reason" ;;
    esac
done
