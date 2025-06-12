#!/bin/bash

# ======================
# 🔧 AZTEC PROVER - MENU
# ======================

IMAGE="aztecprotocol/aztec:0.87.8"
NETWORK="alpha-testnet"
DEFAULT_DATA_DIR="/root/aztec-prover"
DEFAULT_P2P_PORT="40400"
DEFAULT_API_PORT="8080"

# Logo
echo -e "\033[0;35m"
echo "//==========================================================================\\"
echo "||░██═╗░░░░░░░██╗░███╗░░██╗░███████═╗░░███╗░░██╗ █████╗░██████═╗░░░███████╗░||"
echo "||░░██╚╗░░░░░██╔╝░████╗░██║░██╔══███╝░░████╗░██║██╔══██╗██╔══ ██╚╗░██╔════╝░||"
echo "||░░░██╚╗░░░██╔╝░░██╔██╗██║░██████╔╝░░░██╔██╗██║██║░░██║██║░░░░██║░█████╗░░░||"  
echo "||░░░░██╚╗░██╔╝░░░██║╚████║ ██╔══███╗░░██║╚████║██║░░██║██╚══ ██╔╝░██╔══╝░░░||"
echo "||░░░░░█████╔╝░░░░██║░╚███║ ███████ ║░░██║░╚███║╚█████╔╝██████░║░░░███████╗░||"
echo "||░░░░░░╚═══╝░░░░░╚═╝░░╚══╝░╚══════╝░░░╚═╝░░╚══╝░╚════╝░╚══════╝░░░╚══════╝░||"
echo "\\==========================================================================//"
echo -e "\e[0m"
sleep 3

install_dependencies() {
  echo "🔧 Đang cài đặt các gói cần thiết..."
  apt-get update && apt-get upgrade -y
  apt install -y screen curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf \
    tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip fzf

  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
  apt-get install -y nodejs
  npm install -g yarn
}

compose_cmd() {
  if command -v docker &>/dev/null && docker compose version &>/dev/null; then
    echo "docker compose"
  elif command -v docker-compose &>/dev/null; then
    echo "docker-compose"
  else
    return 1
  fi
}

check_and_install_docker() {
  if ! compose_cmd &>/dev/null; then
    echo "🔧 Docker Compose chưa có. Đang cài đặt..."
    source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/docker-install.sh)

    # Kiểm tra lại sau khi cài
    if ! compose_cmd &>/dev/null; then
      echo "❌ Cài đặt Docker Compose thất bại. Thoát..."
      exit 1
    fi
  else
    echo "✅ Docker Compose đã sẵn sàng."
  fi
}

