#!/bin/bash

# ======================
# 🔧 AZTEC PROVER - MENU
# ======================

IMAGE="aztecprotocol/aztec:0.87.8"
NETWORK="alpha-testnet"
DEFAULT_DATA_DIR="/root/aztec-prover"
DATA_DIR="$DEFAULT_DATA_DIR"
DEFAULT_P2P_PORT="40400"
DEFAULT_API_PORT="8080"

# Logo
curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Logo/logo.sh | bash && sleep 3

install_dependencies() {
  local MARKER="/usr/local/bin/.aztec_deps_installed"

  if [ -f "$MARKER" ]; then
    echo "✅ Các gói dependencies đã được cài trước đó. Bỏ qua..."
    return
  fi

  echo "🔧 Đang cài đặt các gói cần thiết..."
  apt-get update && apt-get upgrade -y
  apt-get install -y screen curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf \
    tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip fzf

  echo "📦 Đang cài đặt Node.js 22.x và Yarn..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
  apt-get install -y nodejs
  npm install -g yarn

  touch "$MARKER"
  echo "✅ Hoàn tất cài đặt dependencies!"
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
  local MARKER="/usr/local/bin/.aztec_docker_installed"

  if [ -f "$MARKER" ]; then
    echo "✅ Docker và Docker Compose đã được cài đặt. Bỏ qua..."
    return
  fi

  if ! compose_cmd &>/dev/null; then
    echo "🔧 Docker Compose chưa có. Đang cài đặt..."
    bash <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/docker-install.sh)

    if ! compose_cmd &>/dev/null; then
      echo "❌ Cài đặt Docker Compose thất bại. Thoát..."
      exit 1
    fi
  fi

  systemctl enable docker && systemctl start docker
  touch "$MARKER"
  echo "✅ Đã cài đặt Docker và Docker Compose!"
}


# 🚀 Cài đặt các gói cần thiết
install_dependencies
check_and_install_docker

