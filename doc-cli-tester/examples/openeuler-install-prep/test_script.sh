#!/bin/bash
# test_openeuler_installation_preparations.sh — openEuler 安装准备命令行验证脚本
# 文档链接：https://docs.openeuler.openatom.cn/zh/docs/24.03_LTS_SP3/server/installation_upgrade/installation/installation_preparations.html
# 生成时间：2026-04-28
# 目标环境：已下载 openEuler 24.03 LTS SP3 ISO 及校验文件的 Linux/macOS 环境
# 用法：bash test_openeuler_installation_preparations.sh 2>&1 | tee test_report.log

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
echo "sha256sum: $(which sha256sum 2>/dev/null || echo '未找到（macOS 请用 shasum -a 256）')"
echo "gpg2: $(which gpg2 2>/dev/null || echo '未安装')"
echo "ISO 文件: $(ls openEuler-24.03-LTS-SP3-*.iso 2>/dev/null || echo '未找到（需先下载）')"
echo ""

# ============================================================
# sha256sum 校验 ISO（只读类 — 依赖 ISO 文件已下载）
# ============================================================
ISO_FILE="openEuler-24.03-LTS-SP3-aarch64-dvd.iso"
ISO_FILE_X86="openEuler-24.03-LTS-SP3-x86_64-dvd.iso"

if [ -f "$ISO_FILE" ]; then
    run_test "1-sha256-aarch64" \
        "sha256sum 校验 AArch64 ISO" \
        "sha256sum $ISO_FILE" \
        ""
elif [ -f "$ISO_FILE_X86" ]; then
    run_test "1-sha256-x86" \
        "sha256sum 校验 x86_64 ISO" \
        "sha256sum $ISO_FILE_X86" \
        ""
else
    skip_test "1-sha256" \
        "sha256sum openEuler-24.03-LTS-SP3-*.iso" \
        "依赖前置条件：需先从 openEuler 官网下载 ISO 文件"
fi

# ============================================================
# sha256sum 命令本身可用性（只读类）
# ============================================================
run_test "2-sha256sum-available" \
    "sha256sum 命令可用性检测" \
    "sha256sum --version 2>/dev/null || shasum --version" \
    ""

# ============================================================
# gpg2 签名验证（只读类 — 依赖 ISO 和 .asc 文件已下载）
# ============================================================
skip_test "3-gpg2" \
    "gpg2 --verify openEuler-24.03-LTS-SP3-*.iso.asc" \
    "依赖前置条件：需下载 ISO 和对应的 .asc 签名文件，并导入 openEuler GPG 公钥"

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
