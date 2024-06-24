setting_file="settings.conf"
log_file="panel.log"

remove_quotes() {
    local value=$1
    # Use sed to remove leading and trailing double quotes
    value=$(echo "$value" | sed 's/^"\(.*\)"$/\1/')
    echo "$value"
}

replace_tilde() {
    local path="$1"
    local starlord_home=$(sudo -u starlord bash -c 'echo $HOME')
    echo "${path/#\~/$starlord_home}"
}

log_info() {
    local msg="$1"
    echo -e "$(date '+%Y-%m-%d %H:%M:%S'):\t$msg" | tee -a $log_file
}