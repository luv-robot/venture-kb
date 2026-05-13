是的，你这个判断非常关键。  
当前这种评价方式：

```text
运行一段时间
→ 做蒙特卡洛
→ 和 baseline 策略比较
→ 判断是否优劣
```

对低频高回报策略确实不公平，甚至是毁灭性的。

因为它默认策略应该像普通 CTA、均值回归、网格或日内策略一样：

```text
持续产生交易
持续产生样本
持续贡献收益
```

但 punishment 类策略，尤其是：

```text
Liquidity Sweep Reversal
Liquidation Cascade Reversal
Event Overreaction Fade
Narrative Crowding Fade
Whale Liquidation Pressure
```

本质上是：

```text
低频事件策略
等待极少数高质量错误/被迫流动性事件
平时不交易就是正确行为
```

如果用“单位时间收益”去评价它，很容易得出错误结论：

```text
这个策略交易太少
收益不稳定
蒙特卡洛样本不足
不如 baseline
```

但实际上它可能是一个很有价值的“尾部机会捕捉器”。

---

# 一、问题本质：策略类型不同，不能用同一套评价框架

你现在的平台需要把策略分成几类评价，而不是统一比较。

建议至少分成四类：

```text
1. Continuous Alpha
连续型策略

2. Event-Driven Alpha
事件型策略

3. Tail / Crisis Alpha
尾部风险机会策略

4. Defensive / Permission Strategy
防御型或权限型策略
```

不同策略的目标函数不一样。

---

## 1. Continuous Alpha

例如：

```text
VWAP reversion
日内均值回归
短线趋势延续
做市类策略
```

评价重点：

```text
日均收益
交易频率
Sharpe
最大回撤
稳定性
容量
```

这类策略适合用运行时间窗口评价。

---

## 2. Event-Driven Alpha

例如：

```text
流动性扫单反转
假突破惩罚
funding 拥挤反转
事件过度反应
```

评价重点不应是“每天赚多少”，而是：

```text
事件发生时是否有 edge
触发质量是否稳定
不交易时是否正确
单位事件收益是否优秀
```

---

## 3. Tail / Crisis Alpha

例如：

```text
强平瀑布回补
瀑布顺势出清
巨鲸清算压力
极端拥挤反转
```

这类策略可能一个月不出手，但在极端行情中贡献大量收益。

评价重点：

```text
危机窗口表现
尾部行情捕捉能力
是否避免错误抄底
是否在极端环境中保护组合
```

---

## 4. Defensive / Permission Strategy

例如：

```text
Regime Permission Layer
Crash Regime Filter
Volatility Risk Filter
Liquidity Risk Filter
```

这类模块可能不直接赚钱，但可以减少亏损。

评价重点：

```text
是否减少大回撤
是否降低错误交易数
是否改善收益分布左尾
是否减少连续亏损
```

不能用普通策略收益评价它。

---

# 二、低频高回报策略应该用“事件样本”评价，而不是“时间样本”评价

这是最重要的改造。

不要问：

```text
这个策略过去 30 天赚了多少？
```

而要问：

```text
过去 N 次符合 setup 的事件中，它表现如何？
```

也就是从：

```text
time-based evaluation
```

改成：

```text
event-based evaluation
```

---

## 错误评价方式

```text
策略运行 30 天
只交易 3 次
收益不显著
低于 baseline
淘汰
```

## 正确评价方式

```text
过去 500 次 liquidity sweep setup 中
策略触发 120 次
其中 62 次盈利
平均盈亏比 2.1
profit factor 1.55
极端行情中表现优于 baseline
保留
```

关键是：

```text
评价单位不是时间，而是机会事件。
```

---

# 三、建议新增 Strategy Evaluation Type

每个策略家族必须声明自己的评价类型。

```yaml
strategy_family: liquidity_sweep_reversal
evaluation_type: event_driven
min_event_count: 200
min_trade_count: 80
primary_metric: event_profit_factor
secondary_metrics:
  - hit_rate
  - reward_risk_ratio
  - adverse_excursion
  - missed_opportunity_cost
```