load_env_or_prompt() {
  WAN_IP=$(curl -s ifconfig.me)

  declare -A ICONS=(
    ["IMAGE"]="🖼️ " ["NETWORK"]="🪐" ["WAN_IP"]="🌐"
    ["P2P_PORT"]="🔌" ["API_PORT"]="🧩" ["RPC_SEPOLIA"]="🛰️ "
    ["BEACON_SEPOLIA"]="📡" ["PRIVATE_KEY"]="🔐" ["PROVER_ID"]="💼"
    ["AGENT_COUNT"]="👷" ["DATA_DIR"]="📂"
  )

  is_valid_input() {
    input="$1"
    echo "$input" | iconv -f UTF-8 -t ASCII//TRANSLIT &>/dev/null
  }

  prompt_input() {
    local key="$1" prompt="$2" default="$3" secret="$4" input=""
    while true; do
      if [[ "$secret" == "true" ]]; then
        read -s -p "$prompt" input
        printf "\n"
      else
        read -p "$prompt" input
      fi

      if [[ -z "$input" && -n "$default" ]]; then
        input="$default"
      fi

      input="$(echo -n "$input" | tr -d '\r\n')"

      if [[ -z "$input" && -z "$default" ]]; then
        echo "⚠️ Trường này bắt buộc phải nhập. Vui lòng không để trống."
        continue
      fi

      if is_valid_input "$input" || [[ "$key" == "PRIVATE_KEY" || "$key" == "PROVER_ID" ]]; then
        echo "$input"
        return
      else
        echo "❌ Lỗi: giá trị chứa ký tự không hợp lệ. Vui lòng nhập không dấu."
      fi
    done
  }

  find_env_file() {
    local SEARCH_DIRS=(/ /mnt /opt)
    for base in "${SEARCH_DIRS[@]}"; do
      while IFS= read -r path; do
        if [[ -f "$path/.env" ]]; then
          ENV_FILE="$path/.env"
          DATA_DIR="$path"
          echo "📄 Đã phát hiện .env tại $ENV_FILE, đang tải..."
          source "$ENV_FILE"
          export DATA_DIR
          return 0
        fi
      done < <(find "$base" -type d -name "aztec-prover" 2>/dev/null)
    done
    return 1
  }

  edit_env_variables() {
    echo ""
    echo "🔄 .env hiện tại:"
    for i in "${!env_lines[@]}"; do
      key="${env_lines[$i]%%=*}"
      val="${env_lines[$i]#*=}"
      [[ "$key" == "PRIVATE_KEY" ]] && val="********"
      printf "%2d. %-3s %-20s = %s\n" "$((i+1))" "${ICONS[$key]}" "$key" "$val"
    done

    echo ""
    if ! printf "✅ Có\n❌ Không" | fzf --prompt="🔁 Bạn có muốn chỉnh sửa các biến môi trường? " --height=10 --reverse | grep -q "✅"; then
      echo "🔙 Không chỉnh sửa biến môi trường. Tiếp tục..."
      return 0
    fi

    while true; do
      echo ""
      display_lines=()
      for line in "${env_lines[@]}"; do
        key="${line%%=*}"
        val="${line#*=}"
        [[ "$key" == "PRIVATE_KEY" ]] && val="********"
        display_lines+=("${ICONS[$key]} $key=$val")
      done

      selected=$(printf "%s\n" "${display_lines[@]}" "💾 Lưu và tiếp tục" | fzf --prompt="🔧 Chọn biến: " --height=40% --reverse)
      [[ $? -ne 0 || "$selected" == "💾 Lưu và tiếp tục" ]] && break

      key=$(echo "$selected" | awk -F '[ =]' '{print $2}')
      old_val=$(grep "^$key=" "$ENV_FILE" | cut -d= -f2-)
      if [[ "$key" == "PRIVATE_KEY" ]]; then
        new_val=$(prompt_input "$key" "🔐 Nhập giá trị mới cho $key: " "$old_val" true)
      else
        new_val=$(prompt_input "$key" "🔧 Nhập giá trị mới cho $key (hiện tại: $old_val): " "$old_val")
      fi
      for i in "${!env_lines[@]}"; do
        [[ "${env_lines[$i]%%=*}" == "$key" ]] && env_lines[$i]="$key=$new_val"
      done
    done
  }

  backup_and_save_env() {
    echo ""
    if [ -f "$ENV_FILE" ]; then
      BACKUP_NAME="$ENV_FILE.bak_$(date +%Y%m%d_%H%M%S)"
      cp "$ENV_FILE" "$BACKUP_NAME"
      echo "🛡️ Đã sao lưu .env thành: $BACKUP_NAME"
      ls -1t "$ENV_FILE".bak_* 2>/dev/null | tail -n +2 | xargs -r rm -f
    fi

    echo "💾 Đang ghi tệp .env..."
    {
      for line in "${env_lines[@]}"; do
        key="${line%%=*}"
        val="${line#*=}"
        val="$(echo -n "$val" | tr -d '\r\n')"
        echo "${key}=${val}"
      done
    } > "$ENV_FILE"

    dos2unix "$ENV_FILE" 2>/dev/null
    source "$ENV_FILE"
    export DATA_DIR
  }

  ### Bắt đầu xử lý ###
  if ! find_env_file; then
    DEFAULT_DATA_DIR="/root/aztec-prover"
    INPUT_DIR=$(prompt_input "DATA_DIR" "📂 Nhập thư mục lưu dữ liệu [mặc định: $DEFAULT_DATA_DIR]: " "$DEFAULT_DATA_DIR")
    DATA_DIR="$INPUT_DIR"
    mkdir -p "$DATA_DIR"
    ENV_FILE="$DATA_DIR/.env"
  fi

  if [[ -f "$ENV_FILE" ]]; then
    env_lines=(
      "IMAGE=$IMAGE" "NETWORK=$NETWORK" "WAN_IP=$WAN_IP"
      "P2P_PORT=$P2P_PORT" "API_PORT=$API_PORT"
      "RPC_SEPOLIA=$RPC_SEPOLIA" "BEACON_SEPOLIA=$BEACON_SEPOLIA"
      "PRIVATE_KEY=$PRIVATE_KEY" "PROVER_ID=$PROVER_ID"
      "AGENT_COUNT=$AGENT_COUNT" "DATA_DIR=$DATA_DIR"
    )
    edit_env_variables || return 1
  else
    echo "📄 Tạo file .env mới..."
    IMAGE=$(prompt_input "IMAGE" "🖼️  Nhập Docker image [mặc định: aztecprotocol/aztec:0.87.8]: " "aztecprotocol/aztec:0.87.8")
    NETWORK=$(prompt_input "NETWORK" "🪐 Nhập network [mặc định: alpha-testnet]: " "alpha-testnet")
    RPC_SEPOLIA=$(prompt_input "RPC_SEPOLIA" "🛰️  Nhập Sepolia RPC URL: " "")
    BEACON_SEPOLIA=$(prompt_input "BEACON_SEPOLIA" "📡 Nhập Beacon API URL: " "")
    PRIVATE_KEY=$(prompt_input "PRIVATE_KEY" "🔐 Nhập Publisher Private Key: "  true)
    PROVER_ID=$(prompt_input "PROVER_ID" "💼 Nhập Prover ID: ")
    AGENT_COUNT=$(prompt_input "AGENT_COUNT" "👷 Nhập số agent [mặc định: 1]: " "1")
    P2P_PORT=$(prompt_input "P2P_PORT" "🔌 Nhập P2P Port [mặc định: 40400]: " "40400")
    API_PORT=$(prompt_input "API_PORT" "🧩 Nhập API Port [mặc định: 8080]: " "8080")

    env_lines=(
      "IMAGE=$IMAGE" "NETWORK=$NETWORK" "WAN_IP=$WAN_IP"
      "P2P_PORT=$P2P_PORT" "API_PORT=$API_PORT"
      "RPC_SEPOLIA=$RPC_SEPOLIA" "BEACON_SEPOLIA=$BEACON_SEPOLIA"
      "PRIVATE_KEY=$PRIVATE_KEY" "PROVER_ID=$PROVER_ID"
      "AGENT_COUNT=$AGENT_COUNT" "DATA_DIR=$DATA_DIR"
    )
  fi

  backup_and_save_env

  [[ ! -d "$DATA_DIR" ]] && echo "⚠️ Không tìm thấy thư mục dữ liệu: $DATA_DIR" && return 1

  return 0  # ✅ Kết thúc hàm và cho phép phần sau tiếp tục chạy
}

