# シンプルなテスト用 Dockerfile
# nginx をベースに静的HTMLを配置するだけのシンプルな構成
FROM nginx:1.25-alpine

# 静的コンテンツをコピー
COPY html/ /usr/share/nginx/html/

# ⚠️ セキュリティ問題のデモ用 - ハードコードされたシークレット（ダミー値）
# FCS CLI IaC スキャンで検知されることを確認するためのテスト用コード
ENV AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
ENV AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
ENV DB_PASSWORD=XXXXXXXXXXXXXXXXXXXXXXXX

# ⚠️ rootユーザーで実行（セキュリティ問題）
# USER root

# ⚠️ 不要な特権付与
# RUN chmod 777 /usr/share/nginx/html

# ポート80を公開
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
