#! /bin/bash
tmux send-keys -t mysession:0.4 'dig +tries=1 +timeout=10 @172.20.0.2 test'$1'.example' Enter
sleep 2
tmux capture-pane -t mysession:0.4 -pS - > dig_logs/run_$1.log
tmux send-keys -t mysession:0.4 -R Enter
tmux clear-history -t mysession:0.4
sleep 1