generate_compose() {
  mkdir -p "$DATA_DIR"  # 🛠️ Đảm bảo thư mục tồn tại trước
  COMPOSE_FILE="$DATA_DIR/docker-compose.yml"

  cat > "$COMPOSE_FILE" <<EOF
version: '3.8'
services:
  prover_node:
    image: $IMAGE
    container_name: prover_node
    restart: unless-stopped
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
    restart: unless-stopped
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
    restart: unless-stopped
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
EOF
  done
}

install_prover() {
  echo "🚀 Đang cài đặt Aztec Prover..."

  load_env_or_prompt || return 1
  generate_compose

  cd "$DATA_DIR" || { echo "❌ Không thể cd vào $DATA_DIR"; return 1; }

  echo "🧱 Dừng các container cũ (nếu có)..."
  $(compose_cmd) down

  echo "🚀 Khởi động Aztec Prover..."
  $(compose_cmd) up -d

  echo "✅ Đã khởi động các container thành công"
}

view_logs() {
  echo "📜 Running Aztec Prover Logs..."

  # Tìm thư mục aztec-prover có chứa .env trong /, /mnt, /opt
  for path in / /mnt /opt; do
    match=$(find "$path" -type d -name "aztec-prover" -exec test -f "{}/.env" \; -print 2>/dev/null | head -n 1)
    if [[ -n "$match" ]]; then
      DATA_DIR="$match"
      break
    fi
  done

  if [[ -z "$DATA_DIR" ]]; then
    echo "❌ Không tìm thấy thư mục aztec-prover chứa .env trong /, /mnt hoặc /opt"
    return
  fi

  ENV_PATH="$DATA_DIR/.env"
  source "$ENV_PATH"

  if [ ! -d "$DATA_DIR" ]; then
    echo "❌ DATA_DIR không tồn tại: $DATA_DIR"
    return
  fi

  cd "$DATA_DIR" || { echo "❌ Không thể cd vào $DATA_DIR"; return; }

  # Lấy danh sách container đang chạy
  CONTAINERS=$(docker ps --format "{{.Names}}" || true)
  HAS_PROVER=$(echo "$CONTAINERS" | grep -E "^(prover_node|broker)$" || true)
  HAS_AGENTS=$(echo "$CONTAINERS" | grep -E "^agent_[0-9]+$" || true)

  if [ -z "$CONTAINERS" ]; then
    echo "❌ Không có container nào đang chạy!"
    return
  fi

  # Xác định docker compose command
  CMD=$(compose_cmd)

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
  done
}