load_env_or_prompt() {
  # Tự động cài fzf nếu chưa có
  command -v fzf >/dev/null 2>&1 || {
    echo "📦 Đang cài đặt fzf..."
    apt update -y && apt install fzf -y
  }

  ENV_FILE="$DEFAULT_DATA_DIR/.env"
  WAN_IP=$(curl -s ifconfig.me)

  declare -A ICONS=(
    ["IMAGE"]="🖼️ "
    ["NETWORK"]="🪐"
    ["WAN_IP"]="🌐"
    ["P2P_PORT"]="🔌"
    ["API_PORT"]="🧩"
    ["RPC_SEPOLIA"]="🛰️ "
    ["BEACON_SEPOLIA"]="📡"
    ["PRIVATE_KEY"]="🔐"
    ["PROVER_ID"]="🪪 "
    ["AGENT_COUNT"]="👷"
    ["DATA_DIR"]="📂"
  )

  if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
    IMAGE="${IMAGE:-aztecprotocol/aztec:0.87.8}"
    NETWORK="${NETWORK:-alpha-testnet}"

    env_lines=(
      "IMAGE=$IMAGE"
      "NETWORK=$NETWORK"
      "WAN_IP=$WAN_IP"
      "P2P_PORT=$P2P_PORT"
      "API_PORT=$API_PORT"
      "RPC_SEPOLIA=$RPC_SEPOLIA"
      "BEACON_SEPOLIA=$BEACON_SEPOLIA"
      "PRIVATE_KEY=$PRIVATE_KEY"
      "PROVER_ID=$PROVER_ID"
      "AGENT_COUNT=$AGENT_COUNT"
      "DATA_DIR=$DATA_DIR"
    )

    echo "🔄 .env hiện tại:"
    for i in "${!env_lines[@]}"; do
      key="${env_lines[$i]%%=*}"
      val="${env_lines[$i]#*=}"
      [[ "$key" == "PRIVATE_KEY" ]] && val="********"
      printf "%2d. %-3s %-15s = %s\n" "$((i+1))" "${ICONS[$key]}" "$key" "$val"
    done

    echo ""
    CHOICE=$(printf "✅ Có\n❌ Không" | fzf --prompt="🔁 Bạn có muốn chỉnh sửa các biến môi trường? " --height=10 --reverse)
    fzf_status=$?
    if [[ $fzf_status -ne 0 ]]; then
      echo "🔙 Bạn đã huỷ. Quay lại menu chính..."
      return 1
    fi

    if [[ "$CHOICE" == "✅ Có" ]]; then
      while true; do
        echo ""
        echo "🔯 Chọn biến cần thay đổi:"
        display_lines=()
        for line in "${env_lines[@]}"; do
          key="${line%%=*}"
          val="${line#*=}"
          [[ "$key" == "PRIVATE_KEY" ]] && val="********"
          display_lines+=("${ICONS[$key]} $key=$val")
        done

        selected=$(printf "%s\n" "${display_lines[@]}" "💾 Lưu và tiếp tục" | fzf --prompt="🔧 Chọn biến: " --height=40% --reverse)
        fzf_status=$?

        if [[ $fzf_status -ne 0 ]]; then
          echo "🔙 Bạn đã huỷ chọn biến, quay lại menu chính..."
          return 1
        fi

        if [[ "$selected" == "💾 Lưu và tiếp tục" ]]; then
          break
        elif [[ -n "$selected" ]]; then
          key=$(echo "$selected" | awk '{print $2}' | cut -d'=' -f1)

          # Tìm giá trị cũ
          old_val=""
          for i in "${!env_lines[@]}"; do
            if [[ "${env_lines[$i]%%=*}" == "$key" ]]; then
              old_val="${env_lines[$i]#*=}"
              break
            fi
          done

          prompt_val="********"
          [[ "$key" != "PRIVATE_KEY" ]] && prompt_val="$old_val"

          # Dùng fzf để nhập giá trị mới với print-query
          new_val=$(printf "" | fzf --prompt="🔧 Nhập giá trị mới cho $key (hiện tại: $prompt_val): " --print-query --height=10 --border --reverse)
          fzf_status=$?
          if [[ $fzf_status -ne 0 ]]; then
            echo "🔙 Bạn đã huỷ nhập giá trị, quay lại chọn biến..."
            continue
          fi

          new_val="${new_val:-$old_val}"

          # Cập nhật lại giá trị trong env_lines
          for i in "${!env_lines[@]}"; do
            if [[ "${env_lines[$i]%%=*}" == "$key" ]]; then
              env_lines[$i]="$key=$new_val"
            fi
          done
        fi
      done
    fi

  else
    echo "📄 Tạo file .env mới..."

    read -p "🖼️ Nhập Docker image (mặc định: aztecprotocol/aztec:0.87.8): " IMAGE
    IMAGE="${IMAGE:-aztecprotocol/aztec:0.87.8}"

    read -p "🪐 Nhập network (mặc định: alpha-testnet): " NETWORK
    NETWORK="${NETWORK:-alpha-testnet}"

    read -p "🔍 Nhập Sepolia RPC URL: " RPC_SEPOLIA
    read -p "🔍 Nhập Beacon API URL: " BEACON_SEPOLIA
    read -s -p "🔐 Nhập Publisher Private Key: " PRIVATE_KEY
    echo ""
    read -p "💼 Nhập Prover ID: " PROVER_ID
    read -p "🔢 Nhập số agent (mặc định: 1): " AGENT_COUNT
    AGENT_COUNT="${AGENT_COUNT:-1}"

    read -p "🏠 Nhập P2P Port [mặc định: $DEFAULT_P2P_PORT]: " P2P_PORT
    P2P_PORT="${P2P_PORT:-$DEFAULT_P2P_PORT}"

    read -p "🏠 Nhập API Port [mặc định: $DEFAULT_API_PORT]: " API_PORT
    API_PORT="${API_PORT:-$DEFAULT_API_PORT}"

    read -p "📂 Nhập thư mục lưu dữ liệu [mặc định: $DEFAULT_DATA_DIR]: " INPUT_DIR
    DATA_DIR="${INPUT_DIR:-$DEFAULT_DATA_DIR}"
    mkdir -p "$DATA_DIR"

    env_lines=(
      "IMAGE=$IMAGE"
      "NETWORK=$NETWORK"
      "WAN_IP=$WAN_IP"
      "P2P_PORT=$P2P_PORT"
      "API_PORT=$API_PORT"
      "RPC_SEPOLIA=$RPC_SEPOLIA"
      "BEACON_SEPOLIA=$BEACON_SEPOLIA"
      "PRIVATE_KEY=$PRIVATE_KEY"
      "PROVER_ID=$PROVER_ID"
      "AGENT_COUNT=$AGENT_COUNT"
      "DATA_DIR=$DATA_DIR"
    )
  fi

  echo ""
  echo "💾 Đang ghi tệp .env..."
  printf "%s\n" "${env_lines[@]}" > "$ENV_FILE"
  source "$ENV_FILE"
}

