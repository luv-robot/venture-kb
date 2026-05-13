是的，这是一个重要缺陷。原来的多 Agent 架构更像：

```text
发现信号 → 生成策略 → 风控 → 回测 → 复盘
```

但缺少一个全局市场状态层：

```text
现在是什么市场？
波动率是否异常？
趋势是否强？
流动性是否变差？
是否处在 crash / squeeze / chaos 环境？
哪些策略当前允许运行？
```

这个层不应该属于某一个具体策略，而应该像大型程序里的“全局上下文 / 全局变量 / runtime context”。

我建议新增一个核心模块：

```text
Market Context Engine
```

或更准确地叫：

```text
Global Market State Layer
```

它是所有策略、Agent、风控和调度系统共享的上层状态。

---

# 一、改进后的总架构

原架构：

```text
Market Scout
→ Strategy Researcher
→ Risk Auditor
→ Backtester
→ Reviewer
```

改成：

```text
Market Data
   ↓
Global Market State Engine
   ↓
Strategy Permission Layer
   ↓
Market Scout
   ↓
Strategy Researcher
   ↓
Risk Auditor
   ↓
Backtester / Paper Trading
   ↓
Reviewer
```

更完整一点：

```text
                         ┌────────────────────────┐
                         │ Global Market State     │
                         │ regime / vol / liquidity│
                         │ crowding / crash risk   │
                         └───────────┬────────────┘
                                     │
                                     ▼
┌──────────────┐          ┌────────────────────────┐
│ Market Data  │ ───────▶ │ Strategy Permission     │
└──────────────┘          │ enable / disable / size │
                          └───────────┬────────────┘
                                      │
                                      ▼
                              ┌──────────────┐
                              │ Market Scout │
                              └──────┬───────┘
                                     ▼
                              Strategy Researcher
                                     ▼
                                Risk Auditor
                                     ▼
                                 Backtester
                                     ▼
                                  Reviewer
```

核心变化是：

```text
策略不再自己判断市场环境；
策略必须读取统一的 Market Context。
```

---

# 二、新增 4 个全局层

## 1. Market Context Engine

负责计算全局市场状态。

输出：

```text
regime
trend_score
volatility_score
liquidity_score
crash_risk_score
crowding_score
correlation_score
chaos_score
```

它不生成交易信号，只生成“市场背景”。

---

## 2. Strategy Permission Layer

负责决定哪些策略当前允许运行。

例如：

```json
{
  "liquidity_sweep_reversal": "reduced",
  "vwap_fade": "disabled",
  "trend_trap_continuation": "enabled",
  "funding_crowding_fade": "watch_only"
}
```

它不是预测器，而是权限管理器。

---

## 3. Risk Budget Layer

负责根据市场环境动态调整风险预算。

例如：

```json
{
  "global_risk_multiplier": 0.4,
  "max_open_positions": 2,
  "max_strategy_risk": 0.0025,
  "allow_new_positions": true
}
```

在 crash / chaos regime 下，自动降仓或禁开新仓。

---

## 4. Context-Aware Reviewer

Reviewer 不只复盘策略，还要复盘：

```text
当时 Market Context 是否判断正确？
Strategy Permission 是否合理？
是否该禁用该策略？
是否误杀了有效策略？
```

这是非常关键的改进。

---

# 三、Market Context 应该包含什么

建议定义一个统一对象：

```text
GlobalMarketContext
```

它至少包含以下字段。

```python
from enum import Enum
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Dict, List, Optional


class MarketRegime(str, Enum):
    NORMAL = "normal"
    STRONG_TREND = "strong_trend"
    RANGE = "range"
    CRASH = "crash"
    SQUEEZE = "squeeze"
    CHAOS = "chaos"
    LOW_LIQUIDITY = "low_liquidity"


class StrategyPermission(str, Enum):
    ENABLED = "enabled"
    REDUCED = "reduced"
    WATCH_ONLY = "watch_only"
    DISABLED = "disabled"


class GlobalMarketContext(BaseModel):
    context_id: str
    created_at: datetime

    market: str = "crypto"
    benchmark_symbol: str = "BTC/USDT"

    regime: MarketRegime
    regime_confidence: float = Field(ge=0, le=1)

    trend_score: int = Field(ge=0, le=100)
    volatility_score: int = Field(ge=0, le=100)
    liquidity_score: int = Field(ge=0, le=100)
    crash_risk_score: int = Field(ge=0, le=100)
    squeeze_risk_score: int = Field(ge=0, le=100)
    crowding_score: int = Field(ge=0, le=100)
    chaos_score: int = Field(ge=0, le=100)
    correlation_score: int = Field(ge=0, le=100)

    global_risk_multiplier: float = Field(ge=0, le=1)

    strategy_permissions: Dict[str, StrategyPermission]

    notes: List[str] = []
```

