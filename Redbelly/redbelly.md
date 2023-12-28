## Part 1: Automatic run Redbelly node
```
cd $HOME && curl -o auto-run.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Redbelly/auto-run.sh && bash auto-run.sh
```
## Part 2: Usefull commands
### Check status of node
```
pgrep rbbc
# result should be a number
```
### Check logs
```
cat ./logs/rbbcLogs
```
or
```
tail -f $HOME/root/logs/rbbcLogs
```