generate_compose() {
  COMPOSE_FILE="$DATA_DIR/docker-compose.yml"

  cat > "$COMPOSE_FILE" <<EOF
version: '3.8'
services:
  prover_node:
    image: $IMAGE
    container_name: prover_node
    entrypoint: >
      sh -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js start
      --prover-node --archiver --network $NETWORK'
    depends_on:
      broker:
        condition: service_started
    env_file:
      - .env
    environment:
      P2P_IP: "\${WAN_IP}"
      P2P_ANNOUNCE_ADDRESSES: "/ip4/\${WAN_IP}/tcp/\${P2P_PORT}"
      ETHEREUM_HOSTS: "\${RPC_SEPOLIA}"
      L1_CONSENSUS_HOST_URLS: "\${BEACON_SEPOLIA}"
      PROVER_PUBLISHER_PRIVATE_KEY: "\${PRIVATE_KEY}"
      PROVER_ENABLED: "true"
      P2P_ENABLED: "true"
      P2P_TCP_PORT: "\${P2P_PORT}"
      P2P_UDP_PORT: "\${P2P_PORT}"
      DATA_STORE_MAP_SIZE_KB: "134217728"
      LOG_LEVEL: "debug"
      PROVER_BROKER_HOST: "http://broker:\${API_PORT}"
    ports:
      - "\${API_PORT}:\${API_PORT}"
      - "\${P2P_PORT}:\${P2P_PORT}"
      - "\${P2P_PORT}:\${P2P_PORT}/udp"
    volumes:
      - \${DATA_DIR}/node:/data

  broker:
    image: $IMAGE
    container_name: broker
    entrypoint: >
      sh -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js start
      --prover-broker --network $NETWORK'
    env_file:
      - .env
    environment:
      DATA_DIRECTORY: /data
      ETHEREUM_HOSTS: "\${RPC_SEPOLIA}"
      LOG_LEVEL: "debug"
    volumes:
      - \${DATA_DIR}/broker:/data
EOF

  for i in $(seq 1 "$AGENT_COUNT"); do
    cat >> "$COMPOSE_FILE" <<EOF

  agent_$i:
    image: $IMAGE
    container_name: agent_$i
    entrypoint: >
      sh -c 'node --no-warnings /usr/src/yarn-project/aztec/dest/bin/index.js start
      --prover-agent --network $NETWORK'
    env_file:
      - .env
    environment:
      PROVER_ID: "\${PROVER_ID}"
      PROVER_BROKER_HOST: "http://broker:\${API_PORT}"
      PROVER_AGENT_POLL_INTERVAL_MS: "10000"
    depends_on:
      - broker
    restart: unless-stopped
EOF
  done
}

install_prover() {
  load_env_or_prompt || return

  install_dependencies
  check_and_install_docker
  generate_compose

  echo ""
  echo "🚀 Khởi động container..."
  cd "$DATA_DIR"
  $(compose_cmd) up -d

  echo ""
  echo "🎉 Hoàn tất triển khai tại: $DATA_DIR"
}

