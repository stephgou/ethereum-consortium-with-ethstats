# !/bin/bash
# bash intelligence <destination_app_json_path> <number_of_clusters> <name_prefix> <ws_server> <ws_secret>

# sets up a eth-net-intelligence app.json for a local ethereum network cluster of nodes
# - <number_of_clusters> is the number of clusters
# - <name_prefix> is a prefix for the node names as will appear in the listing
# - <ws_server> is the eth-netstats server
# - <ws_secret> is the eth-netstats secret
#

# bash configure-ethstats.sh 3 Hackademy-Node http://localhost:3000 eth-net-stats-has-a-secret > app.json

N=$1
shift
name_prefix=$1
shift
ws_server=$1
shift
ws_secret=$1
shift

echo -e "["

for ((i=0;i<N;++i)); do
    id=`printf "%02d" $i`
    ip_last_number=$(($i+4))
    single_template="  {\n    \"name\"        : \"$name_prefix-$i\",\n    \"cwd\"         : \".\",\n    \"script\"      : \"app.js\",\n    \"log_date_format\"   : \"YYYY-MM-DD HH:mm Z\",\n    \"merge_logs\"    : false,\n    \"watch\"       : false,\n    \"exec_interpreter\"  : \"node\",\n    \"exec_mode\"     : \"fork_mode\",\n    \"env\":\n    {\n      \"NODE_ENV\"    : \"production\",\n      \"RPC_HOST\"    : \"10.0.0.$ip_last_number\",\n      \"RPC_PORT\"    : \"8545\",\n      \"INSTANCE_NAME\"   : \"$name_prefix-$i\",\n      \"WS_SERVER\"     : \"$ws_server\",\n      \"WS_SECRET\"     : \"$ws_secret\",\n    }\n  }"

    endline=""
    if [ "$i" -ne "$N" ]; then
        endline=","
    fi
    echo -e "$single_template$endline"
done

echo "]"
