#!/usr/bin/env bash
command="/usr/lib/pam_kwallet_init  --no-startup-id"

iteration=0
while true; do
	((iteration++))
	$command
	exit_code=$?
	if [ $exit_code -ne 0 ]; then
		echo "Command crashed on iteration $iteration with exit code $exit_code" >~/.config/hypr/tst.txt
		break
	fi
done
