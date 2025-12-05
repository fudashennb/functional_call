#!/bin/bash
# Gemini服务器启动脚本
# 自动检查并建立SSH隧道

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 启动Gemini服务器...${NC}"

# 检查SSH隧道
check_ssh_tunnel() {
    if netstat -tlnp 2>/dev/null | grep -q ":1502" || ss -tlnp 2>/dev/null | grep -q ":1502"; then
        return 0
    else
        return 1
    fi
}

# 建立SSH隧道
setup_ssh_tunnel() {
    echo -e "${YELLOW}📡 正在建立SSH隧道...${NC}"
    ssh -f -N -L 1502:localhost:502 -p 2222 root@10.10.70.218 2>&1
    
    sleep 1
    
    if check_ssh_tunnel; then
        echo -e "${GREEN}✅ SSH隧道已建立${NC}"
        return 0
    else
        echo -e "${RED}❌ SSH隧道建立失败${NC}"
        echo -e "${YELLOW}💡 请手动建立SSH隧道:${NC}"
        echo -e "   ssh -f -N -L 1502:localhost:502 -p 2222 root@10.10.70.218"
        return 1
    fi
}

# 检查conda环境
check_conda_env() {
    if ! command -v conda &> /dev/null; then
        echo -e "${RED}❌ 未找到conda命令${NC}"
        return 1
    fi
    
    if ! conda env list | grep -q "text_to_speech"; then
        echo -e "${YELLOW}⚠️  未找到text_to_speech环境，请先创建:${NC}"
        echo -e "   conda create -n text_to_speech python=3.10"
        return 1
    fi
    
    return 0
}

# 主流程
main() {
    # 检查conda环境
    if ! check_conda_env; then
        exit 1
    fi
    
    # 检查SSH隧道
    if ! check_ssh_tunnel; then
        echo -e "${YELLOW}⚠️  未检测到SSH隧道${NC}"
        if ! setup_ssh_tunnel; then
            echo -e "${RED}❌ 无法建立SSH隧道，退出${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✅ SSH隧道已存在${NC}"
    fi
    
    # 检查.env文件
    if [ ! -f ".env" ]; then
        echo -e "${YELLOW}⚠️  未找到.env文件${NC}"
        echo -e "${YELLOW}💡 请创建.env文件并配置GEMINI_API_KEY${NC}"
        exit 1
    fi
    
    # 启动服务器
    echo -e "${GREEN}🎯 启动Gemini服务器...${NC}"
    echo ""
    
    # 获取conda环境的Python路径并直接运行，确保日志实时显示
    CONDA_ENV_PATH=$(conda env list | grep "^text_to_speech" | awk '{print $NF}' | head -1)
    
    if [ -z "$CONDA_ENV_PATH" ] || [ ! -f "$CONDA_ENV_PATH/bin/python3" ]; then
        echo -e "${RED}❌ 无法找到conda环境的Python解释器${NC}"
        exit 1
    fi
    
    # 设置环境变量禁用Python输出缓冲，确保日志实时显示
    export PYTHONUNBUFFERED=1
    "$CONDA_ENV_PATH/bin/python3" -u agent/gemini_server.py
}

main "$@"

