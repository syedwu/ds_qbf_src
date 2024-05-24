#!/bin/bash

# Check if the session already exists
tmux has-session -t mysession 2> /dev/null
if [[ $? == 0 ]]
then
    tmux kill-session -t mysession  # Kill the session if it exists already...
fi

echo "+++++ Plese Wait ... SETTING UP EVERY THING +++++"


# Create a new session (called mysession) in foreground mode
tmux new-session -s mysession -d

# Split the window vertically (creates pane 1)
tmux split-window -v -t mysession:0

# Split the original pane horizontally (creates pane 2)
tmux split-window -h -t mysession:0.1
tmux split-window -v -t mysession:0.2
tmux split-window -h -t mysession:0.0


# Checking --- Send echo commands to each pane

#tmux send-keys -t mysession:0.0 'echo "+++++ This is Pane 0 +++++"' Enter
#tmux send-keys -t mysession:0.1 'echo "+++++ This is Pane 1 +++++"' Enter
#tmux send-keys -t mysession:0.2 'echo "+++++ This is Pane 2 +++++"' Enter
#tmux send-keys -t mysession:0.3 'echo "+++++ This is Pane 3 +++++"' Enter
#tmux send-keys -t mysession:0.4 'echo "+++++ This is Pane 4 +++++"' Enter


tmux send-keys -t mysession:0.0 'docker-compose up ns1_root' Enter
sleep 5
tmux send-keys -t mysession:0.1 'docker-compose up ns1_example' Enter
sleep 5
tmux send-keys -t mysession:0.2 'docker-compose up resolver' Enter
sleep 5
tmux send-keys -t mysession:0.3 'docker-compose up client1' Enter
sleep 5
tmux send-keys -t mysession:0.4 'docker exec -it build-client1-1 /bin/bash' Enter
sleep 3
tmux send-keys -t mysession:0.4 'dig +tries=1 +timeout=10 @172.20.0.2 test.example' Enter
sleep 6
tmux capture-pane -t mysession:0.4 -pS - >setup.log
tmux send-keys -t mysession:0.4 -R Enter
tmux clear-history -t mysession:0.4

#Checking if initial query is failed ---> and re-trying...

grep -i 'ERVFAIL' setup.log >/dev/null
while [[ $? == 0 ]]; do
  echo "Please wait... Initial Test Query Failed ... Closing and Setting up again ..."
  tmux send-keys -t mysession:0.4 'exit' Enter
  tmux send-keys -t mysession:0.3 '^c'
  tmux send-keys -t mysession:0.2 '^c'
  tmux send-keys -t mysession:0.1 '^c'
  tmux send-keys -t mysession:0.0 '^c'
  sleep 10
 
  tmux has-session -t mysession 2>/dev/null >/dev/null
  
  if [[ $? == 0 ]]; then
      tmux kill-session -t mysession
  fi

  tmux new-session -s mysession -d
  tmux split-window -v -t mysession:0

  tmux split-window -h -t mysession:0.1 
  tmux split-window -v -t mysession:0.2
  tmux split-window -h -t mysession:0.0

  tmux send-keys -t mysession:0.0 'docker-compose up ns1_root' Enter
  sleep 5
  tmux send-keys -t mysession:0.1 'docker-compose up ns1_example' Enter
  sleep 5
  tmux send-keys -t mysession:0.2 'docker-compose up resolver' Enter
  sleep 5
  tmux send-keys -t mysession:0.3 'docker-compose up client1' Enter
  sleep 5
  tmux send-keys -t mysession:0.4 'docker exec -it build-client1-1 /bin/bash' Enter
  sleep 3
  tmux send-keys -t mysession:0.4 'dig +tries=1 +timeout=10 @172.20.0.2 test.example' Enter
  sleep 6
  tmux capture-pane -t mysession:0.4 -pS - >setup.log
  tmux send-keys -t mysession:0.4 -R Enter
  tmux clear-history -t mysession:0.4
  grep -i 'ERVFAIL' setup.log >/dev/null

done
echo "All OK Now ---[Attaching]--- Please wait..."
sleep 2
# Attach to the session
tmux attach -t mysession


