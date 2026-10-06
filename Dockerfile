# 用完整官方Node镜像，彻底避免Alpine兼容性问题
FROM node:20

# 全局安装依赖，提前装好避免运行时下载失败
RUN npm install -g supergateway weread-mcp@latest
RUN sed -i 's/respondError(id, -32000, e.message)/respondError(req.id, -32000, e.message)/' /usr/local/lib/node_modules/weread-mcp/server.js

# 启动命令：
# --host 0.0.0.0 监听所有地址，允许外部访问
# --port 8000 固定端口
# --stdio weread-mcp 用stdio模式启动微信读书MCP
# --outputTransport streamableHttp 转成HTTP协议输出
CMD ["sh", "-c", "supergateway --stdio weread-mcp --outputTransport streamableHttp --host 0.0.0.0 --port 8000"]