不同策略使用不同评价方法。

---

# 四、低频策略的评价指标应该换一套

对于低频高回报策略，不建议把 Sharpe 放在核心位置。  
Sharpe 对低频、偏态、肥尾策略经常误导。

应该重点看：

```text
1. Event Hit Rate
2. Event Profit Factor
3. Payoff Skew
4. Average R Multiple
5. Max Adverse Excursion
6. Conditional Return
7. Tail Contribution
8. Opportunity Capture Rate
9. False Positive Cost
10. False Negative Cost
```

---

## 1. Event Hit Rate

不是普通胜率，而是：

```text
在符合 setup 的事件中，触发后盈利的比例。
```

例如：

```text
setup_count = 300
trigger_count = 110
winning_trades = 58
event_hit_rate = 58 / 110 = 52.7%
```

---

## 2. Event Profit Factor

只在事件窗口内计算：

```text
event_profit_factor = gross_profit_during_events / gross_loss_during_events
```

这比全时间 Sharpe 更合理。

---

## 3. Payoff Skew

低频策略通常靠少数大赢家。

要看：

```text
平均盈利 / 平均亏损
最大盈利 / 平均亏损
收益分布偏度
top 5% trades contribution
```

如果一个策略 60% 收益来自少数几个事件，不一定坏。  
对事件策略来说，这可能正是它的设计目标。

---

## 4. Average R Multiple

把每笔交易标准化成风险单位：

```text
R = trade_pnl / initial_risk
```

例如：

```text
+2.5R
-1.0R
+4.0R
-0.7R
```

然后比较：

```text
average_R
median_R
R_distribution
```

这比直接比较收益率更公平。

---

## 5. Max Adverse Excursion

看入场后最大不利波动。

对于 sweep reversal 很重要。

```text
如果策略最终赚钱，但经常先浮亏 3R，
说明入场 timing 很差。
```

评价：

```text
MAE median
MAE 90 percentile
MAE / final R
```

---

## 6. Conditional Return

只在特定上下文中评价。

例如：

```text
return | regime = range
return | regime = crash
return | OI_percentile > 80
return | funding_extreme = true
return | key_level_score > 85
```

低频策略必须按条件分桶。

---

## 7. Tail Contribution

看策略是否在极端行情中贡献收益。

```text
top volatility days pnl
crash regime pnl
liquidation cascade pnl
market drawdown days pnl
```

如果一个策略平时不动，但在市场大跌时赚钱，它的组合价值很高。

---

## 8. Opportunity Capture Rate

低频策略还要评价“该出手时有没有出手”。

```text
capture_rate = triggered_events / qualified_events
```

太低说明过度保守。  
太高说明过滤不够严格。

---

## 9. False Positive Cost

错误触发的代价。

```text
不该做却做了，亏多少？
```

对低频策略很重要，因为它不应该频繁乱动。

---

## 10. False Negative Cost

错过好机会的代价。

```text
该做却没做，错过多少？
```

这能帮助调整过滤器是否过严。

---

# 五、Baseline 也要分类，不能随便比

低频策略不应该和高频 baseline 或 buy-and-hold 直接比较。

比如：

```text
Liquidity Sweep Reversal
```

不应该简单对比：

```text
BTC buy and hold
```

或：

```text
1h momentum baseline
```

因为目标不同。

应该设计对应 baseline。

---

## 低频事件策略的 baseline

推荐几类：

### Baseline 1：No Trade

```text
不交易
```

先证明策略比不交易好。

### Baseline 2：Naive Event Entry

例如：

```text
只要发生 sweep 就入场
```

看你的复杂评分是否真的改善了结果。

### Baseline 3：Randomized Entry Within Event Window

在同一个事件窗口中随机入场。

如果你的策略不如随机入场，说明 timing 没有 edge。

### Baseline 4：Opposite Direction

做反方向。

如果你的策略和反向差不多，说明信号没方向性。