这样每个信号都必须带上当时的全局上下文快照。

---

# 四、信号结构也要改

原来的 `MarketSignal` 只描述局部机会：

```json
{
  "symbol": "ETH/USDT",
  "signal_type": "liquidity_sweep_reversal",
  "rank_score": 84
}
```

改成：

```json
{
  "signal_id": "signal_001",
  "symbol": "ETH/USDT",
  "signal_family": "liquidity_sweep_reversal",
  "setup_score": 84,
  "trigger_score": 76,

  "context_id": "ctx_20260512_001",
  "regime": "strong_trend",
  "strategy_permission": "reduced",
  "risk_multiplier": 0.4,

  "allowed_to_trade": true,
  "reason": [
    "setup is valid",
    "but strong trend regime reduces reversal strategy size"
  ]
}
```

也就是说：

```text
信号分数 ≠ 最终交易权限
```

最终是否允许交易，要由：

```text
Signal Score
+ Global Market Context
+ Strategy Permission
+ Risk Budget
```

共同决定。

---

# 五、策略权限层的规则示例

这个文件建议放在：

```text
configs/strategy_permissions.yaml
```

示例：

```yaml
regime_rules:
  strong_trend:
    liquidity_sweep_reversal: reduced
    failed_breakout_punishment: reduced
    vwap_exhaustion_reversion: disabled
    trend_trap_continuation: enabled
    breakout_acceptance: enabled

  crash:
    liquidity_sweep_reversal: disabled
    failed_breakout_punishment: disabled
    trend_trap_continuation: reduced
    liquidation_cascade_reversal: watch_only
    liquidation_momentum_follow: enabled

  range:
    liquidity_sweep_reversal: enabled
    failed_breakout_punishment: enabled
    vwap_exhaustion_reversion: enabled
    trend_trap_continuation: reduced
    breakout_acceptance: disabled

  chaos:
    liquidity_sweep_reversal: disabled
    failed_breakout_punishment: disabled
    vwap_exhaustion_reversion: disabled
    trend_trap_continuation: disabled
    breakout_acceptance: disabled

risk_multipliers:
  normal: 1.0
  strong_trend: 0.7
  range: 1.0
  crash: 0.3
  squeeze: 0.5
  chaos: 0.0
  low_liquidity: 0.4
```

重点是：

```text
Regime 层优先做减法，不优先做加法。
```

---

# 六、Market Context Engine 的数据来源

它应该使用跨策略共享数据，不应依赖某个策略的局部逻辑。

## 1. 价格路径数据

用于判断趋势和方向性。

```text
tick velocity
path efficiency
directional persistence
pullback depth
new high / new low rate
breakout acceptance
```

## 2. 波动率数据

用于判断波动环境。

```text
realized volatility
intraday range percentile
volatility expansion
volatility compression
ATR percentile
price jump frequency
```

## 3. 流动性数据

用于判断执行风险。

```text
spread
top-of-book depth
orderbook depth
slippage estimate
trade impact
liquidity gap
```

## 4. 杠杆拥挤数据

用于判断强平和 squeeze 风险。

```text
OI percentile
OI change
funding percentile
basis
long/short ratio
liquidation heatmap proximity
```

## 5. 市场相关性数据

用于判断系统性风险。

```text
BTC/ETH correlation
altcoin correlation
cross-symbol drawdown
market breadth
risk-on / risk-off synchronization
```

## 6. 链上和资金流数据

用于中低频背景判断。

```text
exchange inflow
exchange outflow
stablecoin inflow
whale transfer
wallet concentration change
```

---

# 七、建议新增的 Agent / Service

原来五个 Agent 不够，现在建议新增两个“全局服务”。

## 1. Market Context Agent

职责：

```text
定期计算 GlobalMarketContext
识别当前 market regime
输出全局风险评分
写入数据库
```

它不参与策略生成，不给交易建议。

---

## 2. Permission Agent

职责：

```text
读取 GlobalMarketContext
读取策略家族规则
输出每个策略当前权限
输出全局 risk multiplier
```

它也不生成交易信号，只做权限控制。

---

# 八、改进后的 Agent 分工

```text
Market Context Agent
→ 判断市场环境

Permission Agent
→ 判断策略是否允许运行

Market Scout
→ 在允许范围内发现局部机会

Strategy Researcher
→ 根据信号和上下文生成策略

Risk Auditor
→ 审查策略代码和风险规则

Backtest Specialist
→ 按上下文分组回测

Reviewer Agent
→ 复盘策略结果和上下文判断
```

注意：

```text
Market Scout 不应该独立决定交易方向。
```

它只应该输出：

```text
这里有局部机会。
```

是否可交易，要看全局上下文。

---

# 九、回测也必须按 Context 分桶

这是非常重要的改进。

原来回测只看策略总体表现：

```text
profit_factor
max_drawdown
win_rate
```

