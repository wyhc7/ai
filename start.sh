#!/bin/bash
# 启动 AI 中转站：后端 3001 + 前端 5173
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"

if [ ! -d "$ROOT/server/node_modules" ]; then
  echo "[start] 安装后端依赖..."
  npm install --prefix "$ROOT/server"
fi

if [ ! -d "$ROOT/web/node_modules" ]; then
  echo "[start] 安装前端依赖..."
  npm install --prefix "$ROOT/web"
fi

# 启动后端服务
cd "$ROOT/server"
node index.js &
BACKEND_PID=$!

# 前台启动前端（Ctrl+C 时一并退出后端）
trap "kill $BACKEND_PID" EXIT INT TERM
cd "$ROOT/web"
node node_modules/vite/bin/vite.js --host 0.0.0.0 --port 5173