### Baseline 5：Simple Rule Version

例如：

```text
只用 key level + reclaim
```

对比：

```text
key level + OI + liquidation + absorption
```

这样可以评价新增数据是否有价值。

---

# 六、蒙特卡洛测试也要改

普通蒙特卡洛通常对低频策略不友好，尤其当样本少、收益肥尾时。

建议做三类蒙特卡洛。

---

## 1. Trade Resampling Monte Carlo

对交易结果序列重采样。

适合中高频策略。  
低频策略样本太少时不可靠。

---

## 2. Event Resampling Monte Carlo

对事件样本重采样。

这更适合你的策略。

单位不是交易，而是：

```text
event episode
```

一个 episode 包含：

```text
setup
trigger
entry
exit
pnl
MAE
MFE
context
```

然后对 episode 重采样。

---

## 3. Block Bootstrap

对市场片段重采样。

保留行情结构：

```text
crash block
range block
trend block
liquidation block
```

这样不会打散市场状态。

对事件策略尤其重要，因为事件不是独立同分布。

---

# 七、不要用单一分数淘汰低频策略

低频策略应该经过分级评价：

```text
Reject
Research
Watchlist
Paper Eligible
Capital Eligible
```

例如：

```text
样本不足，但逻辑强 → Research
事件样本足够，收益为正 → Watchlist
out-of-sample 也通过 → Paper Eligible
paper 表现稳定 → Capital Eligible
```

不要因为短期收益不如 baseline 就直接淘汰。

---

# 八、建议新增 Strategy Evaluation Profile

每个策略都有自己的评价 profile。

```python
from enum import Enum
from pydantic import BaseModel, Field
from typing import List, Optional


class EvaluationType(str, Enum):
    CONTINUOUS = "continuous"
    EVENT_DRIVEN = "event_driven"
    TAIL_ALPHA = "tail_alpha"
    DEFENSIVE = "defensive"


class EvaluationProfile(BaseModel):
    strategy_family: str
    evaluation_type: EvaluationType

    min_signal_count: int
    min_event_count: int
    min_trade_count: int

    primary_metric: str
    secondary_metrics: List[str]

    baseline_types: List[str]

    allow_low_frequency: bool = False
    max_no_trade_days: Optional[int] = None

    required_regime_buckets: List[str] = []
```

示例：

```json
{
  "strategy_family": "liquidation_cascade_reversal",
  "evaluation_type": "tail_alpha",
  "min_signal_count": 100,
  "min_event_count": 50,
  "min_trade_count": 30,
  "primary_metric": "tail_event_profit_factor",
  "secondary_metrics": [
    "average_R",
    "max_adverse_excursion",
    "crash_regime_return",
    "false_positive_cost"
  ],
  "baseline_types": [
    "no_trade",
    "naive_event_entry",
    "random_event_entry",
    "opposite_direction"
  ],
  "allow_low_frequency": true
}
```

---

# 九、平台评价流程建议改成这样

原流程：

```text
策略运行一段时间
→ 蒙特卡洛
→ 对比 baseline
→ 保留/淘汰
```

改成：

```text
识别策略类型
→ 选择 evaluation profile
→ 收集对应样本
→ 按事件/状态/策略类别评价
→ 与同类 baseline 比较
→ 根据证据等级晋级
```

---

# 十、新的评价流程

```text
1. Strategy declares family and evaluation_type
2. Evaluation Engine loads profile
3. Collect signals, events, trades, context snapshots
4. Build event episodes
5. Evaluate by event, not only by time
6. Compare against matching baselines
7. Run event-level Monte Carlo / block bootstrap
8. Score evidence strength
9. Assign lifecycle status
```

生命周期：

```text
RESEARCH
→ WATCHLIST
→ PAPER_ELIGIBLE
→ PAPER_TRADING
→ CAPITAL_ELIGIBLE
→ RETIRED
```

---

# 十一、低频策略的晋级标准应该不同

例如：

## Continuous Strategy

