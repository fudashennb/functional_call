# Function Call - AMR机器人控制系统

基于Gemini AI的AMR（自主移动机器人）控制系统，通过自然语言与机器人交互。

## 功能特性

- 🤖 自然语言控制AMR机器人
- 🔌 通过Modbus协议与机器人通信
- 📊 实时获取机器人状态、电池信息、任务统计等
- 🚀 基于FastAPI的HTTP服务器
- 🧠 使用Gemini 2.0 Flash模型进行智能决策

## 环境要求

- Python 3.10+
- Conda环境管理器

## 安装步骤

1. 克隆仓库：
```bash
git clone git@github.com:fudashennb/functional_call.git
cd functional_call
```

2. 创建并激活conda环境：
```bash
conda create -n text_to_speech python=3.10
conda activate text_to_speech
```

3. 安装依赖：
```bash
pip install -r requirements.txt  # 如果有的话
```

4. 配置环境变量：
```bash
cp .env.example .env
# 编辑 .env 文件，填入您的Gemini API密钥
```

## 配置说明

### API密钥配置

您需要获取Gemini API密钥并配置：

1. 访问 [Google AI Studio](https://makersuite.google.com/app/apikey) 获取API密钥
2. 创建 `.env` 文件（可以复制 `.env.example`）
3. 在 `.env` 文件中设置：
```bash
GEMINI_API_KEY=your_actual_api_key_here
```

### Modbus配置

如果需要通过SSH隧道连接到远程AGV设备：

```bash
ssh -f -N -L 1502:localhost:502 -p 2222 root@10.10.70.218
```

## 使用方法

### 方式1：使用启动脚本（推荐）

启动脚本会自动检查并建立SSH隧道：

```bash
./start_server.sh
```

### 方式2：手动启动

1. 建立SSH隧道（如果尚未建立）：
```bash
ssh -f -N -L 1502:localhost:502 -p 2222 root@10.10.70.218
```

2. 启动服务器：
```bash
conda activate text_to_speech
python3 agent/gemini_server.py
```

服务器将在 `http://0.0.0.0:8766` 启动。

### API端点

- `POST /chat` - 发送对话请求
  ```json
  {
    "message": "导航到站点一"
  }
  ```

## 项目结构

```
function_call/
├── agent/
│   ├── config.py           # 配置文件
│   ├── gemini_agent.py     # Gemini AI代理
│   ├── gemini_server.py    # FastAPI服务器
│   └── modbus_ai_cmd.py    # Modbus通信接口
├── src/
│   ├── sr_modbus_model.py  # Modbus数据模型
│   └── sr_modbus_sdk.py    # Modbus SDK
├── log_config.py           # 日志配置
├── .env.example            # 环境变量示例
└── .gitignore              # Git忽略文件
```

## 机器人控制指令

系统支持以下功能：

### 基础控制
- 移动到指定站点：`导航到站点一`
- 执行动作任务：`顶升到50`
- 获取电池信息：`查看电池状态`

### 信息查询
- AGV基本信息、任务状态
- 性能统计、故障信息
- 充电统计、工单信息
- 各种趋势数据

## 注意事项

⚠️ **安全提醒**：
- 不要将 `.env` 文件提交到Git仓库
- 不要在代码中硬编码API密钥
- 定期更换API密钥

## 许可证

[添加您的许可证信息]

## 联系方式

[添加您的联系方式]

