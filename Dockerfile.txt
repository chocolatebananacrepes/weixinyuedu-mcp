# 微信读书 MCP 远程服务（供 Kelivo 通过 MCP 连接）
# 原理：mcp-weread 是一个"本地 stdio"程序，Kelivo 手机/电脑上跑不起来，
#       所以用 supergateway 把它包成一个公网 HTTPS 网址，Kelivo 直接连这个网址即可。

FROM node:20-slim

# 安装 Python 并在独立虚拟环境里安装 mcp-weread（它是 Python 写的）
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv \
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir mcp-weread \
    && rm -rf /var/lib/apt/lists/*

# 让命令行能直接找到 mcp-weread
ENV PATH="/opt/venv/bin:$PATH"

# 服务监听 8080 端口（Zeabur 里也要填 8080）
EXPOSE 8080

# 启动命令：supergateway 桥接，对外提供 Streamable HTTP，地址是 /mcp
# 注意：WEREAD_API_KEY 不要写在这里！去 Zeabur 后台的"变量"里填。
CMD ["npx", "-y", "supergateway", \
     "--stdio", "mcp-weread", \
     "--outputTransport", "streamableHttp", \
     "--stateful", \
     "--streamableHttpPath", "/mcp", \
     "--port", "8080"]
