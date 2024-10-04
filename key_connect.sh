#!/bin/bash

# デフォルト設定
DEFAULT_IP=$(ip route get 1.1.1.1 | awk '/src/ {print $7}')  # 自分のIPアドレス取得
DEFAULT_SUBNET=$(ip a | grep $DEFAULT_IP | awk '{print $2}')  # 自分のサブネットマスク取得
DEFAULT_SUBNET=$(echo $DEFAULT_SUBNET | cut -d'.' -f1-3) # DEFAULT_SUBNETを第1,2,3オクテットのみを取得

DEFAULT_IP_RANGE="$DEFAULT_SUBNET.2-254"  # デフォルトのIPレンジ
DEFAULT_PORTS="22"  # スキャンするデフォルトのポート
KEY_PATH="~/.ssh/id_rsa"  # デフォルトの公開鍵パス
TIMEOUT=10  # SSH接続のタイムアウト設定（秒）
SSH_USER=$USER  # デフォルトのSSHユーザー

# ユーザー名を先に指定
read -p "Enter the SSH username (default: $USER): " SSH_USER
SSH_USER=${SSH_USER:-$USER}

# 公開鍵のパスを選択方法に応じて指定
read -p "Enter 'f' to use fzf for selecting the SSH private key, or press Enter to input the path manually: " key_selection_method

if [ "$key_selection_method" == "f" ]; then
    # ~/.sshディレクトリ内の鍵をfzfで選択させる
    echo "Using fzf to select the SSH private key..."
    SSH_KEY_PATH=$(find ~/.ssh -type f -name "*.pub" -prune -o -name "*" -print | fzf)

    # 選択された鍵が正しいか確認
    if [ -z "$SSH_KEY_PATH" ]; then
        echo "Error: No SSH key selected. Exiting."
        exit 1
    fi
else
    # 公開鍵のパスを手動で入力させる
    read -p "Enter the SSH private key path (default: $KEY_PATH): " SSH_KEY_PATH
    SSH_KEY_PATH=${SSH_KEY_PATH:-$KEY_PATH}
fi

# IPレンジをユーザーに動的に指定させる
read -p "Enter IP range to scan (default: $DEFAULT_IP_RANGE): " IP_RANGE
IP_RANGE=${IP_RANGE:-$DEFAULT_IP_RANGE}

# スキャンするポートをユーザーに動的に指定させる（複数ポート対応）
read -p "Enter ports to scan (default: $DEFAULT_PORTS): " PORTS
PORTS=${PORTS:-$DEFAULT_PORTS}

# スキャンして、指定ポートが開いているホストをリストアップ
echo "Scanning IP range $IP_RANGE for open ports $PORTS..."
open_hosts=$(nmap -p $PORTS --open $IP_RANGE -oG - | grep "/open" | awk '{print $2}')
# open_hosts=$(nmap -p $PORTS --open $IP_RANGE -oG - | grep "Up" | awk '{print $2}')

# ポートが開いているホストがない場合、エラーメッセージを表示して終了
if [ -z "$open_hosts" ]; then
    echo "No hosts found with open ports $PORTS in IP range $IP_RANGE. Exiting."
    exit 1
fi

# ポートが開いているホストをリストアップ
echo "The following hosts have open ports $PORTS:"
echo "$open_hosts"

# open_hosts を配列に変換
open_hosts_array=($open_hosts)

# 各ホストに対してSSH接続を試行し、成功したホストのみをリストアップ
reachable_hosts=()
for host in "${open_hosts_array[@]}"; do
    echo "Testing SSH connection to $SSH_USER@$host..."
    ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=$TIMEOUT -o BatchMode=yes -o StrictHostKeyChecking=no "$SSH_USER@$host" exit

    if [ $? -eq 0 ]; then
        echo "Success: Able to connect to $host"
        reachable_hosts+=("$host")
    else
        echo "Failed: Unable to connect to $host"
    fi
done

# 成功したホストがない場合、終了
if [ ${#reachable_hosts[@]} -eq 0 ]; then
    echo "No hosts are reachable with the provided SSH key. Exiting."
    exit 1
fi

# 接続可能なホストをリストアップ
echo "The following hosts are reachable with the provided SSH key:"
for i in "${!reachable_hosts[@]}"; do
    echo "$((i+1)): ${reachable_hosts[i]}"
done

# 選択方法をユーザーに指定させる
read -p "Enter 'f' to use fzf or press Enter to select by number: " selection_method

# fzfを使ってホストを選択する場合
if [ "$selection_method" == "f" ]; then
    echo "Using fzf to select the host..."
    host=$(printf '%s\n' "${reachable_hosts[@]}" | fzf)

    # 選択されたホストが正しいか確認
    if [ -z "$host" ]; then
        echo "Error: No host selected. Exiting."
        exit 1
    fi
else
    # 番号でホストを選択させる
    echo "Select the host to connect to by number:"
    select host in "${reachable_hosts[@]}"; do
        if [ -n "$host" ]; then
            echo "You selected: $host"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
fi

# 接続を試みる
echo "Attempting to SSH into $SSH_USER@$host..."
ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=$TIMEOUT -o BatchMode=yes -o StrictHostKeyChecking=no "$SSH_USER@$host"
