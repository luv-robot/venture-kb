可以。下面这份可以作为你的长期研究清单，建议保存为：

docs/strategy_research_catalog.md

说明：你写的“幸亏比”我按“盈亏比 / Reward-Risk Ratio / 平均盈利 ÷ 平均亏损”理解。下表中的胜率、频率、盈亏比不是承诺收益，而是**加密合约市场的研究先验区间**，用于指导回测、paper trading 和策略排序。真实数值必须由你自己的数据验证。

  

# strategy_research_catalog.md

  

# Strategy Research Catalog

  

本文件记录适合 Quant Agent Platform 优先研究的策略家族。

  

核心思维：

  

```text

从他人的错误、拥挤仓位、被迫交易、流动性错配、持仓成本不可持续中获利。

这些策略不以预测下一根 K 线涨跌为核心，而是识别：

谁被迫交易？

谁追在错误位置？

谁仓位拥挤？

谁的持仓成本不可持续？

谁的止损/强平集中暴露？

  

**统计口径说明**

**Frequency**

频率按主流加密合约市场估算，默认观察对象：

BTC/USDT

ETH/USDT

Top 20 high-liquidity perpetual futures

频率分级：

Very Low   = 每周 0-2 次

Low        = 每周 1-5 次

Medium     = 每日 1-5 次

Medium-High= 每日 5-20 次

High       = 每日 20+ 次

**Win Rate**

胜率为策略经过基础过滤后的研究先验区间。

**Reward/Risk Ratio**

盈亏比定义：

average winning trade / average losing trade

即平均盈利 ÷ 平均亏损。

**Important Warning**

所有数值均为研究先验，不是实盘预期。  
必须通过：

historical backtest

walk-forward test

out-of-sample test

paper trading

fee/slippage simulation

后才能用于仓位分配。

  

**Strategy Summary Table**

|   |   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|---|
|**ID**|**Strategy Family**|**中文名**|**Frequency**|**Expected Win Rate**|**Expected R/R**|**Main Edge**|**Difficulty**|
|S1|Liquidity Sweep Reversal|流动性扫单反转|Low|35%-55%|1.5-4.0|止损/强平释放后的反向吸收|Medium|
|S2|Liquidation Cascade Reversal|强平瀑布回补|Very Low-Low|30%-50%|2.0-6.0|连环强平后的超跌/超涨回补|High|
|S3|Funding Crowding Fade|Funding 拥挤反转|Low-Medium|40%-58%|1.2-3.0|拥挤持仓成本不可持续|Medium|
|S4|Failed Breakout Punishment|假突破惩罚|Medium|42%-60%|1.0-2.5|追突破者被套后的反向回撤|Medium|
|S5|Event Overreaction Fade|事件过度反应回归|Low|35%-55%|1.5-5.0|新闻/公告第一反应过度|High|
|S6|Unlock / Airdrop Expectation Trap|解锁/空投预期差|Very Low|35%-55%|1.5-4.0|市场错误定价事件真实卖压|High|
|S7|Market Maker Inventory Reversal|做市商库存压力反转|Medium-High|50%-65%|0.5-1.5|急单冲击后的盘口恢复|Very High|
|S8|Basis / Funding Dislocation Reversion|基差/资金费率异常回归|Medium|45%-65%|0.5-2.0|衍生品价格偏离现货锚|Medium-High|
|S9|Low Liquidity Impact Reversion|低流动性冲击回补|Medium|45%-60%|0.8-2.0|错误时段大单冲击后的回补|Medium|
|S10|Narrative Crowding Fade|拥挤叙事反向交易|Very Low-Low|30%-50%|2.0-6.0|迟到叙事资金被套|High|
|S11|Trend Trap Continuation|趋势陷阱延续|Medium|45%-62%|1.0-2.5|惩罚趋势中的逆势追单者|Medium|
|S12|VWAP Exhaustion Reversion|VWAP 偏离衰竭回归|Medium-High|48%-65%|0.6-1.8|短期价格偏离成交均衡区|Medium|

**S1. Liquidity Sweep Reversal**

**中文名**

流动性扫单反转

**Core Idea**

关键位被刺穿

→ 止损/强平/追单释放

→ 主动流衰竭

→ 被动流动性吸收

→ 价格收复关键位

**Punished Participants**

把止损放在显眼位置的人

追突破的人

高杠杆被迫平仓的人

**Frequency**

Low

每周 1-5 次，取决于币种池和关键位定义。

**Statistical Prior**

Win Rate: 35%-55%

Reward/Risk: 1.5-4.0

Holding Time: 数分钟到数小时

**Key Features**

key_level_score

OI_percentile

liquidation_spike

taker_sell_buy_imbalance

CVD_price_divergence

reclaim_score

absorption_score

**Best Conditions**

大周期关键位

OI 高位

清算增加

价格快速收复

主动流推动失败

**Main Failure Mode**

真突破 / 趋势加速

  

**S2. Liquidation Cascade Reversal**

**中文名**

强平瀑布回补

**Core Idea**

高杠杆仓位集中

→ 价格触发连环强平

→ 强制卖盘/买盘造成极端偏离

→ 强平结束后价格回补

加密市场的强平和杠杆反馈会造成反身性价格冲击，OI、清算和流动性状态需要作为核心观测项。公开研究也把清算瀑布描述为杠杆、流动性与波动率之间的反馈循环。([SSRN](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5611392&utm_source=chatgpt.com))

**Punished Participants**

过度使用杠杆的人

错误位置加仓的人

无法承受强平机制的人

**Frequency**

Very Low-Low

主流币每周 0-2 次；全市场扫描可提高频率。

**Statistical Prior**

Win Rate: 30%-50%

Reward/Risk: 2.0-6.0

Holding Time: 数分钟到数小时

**Key Features**

OI_percentile

OI_drop_after_event

liquidation_notional_zscore

price_impact_decay

spread_recovery

reclaim_or_rejection

**Best Conditions**

清算爆发后 OI 快速下降

价格不再扩展

盘口恢复

反向成交开始增强

**Main Failure Mode**

清算不是尾声，而是趋势出清的开始。

  

**S3. Funding Crowding Fade**

**中文名**

Funding 拥挤反转

**Core Idea**

Funding 极端

+ OI 高

+ 价格无法继续沿拥挤方向推进

→ 拥挤持仓撤退

→ 反向交易

Funding 在永续合约中不是普通指标，而是维持永续价格与标的价格锚定的机制；相关研究也将 funding 视为一种反馈规则，而不是被动转移项。([SSRN](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=6185958&utm_source=chatgpt.com))

**Punished Participants**

愿意支付极高持仓成本的人

过度一致看多/看空的人

迟到的趋势追随者

**Frequency**

Low-Medium

每周数次到每日数次。

**Statistical Prior**

Win Rate: 40%-58%

Reward/Risk: 1.2-3.0

Holding Time: 数小时到数天

**Key Features**

funding_percentile

funding_zscore

OI_percentile

basis

price_stall

failed_breakout

liquidation_after_failed_move

**Best Conditions**

Funding 极端

OI 高位

价格推进失败

关键位假突破

**Main Failure Mode**

强趋势中 funding 可以长期极端。

  

**S4. Failed Breakout Punishment**

**中文名**

假突破惩罚

**Core Idea**

价格突破明显高点/低点

→ 追突破者入场

→ 价格无法站稳

→ 跌回/收回关键位

→ 追单者被迫止损

**Punished Participants**

机械突破交易者

错误确认突破的人

把入场放在流动性池后的人

**Frequency**

Medium

日内可出现多次。

**Statistical Prior**

Win Rate: 42%-60%

Reward/Risk: 1.0-2.5

Holding Time: 数分钟到数小时

**Key Features**

breakout_level

breakout_volume

time_above_or_below_level

failed_acceptance

return_inside_range

taker_flow_reversal

**Best Conditions**

突破后无法持续成交在关键位外侧

CVD 与价格背离

回到区间内

**Main Failure Mode**

真正突破后继续趋势扩展。

  

**S5. Event Overreaction Fade**

**中文名**

事件过度反应回归

**Core Idea**

新闻/公告/黑天鹅

→ 第一波市场反应过度

→ 追单者在极端位置成交

→ 信息重新定价

→ 价格部分回归

**Punished Participants**

标题党交易者

情绪化追单者

只交易第一反应的人

**Frequency**

Low

取决于事件密度。

**Statistical Prior**

Win Rate: 35%-55%

Reward/Risk: 1.5-5.0

Holding Time: 数分钟到数天

**Key Features**

news_event_score

first_move_size

volume_zscore

social_volume_spike

price_rejection

liquidity_recovery

**Best Conditions**

第一波冲击巨大

后续价格无法继续推进

成交量开始衰减

盘口恢复

**Main Failure Mode**

事件具有真实长期影响，价格不回归。

  

**S6. Unlock / Airdrop Expectation Trap**

**中文名**

解锁/空投预期差

**Core Idea**

市场提前押注解锁/空投影响

→ 仓位拥挤

→ 真实卖压或买盘不符合预期

→ 拥挤方被迫回补

**Punished Participants**

只看事件标题的人

错误估计真实流通卖压的人

提前拥挤下注的人

**Frequency**

Very Low

每月少量机会。

**Statistical Prior**

Win Rate: 35%-55%

Reward/Risk: 1.5-4.0

Holding Time: 数小时到数天

**Key Features**

unlock_size_float_ratio

exchange_inflow

holder_distribution

pre_event_price_move

pre_event_OI_change

funding_extreme

**Best Conditions**

市场预期极端

仓位拥挤

事件落地后真实流动性压力不及预期

**Main Failure Mode**

真实卖压远超市场预期。

  

**S7. Market Maker Inventory Reversal**

**中文名**

做市商库存压力反转

**Core Idea**

主动买/卖单持续冲击

→ 做市商被迫累积库存

→ 主动流边际影响下降

→ 盘口恢复

→ 价格回归

订单流对加密资产价格具有解释和预测作用，相关研究强调 order flow 对 crypto return 的信息含量。([科学直接](https://www.sciencedirect.com/science/article/pii/S1386418126000029?utm_source=chatgpt.com)) 传统市场中，订单流失衡也会在流动性脆弱时放大价格波动。([联邦储备系统](https://www.federalreserve.gov/econres/notes/feds-notes/order-flow-imbalances-and-amplification-of-price-movements-evidence-from-u-s-treasury-markets-20251103.html?utm_source=chatgpt.com))

**Punished Participants**

急于成交的 taker

在流动性差时使用市价单的人

情绪化短线订单流

**Frequency**

Medium-High

高流动性市场中每日多次。

**Statistical Prior**

Win Rate: 50%-65%

Reward/Risk: 0.5-1.5

Holding Time: 秒级到数分钟

**Key Features**

CVD_extreme

price_impact_per_volume

orderbook_replenishment

spread_recovery

microprice_reversal

depth_imbalance

**Best Conditions**

主动流很强但价格不再推进

盘口深度恢复

spread 收窄

microprice 反向移动

**Main Failure Mode**

低估真实信息流，逆向接到趋势单。

  

**S8. Basis / Funding Dislocation Reversion**

**中文名**

基差/资金费率异常回归

**Core Idea**

永续/期货价格相对现货过度偏离

→ funding 或 basis 异常

→ 套利资金进入

→ 偏离收敛

**Punished Participants**

过度追多/追空导致衍生品偏离的人

忽视现货锚的人

愿意支付过高 funding 的人

**Frequency**

Medium

每日可观察到多次轻微信号，强信号较少。

**Statistical Prior**

Win Rate: 45%-65%

Reward/Risk: 0.5-2.0

Holding Time: 数小时到数天

**Key Features**

perp_spot_basis

quarterly_basis

funding_rate

funding_spread

basis_zscore

basis_half_life

**Best Conditions**

高流动性标的

偏离明显

没有重大结构性事件

套利通道可执行

**Main Failure Mode**

偏离因真实风险溢价产生，短期不收敛。

  

**S9. Low Liquidity Impact Reversion**

**中文名**

低流动性冲击回补

**Core Idea**

低流动性时段出现大单冲击

→ 价格短时偏离

→ 流动性恢复

→ 价格回补

**Punished Participants**

错误时间用市价单交易的人

低流动性时段被迫平仓的人

止损被动触发者

**Frequency**

Medium

周末、亚洲凌晨、小币种更常见。

**Statistical Prior**

Win Rate: 45%-60%

Reward/Risk: 0.8-2.0

Holding Time: 数分钟到数小时

**Key Features**

liquidity_score

spread_zscore

depth_drop

large_trade_impact

session_time

reversion_to_mid

**Best Conditions**

没有真实新闻

成交冲击孤立

盘口快速恢复

**Main Failure Mode**

低流动性冲击其实是信息驱动行情的开始。

  

**S10. Narrative Crowding Fade**

**中文名**

拥挤叙事反向交易

**Core Idea**

某个叙事过热

→ 社媒、价格、OI、funding 同时极端

→ 边际买盘衰减

→ 拥挤多头撤退

**Punished Participants**

迟到的叙事追随者

用故事替代风控的人

顶部接盘者

**Frequency**

Very Low-Low

按叙事周期出现。

**Statistical Prior**

Win Rate: 30%-50%

Reward/Risk: 2.0-6.0

Holding Time: 数天到数周

**Key Features**

social_volume_zscore

price_extension

funding_extreme

OI_surge

spot_inflow_decline

large_holder_distribution

**Best Conditions**

叙事热度极端

价格开始无法继续上涨

资金费率极端

大户开始转入交易所

**Main Failure Mode**

叙事进入更大级别泡沫，过早做空。

  

**S11. Trend Trap Continuation**

**中文名**

趋势陷阱延续

**Core Idea**

趋势中出现局部扫单

→ 诱发逆势追单者入场

→ 价格收复

→ 逆势者被迫止损

→ 顺原趋势延续

这个策略可以理解为“惩罚逆势者”，而不是传统意义的追涨杀跌。

**Punished Participants**

趋势中抄顶/抄底的人

误判局部破位的人

在回撤末端追反向的人

**Frequency**

Medium

趋势行情中机会较多。

**Statistical Prior**

Win Rate: 45%-62%

Reward/Risk: 1.0-2.5

Holding Time: 数分钟到数小时

**Key Features**

trend_regime_score

local_swing_sweep

pullback_depth

OI_change

reclaim_score

continuation_volume

**Best Conditions**

大周期趋势明确

局部低点/高点被扫

价格快速收复

顺趋势成交恢复

**Main Failure Mode**

趋势已经转向，局部扫单不是陷阱，而是真破位。

  

**S12. VWAP Exhaustion Reversion**

**中文名**

VWAP 偏离衰竭回归

**Core Idea**

价格远离 VWAP / 成交均衡区

→ 主动追单过度

→ 推进力下降

→ 价格回归 VWAP 或成交密集区

**Punished Participants**

短线追单者

在极端偏离区继续市价追涨杀跌的人

忽视成交均衡区的人

**Frequency**

Medium-High

主流币日内可多次出现。

**Statistical Prior**

Win Rate: 48%-65%

Reward/Risk: 0.6-1.8

Holding Time: 数分钟到数小时

**Key Features**

vwap_distance

volume_profile_edge

CVD_divergence

taker_imbalance_decay

spread_recovery

microprice_reversal

**Best Conditions**

价格偏离 VWAP 明显

主动流衰竭

盘口恢复

无重大事件驱动

**Main Failure Mode**

强趋势中价格沿 VWAP 外侧持续推进。

  

**Recommended Priority**

**First Priority**

S1 Liquidity Sweep Reversal

S3 Funding Crowding Fade

S4 Failed Breakout Punishment

S11 Trend Trap Continuation

原因：

逻辑清晰

可回测性较好

适合当前平台 MVP

与你的认知模型高度匹配

**Second Priority**

S2 Liquidation Cascade Reversal

S8 Basis / Funding Dislocation Reversion

S12 VWAP Exhaustion Reversion

原因：

潜力较高

但需要更好的数据质量或执行能力

**Third Priority**

S5 Event Overreaction Fade

S6 Unlock / Airdrop Expectation Trap

S7 Market Maker Inventory Reversal

S9 Low Liquidity Impact Reversion

S10 Narrative Crowding Fade

原因：

研究价值高

但数据工程、事件识别或执行难度更高

  

**Strategy Selection Matrix**

|   |   |   |
|---|---|---|
|**Strategy**|**Best Use**|**Avoid When**|
|Liquidity Sweep Reversal|关键位 + 清算 + 收复|强趋势破位|
|Liquidation Cascade Reversal|清算瀑布尾声|宏观事件刚开始|
|Funding Crowding Fade|Funding/OI 极端但价格停滞|强趋势仍在加速|
|Failed Breakout Punishment|突破失败回区间|真突破放量延续|
|Event Overreaction Fade|第一波事件冲击过度|事件改变基本面|
|Unlock Expectation Trap|市场预期过度一致|真实卖压不可控|
|MM Inventory Reversal|主动流冲击衰减|信息型订单流|
|Basis Dislocation|衍生品偏离现货锚|交易通道受限|
|Low Liquidity Impact Reversion|孤立大单冲击|新闻驱动行情|
|Narrative Crowding Fade|叙事极端过热|泡沫主升浪|
|Trend Trap Continuation|趋势中局部诱空/诱多|趋势转向|
|VWAP Reversion|日内偏离均衡区|强单边趋势|

**Research Metrics**

每个策略家族都必须统计：

signal_count

trigger_count

trade_count

win_rate

average_win

average_loss

reward_risk_ratio

profit_factor

max_drawdown

average_holding_time

fee_adjusted_return

slippage_adjusted_return

regime_split_performance

symbol_split_performance

  

**Minimum Sample Requirement**

建议最低样本数：

Low frequency strategies:

至少 100 个信号

至少 50 笔交易

  

Medium frequency strategies:

至少 300 个信号

至少 150 笔交易

  

High frequency strategies:

至少 1000 个信号

至少 500 笔交易

如果样本不足，不允许进入 paper trading。

  

**Backtest Pass Reference**

初步通过标准：

trade_count >= minimum_required

profit_factor >= 1.20

max_drawdown >= -15%

reward_risk_ratio >= 1.20

fee_adjusted_return > 0

out_of_sample_result not negative

高频策略可以接受更低盈亏比，但必须有更高胜率和更严格滑点模型。

  

**Key Principle**

策略不是按“看起来聪明”排序，而是按以下顺序筛选：

1. 是否存在明确被惩罚对象

2. 是否存在可观测的错误/拥挤/被迫行为

3. 是否有可量化触发条件

4. 是否能定义明确失效条件

5. 扣除手续费滑点后是否仍有正期望

  

---

  

我建议你把这 12 类策略都纳入平台的 `strategy_family` 枚举，但 MVP 后的第一批只做 4 个：

  

```text

Liquidity Sweep Reversal

Funding Crowding Fade

Failed Breakout Punishment

Trend Trap Continuation

这四个最符合你的“惩罚错误”思维，也最容易和 OI、funding、清算、关键位、订单流评分系统合并。