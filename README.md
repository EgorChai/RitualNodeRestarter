Hello everyone!
I noticed that I often get the following error:
2024-06-05 20:21:46 [error] Task exited: {'code': -32000, 'message': 'filter not found'} [__main]

I decided to write a script that will monitor this error and if it happens, raise the node itself.

So here is the guide

########creating a file for the restart counter
mkdir -p /var/log/docker/ && touch /var/log/docker/deploy-node-1_restart_count.log

########create a script that will handle our startup
######## and insert the code into it

nano restart_container.sh

########Make it executable

chmod +x restart_container.sh

########Install tmux

sudo apt-get install tmux
tmux new -s restart_container
./restart_container.sh

########To collapse session press CTRL+B , then D
########To return to the session
tmux attach -t restart_container

#### To see how many restarts there were
cat /var/log/docker/deploy-node-1_restart_count.log
