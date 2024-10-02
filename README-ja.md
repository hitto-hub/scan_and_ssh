# scan_and_ssh

ただのSSH。それ以外は何もありません。

## 構成

```md
.
├── README.md
├── scan_and_ssh.sh # メインスクリプト
└── key_connect.sh　# ホストをスキャンし、SSHキーでフィルタリングします。
```

## ファイル概要

### scan_and_ssh.sh

`scan_and_ssh.sh`は、指定されたIPレンジ内でSSHポートが開いているホストをスキャンし、SSH接続を試みるスクリプトです。ユーザーは、スキャンするIPレンジやポート、SSH接続に使用するユーザー名とSSHキーのパスを動的に指定できます。fzfを使って、ホストやSSHキーを簡単に選択することも可能です。スクリプトは、接続可能なホストをリストアップし、選択したホストに対してSSH接続を試行します。

### key_connect.sh

`key_connect.sh`は、SSHキーを利用して接続できるホストをスキャンし、リストアップするためのスクリプトです。IPレンジとポートを指定してスキャンを行い、ユーザーが選択したSSHキーで接続可能なホストをフィルタリングします。こちらもfzfを使って簡単にホストを選択できるオプションを提供しています。

### 前提条件

`scan_and_ssh.sh`および`key_connect.sh`を使用するには、以下の前提条件が必要です。

1. **nmapのインストール**  
   ホストをスキャンするために`nmap`コマンドを使用します。システムに`nmap`がインストールされている必要があります。
   - インストールコマンド（例）:

     ```bash
     sudo apt-get install nmap  # Ubuntu/Debian
     sudo yum install nmap      # CentOS/Fedora
     brew install nmap          # macOS
     ```

2. **fzfのインストール**（オプション）  
   `fzf`を使用して、ホストやSSHキーをインタラクティブに選択するオプションがあります。便利な選択ツールなので、インストールが推奨されます。
   - インストールコマンド（例）:

     ```bash
     sudo apt-get install fzf  # Ubuntu/Debian
     sudo yum install fzf      # CentOS/Fedora
     brew install fzf          # macOS
     ```

3. **SSHキーの準備**  
   SSH接続に使用する公開鍵と秘密鍵が設定されている必要があります。デフォルトでは、`~/.ssh/id_rsa`のキーを使用しますが、カスタマイズすることもできます。

4. **アクセス可能なネットワーク環境**  
   スクリプトを使用するためには、指定したIPレンジ内にアクセス可能なホストが存在する必要があります。適切なネットワーク範囲を指定してください。

5. **スクリプトの実行権限**  
   スクリプトを実行するためには、実行権限が必要です。以下のコマンドで権限を付与してください。

   ```bash
   chmod +x scan_and_ssh.sh
   chmod +x key_connect.sh
   ```

これらの前提条件を満たすことで、スクリプトを問題なく実行できます。

## 使い方

1. `scan_and_ssh.sh`を実行して、スキャンしたホストからSSH接続可能なホストを探し、指定したSSHキーで接続します。
2. `key_connect.sh`は、複数のSSHキーの中から選択し、接続可能なホストを絞り込むのに便利です。
