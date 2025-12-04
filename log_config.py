#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
统一的日志配置模块
为整个项目提供统一的日志配置
"""

import logging
import os
from pathlib import Path
from datetime import datetime

# 获取项目根目录
_project_root = Path(__file__).resolve().parent if '__file__' in globals() else Path.cwd()
_log_dir = _project_root / 'logs'

# 创建日志目录
_log_dir.mkdir(exist_ok=True)


def setup_logging():
    """
    配置统一的日志系统
    设置根日志记录器的配置，所有子记录器都会继承这些设置
    """
    # 获取根日志记录器
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.DEBUG)
    
    # 清除已有的处理器（避免重复添加）
    root_logger.handlers.clear()
    
    # 创建日志格式（包含文件名和行号）
    log_format = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - [%(filename)s:%(lineno)d] - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    # 创建控制台处理器
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_handler.setFormatter(log_format)
    
    # 创建文件处理器（所有日志写入同一个文件）
    log_file = _log_dir / f'all_main_{datetime.now().strftime("%Y%m%d")}.log'
    file_handler = logging.FileHandler(log_file, encoding='utf-8')
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(log_format)
    
    # 添加处理器到根记录器
    root_logger.addHandler(console_handler)
    root_logger.addHandler(file_handler)
    
    return root_logger


# 自动执行日志配置
setup_logging()