find_compose_dir() {
  local SEARCH_DIRS=(/ /mnt /opt)
  local MODE="${1:-compose}"  # "compose" hoặc "data"

  for base in "${SEARCH_DIRS[@]}"; do
    while IFS= read -r aztec_path; do
      case "$MODE" in
        compose)
          if [[ -f "$aztec_path/docker-compose.yml" ]]; then
            echo "$aztec_path"
            return 0
          fi
          ;;
        data)
          if [[ -d "$aztec_path/node" && -d "$aztec_path/broker" ]]; then
            echo "$aztec_path"
            return 0
          fi
          ;;
      esac
    done < <(find "$base" -type d -name "aztec-prover" 2>/dev/null)
  done

  return 1
}

delete_prover() {
  echo "⚠️  Bạn có chắc chắn muốn xoá container Prover không?"
  CHOICE=$(printf "✅ Có\n❌ Không" | fzf --prompt="👉 Chọn: " --height=6 --border --reverse)
  [[ "$CHOICE" != "✅ Có" ]] && { echo "❎ Đã huỷ thao tác xoá."; return; }

  DATA_DIR=$(find_compose_dir) || { echo "❌ Không tìm thấy docker-compose.yml của aztec-prover."; return 1; }
  echo "📂 Phát hiện thư mục Aztec Prover tại: $DATA_DIR"

  cd "$DATA_DIR" || { echo "❌ Không thể truy cập $DATA_DIR"; return 1; }
  $(compose_cmd) down -v
  echo "🧹 Đã xoá container Prover."
}

reset_prover() {
  echo "💣 Bạn sắp xoá toàn bộ container và dữ liệu!"
  CHOICE=$(printf "✅ Có, reset toàn bộ\n❌ Không" | fzf --prompt="👉 Chọn: " --height=6 --border --reverse)

  if [[ "$CHOICE" == "✅ Có, reset toàn bộ" ]]; then
    delete_prover

    # Tìm lại thư mục chứa cả node & broker
    DATA_DIR=$(find_compose_dir data) || {
      echo "❌ Không tìm thấy thư mục chứa node và broker trong aztec-prover."
      return 1
    }

    echo "🧹 Đang xoá thư mục /node và /broker trong $DATA_DIR"
    rm -rf "$DATA_DIR/node" "$DATA_DIR/broker"
    echo "✅ Reset hoàn tất. Đã giữ lại các file .env và docker-compose.yml trong $DATA_DIR"
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