```text
min_trade_count >= 300
profit_factor >= 1.2
max_drawdown <= 15%
sharpe > 1
```

## Event-Driven Strategy

```text
min_event_count >= 100
min_trade_count >= 50
event_profit_factor >= 1.3
average_R >= 0.25
false_positive_cost controlled
better than naive_event_entry
```

## Tail Alpha Strategy

```text
min_tail_events >= 20
crash_regime_return positive
max_loss_per_event <= 1R
positive skew
improves portfolio drawdown
```

## Defensive Strategy

```text
reduces max_drawdown
reduces losing streak
does not remove too much profitable exposure
improves risk-adjusted return
```

---

# 十二、对 low frequency 策略，不交易也应该被计分

这是非常重要的。

低频策略的核心能力包括：

```text
知道什么时候不交易
```

所以评价系统要记录：

```text
qualified setup appeared?
strategy chose trade or skip?
if skipped, what happened?
```

这样可以评价：

```text
skip_quality
```

例如：

```text
策略跳过 80 个低质量 setup，
其中 60 个后续确实失败，
说明过滤器有价值。
```

这类价值在传统回测里完全看不见。

---

# 十三、增加 Missed Opportunity Analysis

对每个 setup 事件，记录：

```text
setup appeared
trigger appeared
strategy entered / skipped
best possible R
actual R
reason for skip
```

这样可以知道：

```text
策略是不是太保守？
过滤器是否错过了大量好交易？
```

---

# 十四、评价系统要看“组合贡献”，而不是单策略孤立表现

低频高回报策略可能单独看不稳定，但组合中很有价值。

例如：

```text
平时不交易
但在 crash regime 盈利
或在其他策略亏损时盈利
```

它的价值体现在：

```text
降低组合最大回撤
提供非相关收益
改善尾部表现
```

所以要评价：

```text
portfolio_marginal_contribution
```

即：

```text
组合没有该策略
vs
组合加入该策略
```

比较：

```text
max_drawdown
left-tail loss
return skew
profit factor
capital efficiency
```

这比单独 Sharpe 更重要。

---

# 十五、建议新增文档与模块

## 文档

```text
docs/evaluation_framework.md
docs/strategy_evaluation_profiles.md
docs/event_based_backtesting.md
docs/baseline_policy.md
docs/monte_carlo_policy.md
```

## 代码模块

```text
app/evaluation/
├── profiles.py
├── event_episode.py
├── baselines.py
├── metrics.py
├── monte_carlo.py
├── block_bootstrap.py
├── lifecycle.py
└── reports.py
```

---

# 十六、最关键的改动总结

你应该把评价系统从：

```text
time-based performance evaluation
```

升级为：

```text
profile-aware evaluation system
```

也就是：

```text
不同类型策略，用不同评价口径。
```

核心原则：

```text
连续型策略看时间收益；
事件型策略看事件收益；
尾部策略看极端窗口贡献；
防御策略看减少损失；
权限层看是否减少错误环境暴露。
```

---

# 十七、对你当前平台的直接改造建议

优先做 5 个改动：

```text
1. 每个 strategy_family 增加 evaluation_type
2. 建立 event_episode 数据结构
3. 低频策略按事件数评价，不按运行天数评价
4. baseline 按策略类型匹配
5. Reviewer 增加 missed opportunity 和 skip_quality 分析
```

---

# 最终结论

你的评价系统如果继续用：

```text
固定时间窗口 + 普通蒙特卡洛 + 通用 baseline
```

会系统性淘汰：

```text
低频
高赔率
偏态收益
危机窗口收益
事件驱动
punishment 类策略
```

正确做法是：

```text
按策略类型建立评价 profile；
低频策略按事件样本评价；
尾部策略按极端窗口贡献评价；
防御层按减少亏损评价；
baseline 必须同类对比。
```

一句话：

```text
低频高回报策略不是“交易太少”，
而是“只在别人真正犯大错时才出手”。
```

评价系统必须奖励这种等待能力，而不是惩罚它。