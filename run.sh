#!/bin/bash

source utils.sh

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

echo "######## $(date) ########" | tee -a $log_file

projects=$(jq '.projects' $setting_file)

log_info  "[+] Terminating Previous Sessions"
for project_name in $(echo $projects | jq -r 'keys_unsorted[]'); do
  log_info  "\t[*] Terminating \"$project_name\""
  screen -S $project_name -X quit 2>&1 | tee -a $log_file
done

for project_name in $(echo $projects | jq -r 'keys_unsorted[]'); do
  project_path=$(jq ".projects.$project_name.path" $setting_file)
  project_runner=$(jq ".projects.$project_name.runner" $setting_file)

  project_path=$(remove_quotes $project_path)
  project_runner=$(remove_quotes $project_runner)

  runner_path=$(replace_tilde "$project_path/$project_runner")

  log_info  "[+] Running \"$project_name\""
  screen -S $project_name -dm python3 $runner_path 2>&1 | tee -a $log_file
  if [ $? -ne 0 ]; then
    log_info  "[-] Failed running \"$project_name\""
  fi
done