view_logs() {
  echo "📜 Running Aztec Prover Logs..."

  [ -f "$DEFAULT_DATA_DIR/.env" ] && source "$DEFAULT_DATA_DIR/.env"
  if [ -z "$DATA_DIR" ] || [ ! -d "$DATA_DIR" ]; then
    echo "❌ Không tìm thấy thư mục DATA_DIR: $DATA_DIR"
    return
  fi

  cd "$DATA_DIR" || { echo "❌ Không thể cd vào $DATA_DIR"; return; }

  CONTAINERS=$(docker ps --format "{{.Names}}" || true)
  HAS_PROVER=$(echo "$CONTAINERS" | grep -E "^(prover_node|broker)$" || true)
  HAS_AGENTS=$(echo "$CONTAINERS" | grep -E "^agent_[0-9]+$" || true)

  if [ -z "$CONTAINERS" ]; then
    echo "❌ Không có container nào đang chạy!"
    return
  fi

  if command -v docker-compose &>/dev/null; then CMD="docker-compose"; else CMD="docker compose"; fi

  while true; do
    OPTIONS=""
    [ -n "$HAS_PROVER" ] && OPTIONS+="🔎 Logs của prover_node & broker\n"
    [ -n "$HAS_AGENTS" ] && OPTIONS+="🧑‍🚀 Logs của các agent_*\n"
    OPTIONS+="🧾 View all logs"

    SELECTED=$(echo -e "$OPTIONS" | fzf --height=12 --border --prompt="🔍 Chọn cách xem logs: " --reverse) || return

    case "$SELECTED" in
      "🔎 Logs của prover_node & broker")
        (
          colors=(35 36)
          i=0
          pids=()
          for name in prover_node broker; do
            if docker ps --format '{{.Names}}' | grep -qx "$name"; then
              color=${colors[$i]}
              docker logs --tail=100 -f "$name" 2>&1 \
                | sed -u "s/^/\x1b[1;${color}m[$name]\x1b[0m /" &
              pids+=($!)
            fi
            ((i++))
          done
          trap 'kill "${pids[@]}" 2>/dev/null' SIGINT
          wait
        )
        ;;

      "🧑‍🚀 Logs của các agent_*")
        (
          colors=(31 32 33 34 35 36 91 92 93 94)
          i=0
          pids=()
          for container in $HAS_AGENTS; do
            color=${colors[$((i % ${#colors[@]}))]}
            docker logs --tail=100 -f "$container" 2>&1 \
              | sed -u "s/^/\x1b[1;${color}m[$container]\x1b[0m /" &
            pids+=($!)
            ((i++))
          done
          trap 'kill "${pids[@]}" 2>/dev/null' SIGINT
          wait
        )
        ;;

      "🧾 View all logs")
        $CMD -f "$DATA_DIR/docker-compose.yml" logs --tail=100 -f
        ;;
    esac

    # Sau mỗi lần xem logs xong (Ctrl+C), quay lại menu chọn kiểu logs
  done
}

delete_prover() {
  echo "⚠️  Bạn có chắc chắn muốn xoá container Prover không?"
  CHOICE=$(printf "✅ Có\n❌ Không" | fzf --prompt="👉 Chọn: " --height=6 --border --reverse)

  if [[ "$CHOICE" == "✅ Có" ]]; then
    source "$DEFAULT_DATA_DIR/.env" 2>/dev/null
    DATA_DIR=${DATA_DIR:-$DEFAULT_DATA_DIR}
    if [ -d "$DATA_DIR" ]; then
      cd "$DATA_DIR" && $(compose_cmd) down -v
      echo "🧹 Đã xoá container Prover."
    else
      echo "⚠️ Không tìm thấy thư mục dữ liệu: $DATA_DIR"
    fi
  else
    echo "❎ Đã huỷ thao tác xoá container."
  fi
}

reset_prover() {
  echo "💣 Bạn sắp xoá toàn bộ container và dữ liệu!"
  CHOICE=$(printf "✅ Có, reset toàn bộ\n❌ Không" | fzf --prompt="👉 Chọn: " --height=6 --border --reverse)

  if [[ "$CHOICE" == "✅ Có, reset toàn bộ" ]]; then
    delete_prover
    if [ -d "$DEFAULT_DATA_DIR" ]; then
      echo "🗑️ Đang xoá dữ liệu tại: $DEFAULT_DATA_DIR"
      rm -rf "$DEFAULT_DATA_DIR"
      echo "✅ Reset hoàn tất."
    else
      echo "⚠️ Thư mục dữ liệu không tồn tại: $DEFAULT_DATA_DIR (bỏ qua xoá)"
    fi
  else
    echo "❎ Đã huỷ thao tác reset."
  fi
}

# ---------- Menu ----------
while true; do
  echo ""
  echo "=============================="
  echo "🛠 AZTEC PROVER DEPLOYMENT TOOL"
  echo "=============================="

  OPTION=$(printf \
"🚀 Cài đặt và khởi động Prover\n\
📜 Xem logs\n\
🧹 Xoá Prover\n\
💣 Xoá toàn bộ dữ liệu (reset)\n\
❌ Thoát" | fzf --height=12 --border --prompt="👉 Chọn tùy chọn: " --ansi --reverse)

  # Nếu người dùng bấm ESC hoặc Ctrl+C, thoát menu luôn
  if [[ $? -ne 0 ]]; then
    echo "👋 Thoát..."
    exit 0
  fi

  case "$OPTION" in
    "🚀 Cài đặt và khởi động Prover") install_prover ;;
    "📜 Xem logs") view_logs ;;
    "🧹 Xoá Prover") delete_prover ;;
    "💣 Xoá toàn bộ dữ liệu (reset)") reset_prover ;;
    "❌ Thoát") echo "👋 Tạm biệt!"; exit 0 ;;
    *) echo "❌ Tùy chọn không hợp lệ!" ;;
  esac
done
