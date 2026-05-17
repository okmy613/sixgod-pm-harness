# 六神产品助理

基于 Claude Code Skill + Hook 的 Agent Harness 框架，面向产品开发全流程。

## 这是什么

一套让 AI 从"聊天写代码"升级为可靠产品开发系统的工作流框架。核心思路是 **Harness Engineering** —— 不是优化你怎么跟 AI 说话，而是搭建一整套约束、引导和反馈机制：

- **前馈控制（Guides）**：8 个 Skill 定义方法论和验收标准，Agent 动手之前就知道该怎么做
- **反馈控制（Sensors）**：Hooks + 两阶段 Code Review，行动之后自动检查、发现偏差、触发修正
- **进化系统（Steering Loop）**：每次修正自动记录，同类反馈出现 3 次以上升级为正式规则，让 Harness 越用越好

## 架构概览

```
CLAUDE.md（调度层）
  → 8 个 Skill（引导层）
  → 4 个 Sub-Agent（执行层，上下文防火墙）
  → 6 个 Hook + Review 闭环（检查层）
  → Evolution + Feedback（进化层）
```

## 8 个阶段

| 阶段 | Skill | 职责 |
|------|-------|------|
| 1 | product-spec-builder | 需求收集，模糊想法 → 结构化 Spec |
| 2 | design-brief-builder | 设计规范，视觉方向量化 |
| 3 | design-maker | 设计图制作（MCP 连接设计工具） |
| 4 | dev-planner | 开发计划，Phase 拆分 + 技术调研 |
| 5 | dev-builder | 项目开发，Task 级编码 + 编译验证 |
| 6 | bug-fixer | 四阶段系统性调试 |
| 7 | code-review | 两阶段审查（功能合规 + 代码质量） |
| 8 | release-builder | 构建发布 |

## 快速开始

```bash
# 1. 克隆模板到新建项目
cp -r sixgod-pm-harness/.claude ./your-project/.claude

# 2. 在项目根目录启动 Claude Code
cd your-project
claude

# 3. AI 自动加载 CLAUDE.md，开始项目进度检测
#    按流程推进：需求 → 设计 → 计划 → 开发 → 审查 → 发布
```

## 核心设计

- **设计图最高权威**：有设计图时一切 UI 以设计图为准
- **编译即门槛**：commit 前自动编译检查，不过不提交
- **代码必须审查**：写完必须过两阶段 review，不审查不让停
- **跨 Session 接续**：DEV-PLAN 是进度锚点，每次新开对话重读文档
- **上下文防火墙**：每个 Task 用全新 Sub-Agent 实例，防止错误假设传播

## 文件结构

```
.claude/
├── CLAUDE.md              # 主控调度
├── EVOLUTION.md           # 进化规则
├── settings.json          # 配置注册表
├── agents/                # Sub-Agent 定义
├── skills/                # 11 个 Skill
├── hooks/                 # 自动化脚本
└── feedback/              # 经验教训记录
```

## 版本

v1.0.0 — 基础框架，核心链路：需求收集 → 开发计划 → 编码实现 → 代码审查

## 参考

基于 [毒舌产品经理](https://github.com/okmy613/sixgod-pm-harness) 理念构建。
