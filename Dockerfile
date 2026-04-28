# シンプルなテスト用 Dockerfile
# nginx をベースに静的HTMLを配置するだけのシンプルな構成
FROM nginx:1.25-alpine

# 静的コンテンツをコピー
COPY html/ /usr/share/nginx/html/

# ポート80を公開
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
