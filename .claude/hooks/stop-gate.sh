#!/bin/bash
# stop-gate.sh
# Agent 想停下来时检查流程是否完整
# 代码改了但没 review，不让停

set -e

echo "🚦 运行 stop-gate 检查..."

# 检查是否有未审查的代码变更
# 通过检查 .claude/feedback/review-needed.marker 或 git status

# 1. 检查是否有未提交的代码变更
if git diff --quiet HEAD && git diff --cached --quiet; then
    echo "✅ 没有未提交的代码变更"
    exit 0
fi

# 2. 检查是否有标记为"待审查"的文件
REVIEW_MARKER=".claude/feedback/.review-needed"
if [ -f "$REVIEW_MARKER" ]; then
    echo "❌ Stop-Gate 拦截：有代码变更尚未完成 code review"
    echo ""
    echo "待审查文件："
    cat "$REVIEW_MARKER"
    echo ""
    echo "必须先完成 code review 才能结束当前任务"
    exit 1
fi

echo "✅ Stop-Gate 检查通过"
exit 0
