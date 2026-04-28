# CICD Playground - FCS CLI スキャンデモ

このリポジトリは、CrowdStrike Falcon Cloud Security CLI (FCS CLI) を使って  
Pull Request 時に Docker イメージをスキャンする CI/CD パイプラインのデモです。

## 構成

```
cicd-playground/
├── Dockerfile                          # テスト用 Dockerfile (nginx ベース)
├── html/
│   └── index.html                      # 静的コンテンツ
├── .github/
│   └── workflows/
│       └── fcs-scan.yml               # GitHub Actions ワークフロー
└── README.md
```

## 動作フロー

1. `main` ブランチへの Pull Request を作成
2. GitHub Actions が自動起動
3. `Dockerfile` から Docker イメージをビルド
4. FCS CLI をダウンロード
5. FCS CLI でビルドしたイメージをスキャン
6. スキャン結果を GitHub Actions の Artifact として保存

## セットアップ手順

### 1. GitHub Secrets の設定

リポジトリの **Settings > Secrets and variables > Actions** から以下の Secrets を登録してください。

| Secret 名             | 内容                                                        |
|-----------------------|-------------------------------------------------------------|
| `FALCON_CLIENT_ID`    | CrowdStrike API クライアント ID                             |
| `FALCON_CLIENT_SECRET`| CrowdStrike API クライアントシークレット                    |
| `FALCON_API_URL`      | API ベース URL (例: `https://api.crowdstrike.com`)          |
| `FALCON_CLOUD`        | Falconリージョン (例: `us-1`, `us-2`, `eu-1`)              |

### 2. API クライアントの必要スコープ

Falcon コンソールの **Support and resources > API clients and keys** で API クライアントを作成し、  
以下のスコープを付与してください。

| スコープ                      | 権限         |
|-------------------------------|--------------|
| Cloud Security Tools Download | Read         |
| Falcon Container CLI          | Read / Write |
| Falcon Container Image        | Read / Write |

### 3. Pull Request を作成してテスト

```bash
# feature ブランチを作成
git checkout -b feature/test-scan

# Dockerfile や html を変更
# (例) html/index.html を編集

# コミット & プッシュ
git add .
git commit -m "test: FCS CLIスキャンのテスト"
git push origin feature/test-scan

# GitHub 上で main ブランチへの Pull Request を作成
```

## ワークフローのトリガー条件

以下のファイルが変更された Pull Request 時のみスキャンが実行されます。

- `Dockerfile`
- `html/**`

## スキャン結果の確認

- GitHub Actions の **Actions** タブから実行結果を確認
- 各 PR の Actions ログでスキャン結果をリアルタイム確認
- スキャンレポート (JSON) は **Artifacts** としてダウンロード可能 (30日保持)

## FCS CLI スキャンの設定

現在のワークフローでは以下のオプションでスキャンしています。

```bash
fcs scan image <image-name> \
  --format json \
  --output /tmp/fcs-scan-report.json \
  --minimum-severity medium    # medium 以上の脆弱性を報告
```

スキャン終了コードの意味:
- `0`: イメージはポリシー要件を満たしている
- `1`: イメージはポリシー要件を満たさず、ブロックすべき
- `2`: イメージはポリシー要件を満たさず、アラートを送信すべき
