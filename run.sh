#!/bin/bash
[[ -z $1 ]] && echo "$0 [keyword]" && exit
ctrlc() {
	echo -e "\n\e[91mStopped by user\e[0m"
	rm .temp 2>/dev/null
	exit
}
grabdomain() {
	num=0
	n=(0)
	while [ $num -ne 10000 ]; do
		num=$(($num+10))
		n+=("$num")
	done
	for page in ${n[@]}; do
		result=$(lynx -dump -listonly -nonumbers -hiddenlinks=ignore -useragent="$(shuf -n 1 < .useragent.txt)" https://www.bing.com/search\?q\=$1\&first\=$page\&FORM\=PORE | grep -vE "bing.com|micro|creative|javascript:|msn" | awk -F/ '{print $3}' | sort -u)
		if [[ -n $result ]]; then
			echo "$result" >> .temp
			printf "\r[*] Keyword: $1 Found $(sort -u .temp | wc -l) domain"
			trap ctrlc INT
		else
			break
		fi
	done
	if [[ -n $(cat .temp 2>/dev/null) ]]; then
		sort -u .temp >> anjay.txt
		echo -e "\n[+] Total $(sort -u .temp 2>/dev/null | wc -l) domain"
		echo "[*] tersimpan di anjay.txt"
	else
		echo "[-] Keyword: $1 Not Found"
	fi
	unset num n
}
grabdomain "$1"
rm .temp 2>/dev/null
