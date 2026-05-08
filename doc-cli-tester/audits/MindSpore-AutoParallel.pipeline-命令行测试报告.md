# MindSpore《AutoParallel.pipeline》— 命令行测试报告

**文档**：https://www.mindspore.cn/docs/zh-CN/r2.9.0/api_python/parallel/mindspore.parallel.auto_parallel.AutoParallel.html#mindspore.parallel.auto_parallel.AutoParallel.pipeline  
**生成时间**：2026-05-07  
**目标环境**：Ascend NPU + MindSpore 2.9.0 + msrun 分布式环境  
**当前环境**：macOS x86_64 / Python 3.9.6 / MindSpore 2.6.0（模块导入已验证，分布式执行步骤需在目标环境补测）

---

## 一、命令提取与分类

从文档代码示例中提取到 **8 个代码块**：

| 编号 | 位置 | 内容摘要 | 类型 |
|------|------|----------|------|
| 1 | Block1（类主示例） | AutoParallel + Pipeline 完整训练流程 | 分布式执行，需 Ascend 环境 |
| 2 | Block2（comm_fusion） | comm_fusion 融合配置 | 分布式执行 |
| 3 | Block3（load_operator_strategy_file） | 加载策略 JSON 文件 | 分布式执行 |
| 4 | Block4（load_param_strategy_file） | 加载参数策略 ckpt | 分布式执行 |
| 5 | Block5（no_init_parameters_in_compile） | 编译时不初始化参数 | 分布式执行 |
| 6 | Block6（print_local_norm） | 打印 local norm | 分布式执行 |
| 7 | Block7（save_operator_strategy_file） | 保存策略 JSON 文件 | 分布式执行 |
| 8 | Block8（transformer_opt） | 配置 transformer 优化 | 分布式执行 |

> 所有代码块均需通过 `msrun` 启动分布式训练环境后才能实际运行，在 macOS 上仅可验证模块导入。

---

## 二、当前环境执行结果

在 macOS 上验证关键模块导入：

```
mindspore                                        ✅ 可导入（版本 2.6.0）
mindspore.parallel.auto_parallel.AutoParallel    ✅ 可导入
mindspore.parallel.nn.Pipeline                   ✅ 可导入
mindspore.parallel.nn.PipelineGradReducer        ✅ 可导入
mindspore.nn.utils.no_init_parameters            ✅ 可导入
msrun                                            ❌ 未找到（需 Ascend 环境）
```

**注意**：msrun 不存在属于**环境差异，不是文档错误**，需在 openEuler + Ascend 环境中补充完整验证。

---

## 三、文档问题分析

经逐条检查，发现 **3 处文档错误**：

### ❌ 问题 1：Block1 — `with` 块内续行错误使用 `>>>`

Python doctest 规范要求，`with` 块内的续行必须使用 `...` 提示符，而非 `>>>`。

文档原文：
```python
>>> with no_init_parameters():
>>>     net = Network()
>>>     optimizer = nn.SGD(net.trainable_params(), 1e-2)
>>>     pp_grad_reducer = PipelineGradReducer(optimizer.parameters, opt_shard=False)
```

修复建议：
```python
>>> with no_init_parameters():
...     net = Network()
...     optimizer = nn.SGD(net.trainable_params(), 1e-2)
...     pp_grad_reducer = PipelineGradReducer(optimizer.parameters, opt_shard=False)
```

---

### ❌ 问题 2：Block1 — `Pipeline()` 多行调用续行错误使用 `>>>`

同理，跨行表达式的续行也必须使用 `...`。

文档原文：
```python
>>> net_with_loss = Pipeline(nn.WithLossCell(net, loss_fn), 4, stage_config={"_backbone.flatten":0,
>>>     "_backbone.layer1": 0, "_backbone.relu1": 0, "_backbone.layer2": 1,
>>>     "_backbone.relu2": 1, "_backbone.layer3": 1})
```

修复建议：
```python
>>> net_with_loss = Pipeline(nn.WithLossCell(net, loss_fn), 4, stage_config={"_backbone.flatten":0,
...     "_backbone.layer1": 0, "_backbone.relu1": 0, "_backbone.layer2": 1,
...     "_backbone.relu2": 1, "_backbone.layer3": 1})
```

---

### ❌ 问题 3：Block2 — `comm_fusion` 调用对象错误

`comm_fusion` 是 `AutoParallel` 封装后实例的方法，文档中却错误地调用在原始 `net` 上，运行时会报 AttributeError。

文档原文：
```python
>>> parallel_net = AutoParallel(net, parallel_mode="semi_auto")
>>> comm_config = {"openstate": True, "allreduce": {"mode": "auto", "config": None}}
>>> net.comm_fusion(config=comm_config)   # ❌ net 上不存在此方法
```

修复建议：
```python
>>> parallel_net.comm_fusion(config=comm_config)
```

---

## 四、结论

| 维度 | 评估 |
|------|------|
| 模块导入 | ✅ 全部正确（在 MindSpore 2.6.0 验证通过） |
| doctest 格式规范 | ❌ 2 处续行提示符错误（`>>>` 应改为 `...`） |
| 变量名一致性 | ❌ 1 处：`comm_fusion` 调用对象应为 `parallel_net` 而非 `net` |
| 分布式执行逻辑 | ⚠️ 需在 Ascend 环境补测，当前环境无法验证 |

**建议**：在 openEuler + Ascend 环境中运行完整示例前，先修复上述 3 处文档错误，避免用户直接复制代码后报错。
