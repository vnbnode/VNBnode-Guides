#!/bin/bash

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

DEFAULT_LISTEN_PORT=1234

while true; do
    clear
    echo "🚀 Titan Container Manager"
    echo "=============================="
    echo "1️⃣ Install Node"
    echo "2️⃣ View Logs"
    echo "3️⃣ Uninstall Node"
    echo "4️⃣ Exit"
    echo "=============================="
    read -rp "🔹 Choose an option (1-4): " CHOICE

    case "$CHOICE" in
        1)
            while true; do
                read -rp "Enter the number of nodes to create (1-5): " REPLICAS
                if [[ "$REPLICAS" =~ ^[1-5]$ ]]; then
                    break
                else
                    echo "❌ Invalid input! Please enter a number between 1 and 5."
                fi
            done
            
            # Install necessary dependencies
            cd $HOME
            if ! command -v docker &> /dev/null; then
                source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/docker-install.sh)
            fi
            if ! command -v fzf &> /dev/null; then
                sudo apt install fzf -y
            fi
            
            # Ask for storage size
            while true; do
                read -rp "Enter storage size (10-100 GB): " STORAGE_SIZE
                if [[ "$STORAGE_SIZE" =~ ^[0-9]+$ ]] && [ "$STORAGE_SIZE" -ge 10 ] && [ "$STORAGE_SIZE" -le 100 ]; then
                    break
                else
                    echo "❌ Invalid input! Please enter a number between 10 and 100."
                fi
            done
            
            # Run Titan Edge
            for i in $(seq 1 $REPLICAS); do
                NODE_NAME="titan$i"
                DEFAULT_PORT=$((DEFAULT_LISTEN_PORT + i - 1))
                read -rp "Enter listening port for $NODE_NAME (default: $DEFAULT_PORT): " LISTEN_PORT
                LISTEN_PORT=${LISTEN_PORT:-$DEFAULT_PORT}
                
                docker run --name $NODE_NAME --network=host -d -v ~/.titan$i:/root/.titanedge nezha123/titan-edge:latest
                docker run --rm -it -v ~/.titan$i:/root/.titanedge nezha123/titan-edge:latest config set --storage-size=${STORAGE_SIZE}GB
                docker run --rm -it -v ~/.titan$i:/root/.titanedge nezha123/titan-edge:latest config set --listen-address 0.0.0.0:${LISTEN_PORT}
                docker update --restart=unless-stopped $NODE_NAME
                docker restart $NODE_NAME
            
                # Ask for binding code
                read -rp "Enter binding code for $NODE_NAME: " BINDING_CODE
                docker run --rm -it -v ~/.titan$i:/root/.titanedge nezha123/titan-edge:latest bind --hash=$BINDING_CODE https://api-test1.container1.titannet.io/api/v2/device/binding
            done
            ;;

        2)
            echo "📜 Running Titan Edge Logs..."
            RUNNING_NODES=$(docker ps --format "{{.Names}}" | grep -E "^titan[0-9]*$" || true)
            if [ -z "$RUNNING_NODES" ]; then
                echo "❌ No Titan nodes are currently running!"
            else
                NODE_LOG=$(echo "$RUNNING_NODES" | fzf --height=10 --border --prompt="Select a node to view logs: ")
                if [ -n "$NODE_LOG" ]; then
                    docker logs -f $NODE_LOG || true
                else
                    echo "❌ No node selected!"
                fi
            fi
            read -rp "Press Enter to continue..."
            ;;

        3)
            echo "🛑 Uninstalling Titan Nodes..."
            echo "1️⃣ Remove a specific node"
            echo "2️⃣ Remove all nodes"
            read -rp "Choose an option (1-2): " REMOVE_CHOICE

            if [[ "$REMOVE_CHOICE" == "1" ]]; then
                RUNNING_NODES=$(docker ps -a --format "{{.Names}}" | grep -E "^titan[0-9]*$" || true)
                if [ -z "$RUNNING_NODES" ]; then
                    echo "❌ No Titan nodes found!"
                else
                    NODE_TO_REMOVE=$(echo "$RUNNING_NODES" | fzf --height=10 --border --prompt="Select a node to remove: ")
                    if [ -n "$NODE_TO_REMOVE" ]; then
                        docker stop $NODE_TO_REMOVE
                        docker rm $NODE_TO_REMOVE
                        rm -r ~/.${NODE_TO_REMOVE}
                        echo "✅ Removed $NODE_TO_REMOVE"
                    else
                        echo "❌ No node selected!"
                    fi
                fi
            elif [[ "$REMOVE_CHOICE" == "2" ]]; then
                echo "⚠️  This will remove all Titan nodes! Are you sure? (y/N)"
                read -rp "Confirm: " CONFIRM
                if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
                    for NODE in $(docker ps -a --format "{{.Names}}" | grep -E "^titan[0-9]*$" || true); do
                        docker stop $NODE
                        docker rm $NODE
                        rm -r ~/.${NODE}
                        echo "✅ Removed $NODE"
                    done
                else
                    echo "❌ Operation cancelled!"
                fi
            else
                echo "❌ Invalid choice!"
            fi

            # Run docker system prune after removing nodes
            echo "🧹 Cleaning up Docker system..."
            docker system prune -a --volumes -f
            echo "✅ Docker system cleanup complete!"

            read -rp "Press Enter to continue..."
            ;;

        4)
            echo "👋 Exiting program. See you next time!"
            exit 0
            ;;

        *)
            echo "❌ Invalid choice! Please select again."
            sleep 2
            ;;
    esac
done
