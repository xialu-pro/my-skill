# openEuler 24.03 LTS SP3 快速入门

> 本文档以TaiShan 200服务器为例，引导你从零完成 openEuler 的安装与首次登录。
>
> **目标读者**：首次安装 openEuler 的运维工程师、系统管理员  
> **要点**：下载ISO → 挂载虚拟光驱 → 配置安装选项 → 验证系统   
>
> **完成本指南后，你将能够**：
> 
> 1. 在服务器上成功安装 openEuler 操作系统
> 2. 完成系统基础配置并首次登录
> 3. 验证系统信息，确认安装成功
>
> **预计用时**：约 30 分钟

## 硬件要求

> **关于 openEuler**：openEuler 社区是一个面向数字基础设施操作系统的开源社区，由开放原子开源基金会孵化及运营。openEuler 全版本支持 x86、Arm、龙芯、RISC-V 等多种架构，并支持多款 CPU 芯片。

最小硬件要求如[表1](#min_hardware_requirements)所示。详细兼容性请查看 [兼容性列表](https://www.openeuler.openatom.cn/zh/compatibility/)。

**表 1**  最小硬件要求<a name="min_hardware_requirements"></a>
<table>
    <thead align="left">
        <tr>
            <th width="10%"><p><strong>部件名称</strong></p></th>
            <th width="40%"><p><strong>最小硬件要求</strong></p></th>
            <th width="50%"><p><strong>说明</strong></p></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td width="10%"><p>架构</p></td>
            <td width="40%"><ul><li>AArch64</li><li>x86_64</li></ul></td>
            <td width="50%"><ul><li>支持Arm的64位架构。</li><li>支持Intel的x86 64位架构。</li></ul></td>
        </tr>
        <tr>
            <td width="10%"><p>CPU</p></td>
            <td width="40%"><ul><li>华为鲲鹏920系列CPU</li><li>Intel<sup>&reg;</sup> Xeon<sup>&reg;</sup>处理器</li></ul></td>
            <td width="50%"><p>-</p></td>
        </tr>
        <tr>
            <td width="10%"><p>内存</p></td>
            <td width="40%"><p>不小于4GB（为了获得更好的应用体验，建议不小于8GB）</p></td>
            <td width="50%"><p>-</p></td>
        </tr>
        <tr>
            <td width="10%"><p>硬盘</p></td>
            <td width="40%"><p>为了获得更好的应用体验，建议不小于120GB</p></td>
            <td width="50%"><p><ul><li>支持IDE、SATA、SAS等接口的硬盘。</li><li>用DIF功能的NVME盘，需要对应驱动支持，如果无法使用，请联系硬件厂商。</li></ul></p></td>
        </tr>
    </tbody>
</table>

## Step 1：获取安装镜像

### 1.1 下载ISO文件

访问 [openEuler官网](https://openeuler.org/zh/download/)：

1. 点击顶部"**下载**"。
2. 选择"**openEuler 24.03 LTS SP3**"，前往下载。

根据你的架构选择：

| 安装方式 | AArch64 | x86_64 | 说明 |
|----------|---------|--------|------|
| 本地安装 | openEuler-24.03-LTS-SP3-aarch64-dvd.iso | openEuler-24.03-LTS-SP3-x86_64-dvd.iso | 完整离线包 |
| 网络安装 | openEuler-24.03-LTS-SP3-netinst-aarch64.iso | openEuler-24.03-LTS-SP3-netinst-x86_64.iso | 最小包，需联网 |

### 1.2 校验文件完整性

下载完成后执行：

```bash
sha256sum openEuler-24.03-LTS-SP3-aarch64-dvd.iso
```

**预期输出**：

```
<校验值>  openEuler-24.03-LTS-SP3-aarch64-dvd.iso
```

> 校验值需与官网公布的值一致，否则请重新下载。

---

## Step 2：启动安装

### 2.1 通过iBMC远程安装（推荐）

适用于TaiShan服务器（iBMC 即智能基板管理控制器）：

1. 在浏览器的地址栏输入`https://<iBMC服务器的IP地址>`，按回车键。

2. 在iBMC登录界面，输入用户名和密码，在"**域名**"下拉框中选择"**这台iBMC**"，单击"**登录**"。

3. 登录成功后，在顶部标题栏中选择"**远程控制**"，打开远程控制界面。

4. 根据您的实际需求，选择一种远程控制台模式。本示例选择"**Java集成远程控制台(共享)**"，如[图1](##remote_control)所示。不同模式的区别详见[《TaiShan 200 服务器 用户指南 (型号 2280)》](https://support.huawei.com/enterprise/zh/doc/EDOC1100088652/d426c991)。

    **图 1**  远程控制配置<a name="remote_control"></a>  
    ![](./figure/remote_control.png)

5. 在远程控制台的上方工具栏中，单击虚拟光驱工具![](./figure/CD-ROM_drive_icon.png)。在弹出的对话框中，选择"**镜像文件**"，浏览并选中您准备好的 openEuler 安装 ISO 文件，单击"**连接**"，如[图2](#select_iso_file)所示。当按钮状态变为"**断开**"后，表示虚拟光驱已连接到服务器，如[图3](#select_iso_file)所示。

    **图 2**  选择镜像文件<a name="select_iso_file"></a>  
    ![](./figure/select_iso_file.png)

    **图 3**  虚拟光驱已连接到服务器<a name="select_iso_file"></a>  
    ![](./figure/iso_connected.png)

6. 在工具栏上，单击启动设备菜单![](./figure/B_icon.png)，在弹出的列表中选择"**光驱**"作为本次的启动设备，如[图4](#choose_boot_device)所示。

    **图 4**  选择启动设备<a name="choose_boot_device"></a>  
    ![](./figure/select_boot_device.png)

7. 在工具栏上，单击电源按钮![](./figure/power_icon.png)，选择“强制重启”，如[图5](#force_restart)所示。

    **图 5**  强制重启<a name="force_restart"></a>  
    ![](./figure/force_restart.png)

**预期结果**：看到安装引导界面，如[图6](#system_boot)所示。

**图 6**  安装引导界面<a name="system_boot"></a>  
![](./figure/system_boot.png)

### 2.2 通过物理介质安装

1. 将ISO写入U盘或光盘
2. 设置BIOS启动顺序为U盘/光盘优先
3. 重启进入安装引导界面

---

## Step 3：完成安装配置

### 3.1 选择语言

默认英语，可选择"**中文**"，如[图7](#selectlanguage)所示。

**图 7**  选择语言<a name="selectlanguage"></a>  
![](./figure/select_language.png)

### 3.2 配置必填项

> **⚠️ 风险提示**：安装将清除目标磁盘数据，请提前备份重要文件。

**图 8**  安装概览<a name="fig24261457656"></a>  
![](./figures/Installation_Overview.png)

配置项有⚠️告警符号的必须配置：

| 配置项 | 操作 | 建议 |
|--------|------|------|
| **软件选择** | 选择"最小安装" | 可附加"开发工具" |
| **安装目的地** | 选择目标磁盘 | 建议选择"自动"分区 |
| **网络和主机名** | 启用网络，配置静态 IP | 安装后也可通过 `nmcli` 修改 |
| **根密码** | 设置root密码 | ≥8字符，含大小写+数字+特殊字符 |
| **创建用户** | 创建普通用户 | 推荐日常使用 |

1. 选择"**软件选择**"，用户需要根据实际的业务需求，在左侧选择一个"**最小安装**"，在右侧选择安装环境的附加选项，如[图9](#fig1133717611109)所示。

    **图 9**  软件选择<a name="fig1133717611109"></a>  
        ![](./figures/choosesoftware.png)

2. 选择"**安装目的地**"建议选择"**自动**"进行自动分区。如[图10](#fig153381468101)所示。

    **图 10**  安装目标位置<a name="fig153381468101"></a>  
        ![](./figures/Target_installation_position.png)

3. 选择"**网络和主机名**"，启用可用的以太网，如[图11](#network_hostname)所示。点击"**配置**"按钮，在"**常规**"标签页中勾选"**自动以优先级连接**"，点击保存。

    **图 11**  安装目标位置<a name="network_hostname"></a>  
        ![](./figure/network_hostname.png)

4. 选择"**根密码**"，在如[图12](#root_password)所示的"**ROOT密码**"页面中，根据密码复杂度输入密码并再次输入密码进行确认。

    **图 12**  root密码<a name="root_password"></a>  
        ![](./figures/root_password.png)

    **密码复杂度要求**：

    - 长度≥8字符
    - 包含大写、小写、数字、特殊字符中任意3种
    - 不能与账号相同
    - 不能使用字典词汇

5. 选择"**创建用户**"，在创建用户的界面如[图13](#zh-cn_topic_0186390266_zh-cn_topic_0122145909_fig1237715313319)所示。输入用户名，并设置密码，其中密码复杂度要求与root密码复杂度要求一致。另外您还可以通过"**高级**"选项设置用户主目录、用户组等，如[图14](#zh-cn_topic_0186390266_zh-cn_topic_0122145909_fig128716531312)所示。

    **图 13**  创建用户<a name="zh-cn_topic_0186390266_zh-cn_topic_0122145909_fig1237715313319"></a>  
        ![](./figures/createuser.png)

    **图 14**  高级用户配置<a name="zh-cn_topic_0186390266_zh-cn_topic_0122145909_fig128716531312"></a>  
        ![ 高级用户配置](./figures/Advanced_User_Configuration.png)

### 3.3 开始安装

所有⚠️消失后，点击"**开始安装**"，如[图15](#fig1717019357392)所示。

**图 15**  开始安装<a name="fig1717019357392"></a>
    
![](./figures/Installation_Procedure.png)

**预期结果**：

```ini
安装进度条显示...
正在安装软件包...
安装完成
```

点击"**重启系统**"。

---

## Step 4：验证安装成功

### 4.1 登录系统

重启后进入命令行登录界面：

```bash
openEuler 24.03 LTS SP3
Kernel 6.6.x on an aarch64

localhost login:
```

输入用户名和密码登录。

### 4.2 查看系统信息

```bash
cat /etc/os-release
```

**预期输出**：

```bash
NAME="openEuler"
VERSION="24.03 (LTS SP3)"
ID="openeuler"
VERSION_ID="24.03"
```

### 4.3 查看硬件信息

查看CPU：

```bash
lscpu
```

**预期输出**：

```bash
Architecture:        aarch64
CPU(s):              <核心数>
Model name:          <CPU型号>
```

查看内存：

```bash
free -h
```

**预期输出**：

```bash
              total        used        free
Mem:           <大小>      ...
```

查看磁盘：

```bash
fdisk -l
```

查看IP：

```bash
ip addr
```

### 4.4 完成基础初始化（推荐）

```bash
# 更新系统
dnf update -y

# 设置时区
timedatectl set-timezone Asia/Shanghai

# 验证时间同步
systemctl status chronyd
```

**预期输出**：

```bash
dnf update: Complete!
chronyd: active (running)
```

---

## 常见问题（FAQ）

### Q1：安装引导界面未出现？

**原因**：启动顺序未正确设置。

**解决方案**：

1. 进入BIOS/iBMC
2. 确认启动设备为虚拟光驱/光盘
3. 保存后重启

### Q2：磁盘未被识别？

**原因**：RAID控制器驱动缺失。

**解决方案**：
参考 openEuler 社区论坛：[手动加载驱动方法示例](https://forum.openeuler.org/t/topic/616)。

### Q3：密码设置失败？

**原因**：密码未满足复杂度要求。

**解决方案**：
确保密码：

- ≥8字符
- 含大小写+数字+特殊字符中的3种
- 非字典词汇

### Q4：dnf update网络错误？

**原因**：网络或DNS未配置。

**解决方案**：

```bash
nmtui
```

重新配置网络和DNS。

### Q5：`chronyd` 服务未运行，怎么启用？

**原因**：服务可能未设置为开机自启。运行以下命令启用并立即启动：

**解决方案**：

```bash
systemctl enable --now chronyd
```

---

## 下一步

| 场景 | 推荐路径 |
|------|----------|
| **部署应用服务** | → [搭建 Web 服务器](https://docs.openeuler.org/zh/docs/24.03_LTS_SP3/server/administration/administrator/configuring_the_web_server.html) |
| | → [搭建数据库服务器](https://docs.openeuler.org/zh/docs/24.03_LTS_SP3/server/administration/administrator/setting_up_the_database_server.html) |
| **学习系统管理** | → [管理员指南](https://docs.openeuler.openatom.cn/zh/docs/24.03_LTS_SP3/server/administration/administrator/viewing_system_information.html) |
| **遇到问题** | → [社区论坛](https://forum.openeuler.org/) · [提交Issue](https://atomgit.com/openeuler/community/issues) |

---

*本指南适用于 openEuler 24.03 LTS SP3 物理服务器安装。虚拟机安装请参考[虚拟化部署指南](https://docs.openeuler.openatom.cn/zh/docs/24.03_LTS_SP3/virtualization/virtulization_platform/virtulization/introduction_to_virtualization.html)。*

*最后更新：2026-04-17*

*如发现文档错误，请在 [Gitee Issue](https://atomgit.com/openeuler/docs/issues) 提交反馈。*

---

**文档来源**：openEuler社区官方文档

---
