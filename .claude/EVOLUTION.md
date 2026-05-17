# EVOLUTION.md — 进化系统

## 概述

本文档定义 Harness 进化的概念和层级，具体执行由两个 Sub-Agent 负责：

- **feedback-observer**: 记录用户反馈和经验教训（使用 feedback-writer skill）
- **evolution-runner**: 扫描 feedback 积累，生成进化建议（使用 evolution-engine skill）

## 进化路径

反馈积累路径，逐级递进：

### **第一层：经验积累**
用户给出修正或反馈时，主 Agent 派发 feedback-observer 记录。

### **第二层：规则毕业**
feedback 积累至 3 次，evolution-runner 提议升级为 Skill.md 或 CLAUDE.md 中的正式规则。

### **第三层：Skill 优化**
某 Skill 评分持续偏低，feedback 评分持续偏低 → evolution-runner 提议调整某 Skill。

### **第四层：Skill 自动诞生**
某操作模式反复出现（≥3 次）但无 Skill 覆盖 → evolution-runner 提议创建新 Skill。

## 用户体验

进化是渐进式的，不是打扰式的：

- **记录 feedback** → 无感（Sub-Agent 静默执行）
- **扫描与提议** → 无感（session 初始化时静默）
- **推荐调整某 Skill** → 弹窗提示，需用户确认才执行
- **展示演进过程** → 可选查看

## 相关文件

- `.claude/feedback/YYYY-MM-DD-<topic>.md` — 单条 feedback 记录
- `.claude/FEEDBACK-INDEX.md` — feedback 索引与快速加载
- `.claude/skills/evolution-engine/` — 进化引擎 skill
- `.claude/skills/feedback-writer/` — 反馈记录 skill
