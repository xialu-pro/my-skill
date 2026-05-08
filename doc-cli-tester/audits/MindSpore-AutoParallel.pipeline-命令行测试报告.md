---
文档：MindSpore AutoParallel.pipeline API 文档
URL：https://www.mindspore.cn/docs/zh-CN/r2.9.0/api_python/parallel/mindspore.parallel.auto_parallel.AutoParallel.html#mindspore.parallel.auto_parallel.AutoParallel.pipeline
环境：macOS Darwin x86_64 / Python 3.9.6 / MindSpore 2.6.0（目标：MindSpore 2.9.0 + Ascend）
时间：2026-05-07
第 1 次验证
---

═══════════════════════════════════════════════
  AutoParallel.pipeline 文档命令行测试报告
═══════════════════════════════════════════════

一、测试概览
  PASS：5    FAIL：3    SKIP：3    总计：11

二、详细结果

  静态格式检查：
  ❌ [T1] with块续行应使用...而非>>>  — FAIL（文档格式错误）
  ❌ [T2] 多行表达式续行应使用...而非>>>  — FAIL（文档格式错误）
  ❌ [T3] comm_fusion调用对象应为parallel_net而非net  — FAIL（文档代码错误）

  运行时检查：
  ✅ [T4]  MindSpore 可导入  — PASS
  ✅ [T5]  AutoParallel 可导入  — PASS
  ⏭ [T6]  msrun 启动分布式训练  — SKIP（需要 Ascend 硬件 + 分布式环境）
  ⏭ [T7]  parallel_net.pipeline(stages=2)  — SKIP（需要 Ascend 硬件 + init()）
  ⏭ [T8]  model.train()  — SKIP（需要 Ascend 硬件 + 数据集）
  ✅ [T9]  Pipeline 类可导入  — PASS
  ✅ [T10] PipelineGradReducer 可导入  — PASS
  ✅ [T11] no_init_parameters 可导入  — PASS

三、失败项分析

  [T1] with块续行使用了>>>而非...
  - 位置：Block1（类主示例）第3-5行
  - 原始代码：
      >>> with no_init_parameters():
      >>>     net = Network()
      >>>     optimizer = nn.SGD(net.trainable_params(), 1e-2)
      >>>     pp_grad_reducer = PipelineGradReducer(optimizer.parameters, opt_shard=False)
  - 根因：Python doctest 规范要求，代码块（with/for/if/def/class）内的续行必须使用 `...` 提示符而非 `>>>`
  - 修复建议（文档问题）：
      >>> with no_init_parameters():
      ...     net = Network()
      ...     optimizer = nn.SGD(net.trainable_params(), 1e-2)
      ...     pp_grad_reducer = PipelineGradReducer(optimizer.parameters, opt_shard=False)

  [T2] 多行表达式续行使用了>>>而非...
  - 位置：Block1（类主示例）Pipeline()调用第2-3行
  - 原始代码：
      >>> net_with_loss = Pipeline(nn.WithLossCell(net, loss_fn), 4, stage_config={"_backbone.flatten":0,
      >>>     "_backbone.layer1": 0, "_backbone.relu1": 0, "_backbone.layer2": 1,
      >>>     "_backbone.relu2": 1, "_backbone.layer3": 1})
  - 根因：同T1，多行表达式的续行必须用 `...`
  - 修复建议（文档问题）：
      >>> net_with_loss = Pipeline(nn.WithLossCell(net, loss_fn), 4, stage_config={"_backbone.flatten":0,
      ...     "_backbone.layer1": 0, "_backbone.relu1": 0, "_backbone.layer2": 1,
      ...     "_backbone.relu2": 1, "_backbone.layer3": 1})

  [T3] comm_fusion 调用者变量名错误
  - 位置：Block2（comm_fusion 方法示例）第3行
  - 原始代码：
      >>> parallel_net = AutoParallel(net, parallel_mode="semi_auto")
      >>> comm_config = {"openstate": True, "allreduce": {"mode": "auto", "config": None}}
      >>> net.comm_fusion(config=comm_config)   ← 错误
  - 根因：comm_fusion 是 AutoParallel 封装后实例的方法，应调用 parallel_net.comm_fusion()，
          而非原始网络 net.comm_fusion()（net 上不存在此方法）
  - 修复建议（文档问题）：
      >>> parallel_net.comm_fusion(config=comm_config)

四、SKIP 说明（环境限制，非文档问题）

  [T6-T8] 以下测试需要 Ascend NPU 硬件 + msrun 分布式环境，在 macOS/x86_64 上无法验证：
  - msrun 启动命令
  - parallel_net.pipeline(stages=2) 实际执行
  - model.train() 端到端训练
  建议在 openEuler + Ascend 环境中补充验证。

五、结论

  ☑ 存在以下文档问题需处理：
    1. [T1] Block1：with 块内 3 行续行提示符错误（>>> → ...）
    2. [T2] Block1：Pipeline() 多行调用 2 行续行提示符错误（>>> → ...）
    3. [T3] Block2：comm_fusion 调用者应为 parallel_net，当前错误写为 net

  注：T6-T8 为环境限制导致的 SKIP，不属于文档错误。
═══════════════════════════════════════════════