现在必须看：

```text
不同 regime 下表现如何？
```

例如：

```json
{
  "strategy_family": "liquidity_sweep_reversal",
  "overall_profit_factor": 1.28,
  "by_regime": {
    "range": {
      "profit_factor": 1.65,
      "win_rate": 0.57
    },
    "strong_trend": {
      "profit_factor": 0.72,
      "win_rate": 0.31
    },
    "crash": {
      "profit_factor": 0.48,
      "win_rate": 0.22
    }
  }
}
```

然后系统自动得出：

```text
liquidity_sweep_reversal 在 range regime 启用；
在 strong_trend 降权；
在 crash 禁用。
```

这才是 regime 层真正的价值。

---

# 十、Reviewer 要新增两个复盘维度

原 Reviewer 只复盘策略：

```text
为什么这笔策略成功/失败？
```

现在要增加：

```text
1. 当时的 Market Context 是否正确？
2. 当时的 Strategy Permission 是否正确？
```

ReviewCase 应该扩展：

```python
class ContextReview(BaseModel):
    case_id: str
    signal_id: str
    strategy_id: str
    context_id: str

    strategy_result: str
    regime_at_entry: str
    permission_at_entry: str

    context_was_correct: bool
    permission_was_correct: bool

    failure_source: str
    # strategy_logic_error
    # regime_detection_error
    # permission_error
    # execution_error
    # data_quality_error

    lesson: str
```

这样你才能知道亏损到底来自哪里：

```text
策略错了？
市场状态判断错了？
权限层没禁用？
执行滑点太大？
数据延迟？
```

---

# 十一、数据库表也要改

建议新增：

```text
market_contexts
strategy_permissions
context_reviews
regime_backtest_stats
```

## market_contexts

存储每次全局状态快照。

```text
context_id
created_at
regime
trend_score
volatility_score
liquidity_score
crash_risk_score
chaos_score
global_risk_multiplier
raw_features
```

## strategy_permissions

存储策略权限快照。

```text
context_id
strategy_family
permission
risk_multiplier
reason
```

## regime_backtest_stats

存储策略按 regime 分桶后的表现。

```text
strategy_family
regime
trade_count
win_rate
profit_factor
max_drawdown
avg_return
avg_holding_time
```

---

# 十二、文档结构也要新增

建议新增这些文档：

```text
docs/
├── market_context.md
├── strategy_permission_layer.md
├── regime_definitions.md
├── volatility_policy.md
├── liquidity_policy.md
├── risk_budget_policy.md
└── context_review.md
```

其中最重要的是：

```text
market_context.md
strategy_permission_layer.md
risk_budget_policy.md
```

---

# 十三、MVP 后优先改造顺序

不要一次做太复杂。我建议按这个顺序改。

## Phase A：增加 GlobalMarketContext 数据模型

先只定义数据结构，不急着做复杂判断。

```text
MarketRegime
GlobalMarketContext
StrategyPermission
RiskBudget
```

---

## Phase B：做最简单的 Context Engine

只输出四类：

```text
NORMAL
STRONG_TREND
CRASH
CHAOS
```

先不要做十几种 regime。

---

## Phase C：加入 Strategy Permission Layer

只做禁用和降权。

```text
enabled
reduced
disabled
```

不要一开始做复杂仓位优化。

---

## Phase D：让所有 Signal 绑定 context_id

以后每一个信号都能追溯：

```text
这个信号出现时，市场环境是什么？
```

---

## Phase E：回测按 regime 分桶

这是最关键的验证步骤。

你要知道：

```text
每个策略在哪种环境赚钱，在哪种环境亏钱。
```

---

## Phase F：Reviewer 复盘 Context 判断

长期积累：

```text
哪些 regime 判断经常误判？
哪些策略经常在某种 regime 失效？
```

---

# 十四、改造后的核心原则

你现在的平台应该从：

```text
Signal-driven platform
信号驱动平台
```

升级为：

```text
Context-aware strategy platform
上下文感知型策略平台
```

也就是：

```text
先判断全局环境；
再决定哪些策略可运行；
再让 Scout 找局部机会；
最后由风控和执行层落地。
```

这会显著减少多 Agent 各自为政的问题。

---

# 十五、一句话总结

你原来的架构缺少“全局市场上下文层”。

正确改法是新增：

```text
Global Market State Layer
+ Strategy Permission Layer
+ Risk Budget Layer
+ Context-Aware Reviewer
```

它们分别回答：

```text
现在是什么市场？
哪些策略允许运行？
允许用多大风险？
这次失败到底是策略错了，还是市场状态判断错了？
```

最关键的设计思想是：

```text
Regime、波动率、流动性、拥挤度不是某个策略的私有变量；
它们是全系统共享的运行时上下文。
```

这会让你的量化平台从“多 Agent 堆叠”进化成真正的“量化研究操作系统”。