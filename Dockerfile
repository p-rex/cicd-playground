# シンプルなテスト用 Dockerfile
# nginx をベースに静的HTMLを配置するだけのシンプルな構成
FROM nginx:1.25-alpine

# 静的コンテンツをコピー
COPY html/ /usr/share/nginx/html/

# ⚠️ セキュリティ問題のデモ用（FCS IaC スキャン検知テスト）

# 問題1: rootユーザーで実行（最小権限の原則違反）
USER root

# 問題2: 不要なパッケージのインストール（攻撃面の拡大）
RUN apk add --no-cache curl wget netcat-openbsd

# 問題3: ファイルに過剰な権限を付与
RUN chmod 777 /usr/share/nginx/html

# 問題4: ヘルスチェックなし（可用性の問題）
# HEALTHCHECK は意図的に省略

# ポート80を公開
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
