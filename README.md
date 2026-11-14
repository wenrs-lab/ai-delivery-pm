# AI 交付项目经理 · 程必达（ai-delivery-pm）

一个可直接安装到 WorkBuddy Agent 的**专家包**，附一套可独立使用的项目管理 Skill。

面向 AI / 大模型 / 数据平台类 **toB 客户交付项目**，覆盖立项到验收全流程：排期与里程碑、风险预警、问题闭环、需求变更管控、销售—产研协同、政企验收合规、复盘沉淀。

> 「不等汇报，主动发现；问题不过夜，责任要到人；纪律不是写在文档里，是让团队真的照着做。」

---

## 两种安装方式

### 方式 A：装成 WorkBuddy 专家（推荐）

专家包根就是本仓库根，克隆到专家目录即可：

```bash
git clone https://github.com/wenrs-lab/ai-delivery-pm.git \
  "$HOME/.workbuddy/plugins/marketplaces/my-experts/plugins/ai-delivery-pm"
```

或者用仓库自带的安装脚本（会一并写入 `marketplace.json`，无需手改）：

```bash
git clone https://github.com/wenrs-lab/ai-delivery-pm.git
cd ai-delivery-pm
./install.sh
```

安装完成后打开 **专家中心 → 我的专家**，找到「程必达 / AI 交付项目经理」即可开聊。

自定义 WorkBuddy 配置目录时：

```bash
WORKBUDDY_CONFIG_DIR=/path/to/config ./install.sh
```

`install.sh` **不会覆盖任何已存在的目录**；目标已存在时会报错退出，请先自行备份或改名。

### 方式 B：只装 Skill（不装专家）

只要那套可复用模板，把 `skills/ai-delivery-playbook` 放进你的技能目录即可：

```bash
# WorkBuddy 用户级技能
./install.sh --skill-only

# 或手动指定任意 agent 的 skills 目录，例如 Claude Code
./install.sh --skill-only --skill-dir "$HOME/.claude/skills"
```

### 方式 C：下载 ZIP

不方便用 git 时，直接下仓库 ZIP，解压后把目录改名为 `ai-delivery-pm`，放到方式 A 的路径下，再运行 `./install.sh` 完成注册。

---

## 试试这样问

- 我手上有个 AI 大模型客户交付项目，帮我搭一套从立项到验收的里程碑排期和风险清单
- 销售临时插入需求并对客户承诺了时间，帮我评估影响、给出变更管控和沟通话术
- 帮我做一次项目健康度巡检，输出问题分级、责任人、关闭期限和升级建议的跟踪表

---

## 专家能力

| 能力 | 说明 |
|------|------|
| 全流程进程管理 | 立项、WBS 排期、关键路径、里程碑跟踪、风险预警、验收交付；支持多项目并行 |
| 问题发现与解决闭环 | 主动巡检、P0–P3 分级定性、唯一责任人与关闭期限、逾期升级 |
| 执行纪律落地 | 交付流程规范、需求变更管理、会议与文档机制，判断标准是「团队是否真在做」 |
| 销售与产研接口 | 受理销售承诺、对齐优先级与排期、同步进展与风险，附带可直接使用的沟通话术 |
| 客户现场交付 | 客户侧进度沟通、内部资源协调、异常升级与决策推动 |
| 资产沉淀 | 项目模板、检查清单、复盘文档随项目迭代 |

方法论底座：PMP 体系、敏捷/瀑布/混合模式选型、政企与国央企验收审计合规、PMO 产研协同、Jira / 飞书项目看板。针对 AI 项目额外扫描数据到位、环境算力、模型效果指标可测量性、PoC 到生产落差、客户预期管理等特有风险。

---

## 附带的 7 份模板

`skills/ai-delivery-playbook/templates/`

| 模板 | 用途 |
|------|------|
| `project-charter-and-plan.md` | 立项、WBS 排期、里程碑、RACI、风险基线 |
| `health-check-checklist.md` | 十维度周度巡检、红黄绿判定、升级触发条件 |
| `issue-tracker.md` | 问题分级、闭环六步、逾期升级矩阵 |
| `change-request.md` | 变更影响评估、五种处置选项、对销售沟通话术 |
| `weekly-report.md` | 客户 / 销售 / 内部三视角周报 |
| `acceptance-checklist.md` | 验收交付物清单、政企审计与合规留痕 |
| `retrospective.md` | 偏差归因、决策回放、资产更新清单 |

全部模板统一 P0–P3 与红黄绿口径，任何事项都必须落到「责任人 + 期限 + 下一步」。

---

## 目录结构

```
ai-delivery-pm/
├── .codebuddy-plugin/plugin.json      # 专家清单（展示字段、分类、推荐提示词）
├── agents/ai-delivery-pm.md           # 专家人设、能力、工作流、输出规范
├── avatars/expert.png                 # 头像 512x512
├── skills/ai-delivery-playbook/
│   ├── SKILL.md                       # 资产库入口与统一口径
│   └── templates/                     # 7 份可复用模板
├── install.sh                         # 幂等安装脚本（不覆盖已有数据）
└── README.md
```

专家类型：`agent`（单角色）｜ 行业分类：`10-ProjectQuality`（项目质量）。

---

## 自定义

- 改人设、能力、工作流 → `agents/ai-delivery-pm.md`
- 改展示名、职业、标签、推荐提示词 → `.codebuddy-plugin/plugin.json`
- 改模板字段 → `skills/ai-delivery-playbook/templates/`
- 换头像 → 覆盖 `avatars/expert.png`（PNG/JPG，512×512，≤500KB）

改完 `plugin.json` 后，如果是在本机专家目录里改的，需重新运行注册脚本或 `./install.sh` 让市场清单刷新。

---

## 常见问题

**专家中心里看不到？**
确认目录确实是 `$HOME/.workbuddy/plugins/marketplaces/my-experts/plugins/ai-delivery-pm`，且 `.codebuddy-plugin/marketplace.json` 中存在 `ai-delivery-pm` 条目；然后重启 WorkBuddy 刷新专家列表。

**只想用模板，不想多一个专家？** 用 `./install.sh --skill-only`。

**Windows 能用吗？** `install.sh` 是 bash 脚本；Windows 建议用方式 C 手动放置目录，或用 Git Bash / WSL 运行脚本。

---

## License

本仓库尚未指定开源许可证，默认保留所有权利。如需明确再分发与使用条款，请以仓库根目录后续补充的 `LICENSE` 文件为准。
