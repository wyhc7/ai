#!/usr/bin/env bash
# 在 Linux (systemd) 上安装 AI 中转站
# 用法: sudo bash install.sh
set -euo pipefail

APP_DIR=/opt/ai-gateway
SERVICE_NAME=ai-gateway
USER_NAME=ai-gateway
PORT=${PORT:-3001}
REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

echo "==> 检查 Node.js"
if ! command -v node >/dev/null 2>&1; then
  echo "未检测到 Node.js（需 >= 18），请先安装："
  echo "  Ubuntu/Debian:  sudo apt-get install -y nodejs npm"
  echo "  RHEL/CentOS:    sudo yum install -y nodejs npm"
  exit 1
fi

echo "==> 创建运行用户 ${USER_NAME}"
id -u ${USER_NAME} >/dev/null 2>&1 || useradd --system --create-home --shell /usr/sbin/nologin ${USER_NAME}

echo "==> 复制代码到 ${APP_DIR}"
mkdir -p ${APP_DIR}
cp -r "${REPO_DIR}/server" "${REPO_DIR}/web" "${REPO_DIR}/package.json" "${APP_DIR}/"
mkdir -p ${APP_DIR}/data

echo "==> 安装依赖并构建前端"
npm install --prefix ${APP_DIR}/server --omit=dev
npm install --prefix ${APP_DIR}/web
npm run build --prefix ${APP_DIR}/web
npm install --prefix ${APP_DIR}/web --omit=dev

echo "==> 设置权限"
chown -R ${USER_NAME}:${USER_NAME} ${APP_DIR}
chmod 700 ${APP_DIR}/data

echo "==> 安装 systemd 服务"
NODE_BIN="$(command -v node)"
sed -e "s|@NODE_BIN@|${NODE_BIN}|g" \
    -e "s|@APP_DIR@|${APP_DIR}|g" \
    -e "s|@PORT@|${PORT}|g" \
    "${REPO_DIR}/deploy/linux/ai-gateway.service" > /etc/systemd/system/${SERVICE_NAME}.service
systemctl daemon-reload
systemctl enable ${SERVICE_NAME}
systemctl start ${SERVICE_NAME}

echo "==> 等待服务启动"
for i in $(seq 1 15); do
  if curl -sf "http://127.0.0.1:${PORT}/api/health" >/dev/null 2>&1; then
    echo "安装完成，管理界面: http://<服务器IP>:${PORT}"
    exit 0
  fi
  sleep 1
done

echo "警告: 服务已启动但健康检查未通过，请查看日志: journalctl -u ${SERVICE_NAME} -f"
