你的判断基本对：**目前知名 Agent 框架都不能直接承担你说的 harness 能力**。  
它们能帮你做“Agent 执行”，但你要的是：

```text
研究系统的自主推进层
```

这更像：

```text
Research OS Control Plane
```

而不是普通 multi-agent workflow。

---

## 1. 为什么现成框架不太合适？

现有框架大多解决的是：

```text
给定一个任务 → Agent 调工具 → 生成结果
```

但你的 harness 要解决的是：

```text
没有明确任务时，系统如何根据历史研究资产，主动提出下一批任务？
```

这两者不是一类问题。

例如，LangGraph 强项是持久化执行、human-in-the-loop 和状态检查点；官方文档也强调 durable execution 可以在长流程中保存进度、暂停后恢复，适合人工校验和长任务恢复。([LangChain 文档](https://docs.langchain.com/oss/python/langgraph/durable-execution?utm_source=chatgpt.com "Durable execution - Docs by LangChain"))  
Prefect 强项是 Python workflow、task 状态、retry、cache 和观测；它适合调度实验，而不是决定“应该做什么实验”。([docs.prefect.io](https://docs.prefect.io/v3/how-to-guides/workflows/retries?utm_source=chatgpt.com "How to automatically rerun your workflow when it fails"))  
CrewAI、AutoGen 更偏多 Agent 协作和任务执行；CrewAI 文档强调 agents、crews、flows、memory、observability，AutoGen 是用于构建 AI agents/applications 的框架。([CrewAI](https://docs.crewai.com/?utm_source=chatgpt.com "CrewAI Documentation - CrewAI"))

所以更准确的分工是：

```text
LangGraph / CrewAI / AutoGen：Agent 运行时，可选
Prefect：实验执行调度
Postgres：研究状态与任务系统
Qdrant / Chroma：案例检索
你自建的 Harness Core：研究意图、任务生成、优先级、证据评分、淘汰机制
```

---

# 2. Harness 应该自建“薄控制层”

不要从一开始就写一个庞大 Agent 框架。  
我建议自建一个很薄但结构清楚的控制层：

```text
app/harness/
├── planner.py
├── backlog.py
├── evidence.py
├── task_generator.py
├── priority.py
├── experiment_router.py
├── finding_analyzer.py
├── governance.py
└── digest.py
```

它的核心不是 LLM，而是几个持久化对象：

```text
ResearchTask
ExperimentRun
ResearchFinding
EvidenceScore
DecisionRecord
```

LLM 只在其中几个节点参与：

```text
提出假设
解释失败
生成实验矩阵
写研究简报
```

其他部分尽量规则化、数据化、可审计。

---

# 3. 最小可行 Harness 架构

```text
┌──────────────────────┐
│ Research Artifact DB  │
│ backtests / reviews   │
│ optimizer / MC / paper │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│ Evidence Builder      │
│ 聚合证据与异常         │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│ Research Planner      │
│ 生成研究假设与任务      │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│ Priority Engine       │
│ 计算任务优先级         │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│ Experiment Router     │
│ 调用 Prefect flows     │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│ Finding Analyzer      │
│ 解释结果并更新 backlog │
└──────────────────────┘
```

这里 Prefect 只负责“跑实验”；Harness 负责“决定跑什么”。

---

# 4. 核心设计：ResearchTask 是系统的原子单位

不要让 AI 输出散文建议。  
所有自主性都必须落成 `ResearchTask`。

```python
from enum import Enum
from datetime import datetime
from typing import Any, Dict, List, Optional
from pydantic import BaseModel, Field


class ResearchTaskType(str, Enum):
    STRATEGY_VARIANT = "strategy_variant"
    ABLATION_TEST = "ablation_test"
    BASELINE_TEST = "baseline_test"
    PARAMETER_SENSITIVITY = "parameter_sensitivity"
    WALK_FORWARD_TEST = "walk_forward_test"
    MONTE_CARLO_TEST = "monte_carlo_test"
    REGIME_BUCKET_TEST = "regime_bucket_test"
    STRESS_TEST = "stress_test"
    FAILURE_ANALYSIS = "failure_analysis"
    DATA_FEATURE_TEST = "data_feature_test"


class ResearchTaskStatus(str, Enum):
    PROPOSED = "proposed"
    APPROVED = "approved"
    RUNNING = "running"
    COMPLETED = "completed"
    REJECTED = "rejected"
    RETIRED = "retired"


class ResearchTask(BaseModel):
    task_id: str
    created_at: datetime

    task_type: ResearchTaskType
    strategy_family: Optional[str] = None
    strategy_id: Optional[str] = None

    hypothesis: str
    rationale: str

    input_artifacts: List[str]
    required_experiments: List[Dict[str, Any]]

    success_metrics: List[str]
    failure_conditions: List[str]

    estimated_cost: float = 0.0
    priority_score: int = Field(ge=0, le=100)

    status: ResearchTaskStatus = ResearchTaskStatus.PROPOSED
```

这样系统生成的每个想法都可执行、可拒绝、可复盘。

---

# 5. Evidence Builder：先用规则，不要一开始靠 LLM

Harness 最重要的输入不是“灵感”，而是证据。

Evidence Builder 每天扫描：

```text
策略表现下滑
某 regime 连续亏损
参数敏感性过高
paper 与 backtest 偏离
某类失败案例聚集
某策略样本不足
某策略错过大量机会
某数据字段可能有增益
```

输出结构化 `EvidencePack`：

```python
class EvidencePack(BaseModel):
    evidence_id: str
    created_at: datetime
    scope: str
    # strategy_family / strategy_id / regime / data_feature

    observations: List[str]
    metrics: Dict[str, Any]
    anomalies: List[str]

    suggested_task_types: List[ResearchTaskType]
    severity_score: int = Field(ge=0, le=100)
    opportunity_score: int = Field(ge=0, le=100)
```

示例：

```json
{
  "scope": "liquidity_sweep_reversal",
  "observations": [
    "Profit factor in range regime is 1.61.",
    "Profit factor in strong_trend regime is 0.74.",
    "Most losses cluster after trend_score > 82."
  ],
  "suggested_task_types": [
    "REGIME_BUCKET_TEST",
    "ABLATION_TEST"
  ],
  "severity_score": 78,
  "opportunity_score": 84
}
```

这一步不需要 LLM，也不应该依赖 LLM。

---

# 6. Research Planner：LLM 只负责“把证据转成实验”

LLM 的输入应该是 EvidencePack，不是全量数据库。

Prompt contract：

```text
You are Research Harness Planner.

Given the EvidencePack, generate 1-5 executable ResearchTasks.

Rules:
- Do not suggest live trading.
- Do not generate vague ideas.
- Every task must include hypothesis, experiment design, success metrics, and kill criteria.
- Prefer small falsifiable experiments.
- Do not exceed the provided compute budget.
- Output JSON only.
```

输出必须通过 Pydantic 校验。

如果校验失败：

```text
LLM_TASK_INVALID
```

不进入 backlog。

---

# 7. Priority Engine：不要让 LLM 排优先级

优先级最好由规则算，避免 LLM 每天心血来潮。

可以用：

```text
priority_score =
  0.30 * opportunity_score
+ 0.25 * severity_score
+ 0.20 * evidence_strength
+ 0.15 * novelty_score
- 0.10 * estimated_cost
- 0.10 * duplication_penalty
```

其中：

```text
opportunity_score：潜在收益/改进空间
severity_score：当前问题严重性
evidence_strength：样本数、显著性、跨 regime 稳定性
novelty_score：是否探索新方向
estimated_cost：回测/LLM/数据成本
duplication_penalty：是否重复已有任务
```

LLM 可以解释排序，但不要决定排序。

---

# 8. Experiment Router：用 Prefect 执行

这里用 Prefect 很合适，因为它能组织 flow/task、记录状态、重试失败任务。Prefect 文档说明 task 可以配置 retries、delay、cache，且 task 状态和元数据会被记录。([docs.prefect.io](https://docs.prefect.io/v3/how-to-guides/workflows/retries?utm_source=chatgpt.com "How to automatically rerun your workflow when it fails"))

Router 根据 task_type 调对应 flow：

```python
TASK_FLOW_MAP = {
    "ablation_test": "run_ablation_flow",
    "parameter_sensitivity": "run_optimizer_flow",
    "monte_carlo_test": "run_monte_carlo_flow",
    "regime_bucket_test": "run_regime_bucket_flow",
    "stress_test": "run_stress_test_flow",
}
```

Harness 不直接跑回测，只发任务。

---

# 9. Finding Analyzer：把实验结果转成行动建议

实验跑完后，Finding Analyzer 读取结果，输出：

```python
class ResearchFinding(BaseModel):
    finding_id: str
    task_id: str
    created_at: datetime

    summary: str
    evidence: Dict[str, Any]

    conclusion: str
    confidence: float = Field(ge=0, le=1)

    recommended_action: str
    # continue_research / modify_strategy / retire_strategy
    # run_more_tests / promote_to_watchlist / request_human_review

    follow_up_tasks: List[str] = []
```

例如：

```json
{
  "conclusion": "Trend filter improves drawdown but reduces event profit factor by 9%, within acceptable threshold.",
  "recommended_action": "modify_strategy",
  "confidence": 0.74,
  "follow_up_tasks": [
    "test trend_score thresholds 75/80/85 on hidden replay set"
  ]
}
```

这一步可以使用 LLM 解释，但结论必须绑定指标。

---

# 10. Governance：防止 Harness 乱跑

你要的是“推动你”，不是“烧钱乱试”。

所以必须有 hard budget：

```yaml
harness_budget:
  max_research_tasks_per_day: 20
  max_auto_approved_tasks_per_day: 8
  max_backtest_runs_per_day: 200
  max_optimizer_runs_per_day: 20
  max_llm_calls_per_day: 50
  max_compute_cost_per_day_usd: 20
```

权限分级：

```text
自动允许：
- baseline test
- ablation test
- regime bucket report
- parameter sensitivity
- Monte Carlo

需要人工批准：
- 新增数据源
- 新增策略家族
- 大规模 optimizer
- paper trading 晋级
- capital allocation
- 对外发布结论
```

---

# 11. 现成框架该怎么用？

我的建议不是完全不用，而是只用它们的长处。

## Prefect

用作：

```text
实验执行引擎
批处理调度
回测 / optimizer / Monte Carlo / report flow
```

## LangGraph

如果你有复杂的“人审—暂停—恢复—多步骤 Agent 状态”，可以局部使用。LangGraph 的官方定位包括 durable execution、persistence、human-in-the-loop 和状态检查点，适合长流程 Agent 状态管理。([LangChain 文档](https://docs.langchain.com/oss/python/langgraph/durable-execution?utm_source=chatgpt.com "Durable execution - Docs by LangChain"))

适合放在：

```text
Research Planner
Finding Analyzer
Human Review Queue
```

但不要让 LangGraph 管整个量化平台。

## CrewAI / AutoGen

适合做原型，不适合作为你的核心研究操作系统。CrewAI 强调 multi-agent orchestration、agents/crews/flows；AutoGen 是 agentic AI 应用框架，但你这里的核心需求不是“Agent 聊天协作”，而是可审计的研究任务生命周期。([CrewAI](https://docs.crewai.com/?utm_source=chatgpt.com "CrewAI Documentation - CrewAI"))

---

# 12. 最推荐技术栈

```text
Postgres：ResearchTask / Finding / Evidence / DecisionRecord
Prefect：实验执行 flow
FastAPI：Harness API
Pydantic：所有任务和结果契约
Qdrant/Chroma：失败案例与研究报告检索
LLM API：只用于 Planner / Analyzer / Digest
n8n：人工审批与通知
```

不要一开始引入复杂 Agent 框架。

---

# 13. 最小 MVP 实现顺序

## Step 1：建 ResearchTask 表

先让系统能保存任务。

```text
research_tasks
research_findings
evidence_packs
decision_records
```

## Step 2：写 Evidence Builder

先做 5 个规则：

```text
策略在某 regime 下 PF < 1
paper 与 backtest 偏离
参数敏感性过高
某失败模式出现次数上升
某策略样本不足
```

## Step 3：LLM Planner

输入 EvidencePack，输出 ResearchTask。

## Step 4：Backlog UI / Markdown Report

每天输出：

```text
今日新增任务
高优先级任务
需要人工审批的任务
已完成任务
建议暂停方向
```

## Step 5：Experiment Router 接 Prefect

自动跑低风险任务。

## Step 6：Finding Analyzer

把结果写成 ResearchFinding。

## Step 7：Weekly Research Digest

每周给你一份：

```text
本周系统学到了什么
哪些假设被证伪
哪些方向值得继续
哪些策略应该退休
下周最重要 5 个实验
```

---

# 14. Harness 的核心不是框架，而是数据库状态机

你要记住这一点：

```text
真正的 Harness = 研究状态机 + 证据系统 + 任务队列 + 实验执行 + 发现归档
```

LLM 是其中的推理插件，不是系统主体。

如果把它做成“几个 Agent 互相聊天”，很快会失控。  
如果把它做成“证据驱动的研究任务系统”，它会越来越强。

---

# 15. 一句话架构

```text
Evidence Builder 发现研究机会；
LLM Planner 把机会转成可执行任务；
Priority Engine 排序；
Prefect Runner 执行；
Finding Analyzer 解释结果；
Backlog 推动下一轮研究；
你只审批关键节点。
```

这就是你需要的 harness 能力。

最终目标不是“AI 自动想一切”，而是：

```text
AI 每天把值得你判断的问题缩小到 3-5 个，
其余低风险研究自动推进。
```