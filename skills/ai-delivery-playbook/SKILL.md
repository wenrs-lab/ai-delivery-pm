---
name: ai-delivery-playbook
description: "Reusable project management assets for AI/LLM/data-platform toB delivery. Use when the user needs a project charter, milestone schedule, weekly health check, issue tracker, change request, status report, acceptance checklist or retrospective for a customer delivery project."
---

# AI 交付项目管理资产库

把每个项目的有效做法固化成可直接填的模板。所有模板服务于同一条主线：**基线 → 巡检 → 问题闭环 → 变更管控 → 同步升级 → 验收 → 复盘**。

## 使用原则

1. **先判断场景，再选模板**：不要在用户只问「这周项目有没有风险」时甩一整份立项书。
2. **字段不删减**：按模板字段输出，用户没给的信息标 `待确认`，并汇总成「需补齐清单」。
3. **结论先行**：模板之前先给一句判断（健康度、是否延期、是否升级、建议方案）。
4. **可落地优先**：每个事项必须落到 `责任人 + 期限 + 下一步`，没有责任人的条目不算闭环。
5. **事实 / 假设 / 建议分开标注**，不编造项目事实。

## 模板索引

| 触发场景 | 模板文件 |
|---------|---------|
| 新项目启动、排期、定里程碑、多项目并行排布 | `templates/project-charter-and-plan.md` |
| 周度巡检、项目健康度诊断、想知道「有没有漏掉什么」 | `templates/health-check-checklist.md` |
| 问题暴露、跨部门扯皮、逾期跟踪、升级 | `templates/issue-tracker.md` |
| 销售插需求、客户提新范围、对客承诺失控 | `templates/change-request.md` |
| 项目周报、对客户/销售/管理层同步进展 | `templates/weekly-report.md` |
| 准备验收、政企/国央企验收材料、交付物清点 | `templates/acceptance-checklist.md` |
| 项目结束、延期归因、沉淀经验 | `templates/retrospective.md` |

## 标准工作流

```
立项（charter-and-plan）
  → 每周巡检（health-check-checklist）
  → 红灯项登记（issue-tracker）
  → 范围/承诺变动（change-request）
  → 三视角同步（weekly-report）
  → 验收倒排（acceptance-checklist）
  → 复盘归档（retrospective，回写上述模板）
```

## 分级与三色口径（全模板统一）

| 项 | 定义 |
|----|------|
| 🟢 绿 | 按基线推进，无关键路径风险 |
| 🟡 黄 | 有偏差或依赖未到位，本周内可纠偏，需盯 |
| 🔴 红 | 已影响/将影响里程碑或验收，必须升级 |
| P0 | 阻塞验收或关键里程碑，当日升级至交付负责人与双方管理层 |
| P1 | 影响关键路径，24h 内定责任人与方案 |
| P2 | 局部可控，本周内关闭 |
| P3 | 观察项，登记不主动投入资源 |

## AI / 大模型项目专属检查点

巡检与排期时必须额外扫描，模板中已预留字段：

- 数据：交付时间、数据量与质量、标注进度、客户侧数据出域审批
- 环境：算力/GPU、模型 API 配额、内外网隔离、第三方服务稳定性
- 效果：验收指标是否可测量、基线值谁确认、调优轮次与失败预案
- 预期：PoC 效果 ≠ 生产效果，客户对「智能」的预期是否有书面边界
- 合规：模型备案、数据安全评估、日志与审计留痕（政企项目从立项倒排）
