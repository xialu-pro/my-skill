# My Skills

个人Claude Code Skills仓库。

## Skills列表

### doc-quality-auditor

**描述**: 用43项CORE-EEAT指标检视文档质量（排除开发/工程项、独特性维度、第一人称证明及作者身份）。评分GEO+SEO可见性，识别快速修复点，生成可执行报告。

**触发词**:
- 文档质量检视
- 检视文档质量
- 内容质量评分
- 检视技术文档
- audit document quality
- 43项指标检视
- 文档写得怎么样

**文件**:
- `doc-quality-auditor/SKILL.md` - Skill主文件
- `doc-quality-auditor/references/43-item-checklist.md` - 43项详细检查清单

**来源**: 衍生自 [CORE-EEAT Content Benchmark](https://github.com/aaron-he-zhu/core-eeat-content-benchmark)

---

## 如何使用

1. 将此仓库clone到本地
2. 将skill目录复制到您的Claude Code skills目录（通常为 `.agents/skills/`）
3. 在Claude Code中使用触发词激活skill

## 检视报告

检视报告存放在 `audits/` 目录：

| 文件 | 文档 | 总分 | GEO | SEO | 等级 |
|------|------|------|-----|-----|------|
| `2026-04-14-openEuler-快速入门-改写版-v2.md` | openEuler快速入门 | 48.75 | 75 | 22.5 | Low |
| `2026-04-14-openEuler-快速入门-改写版.md` | openEuler快速入门（旧版56项） | 45 | 65 | 24 | Low |

---

## 许可证

Apache-2.0