#!/bin/bash
if [[ -z $1 ]]; then
	echo "Usage: $0 [list] [thread]"
	exit
fi

scan() {
	domain=$(basename $1)
	url=$(curl -w "%{redirect_url}\n" -s $domain -o /dev/null)
	if [[ -n $url ]]; then
		result=$(curl -s $url | htmlq --pretty --attribute href a 2>/dev/null | grep -vE "http|index" | grep ".php?" | head -n 1)
		if [[ -n "$result" ]]; then
			echo "$url/$result" >> result.txt
			echo -e "\e[92mYESS: $url/$result FOUNDDDD PARAMETER\e[0m"
		else
			echo -e "\e[91m$url NOT FOUND\e[0m"
		fi
	else
		echo "$1 url 404"
	fi
}
reverse_ip() {
	domen=$(basename $1)
	res=$(lynx -dump -listonly -nonumbers -hiddenlinks=ignore -useragent="$(shuf -n 1 < $PREFIX/bin/useragent.txt)" https://www.bing.com/search\?q\=ip%3A$(dig +short $domen | head -n 1)%20.php?\&first\=0\&FORM\=PORE | grep -vE "bing.com|micro|creative|javascript:|msn" | grep ".php?" | awk -F/ '{print $3}' | sort -u)
	if [[ -n $res ]]; then
		echo -e "\e[93mReverse_ip: $1 FOUNDDD\e[0m"
		echo -e "\e[92m => $res\e[0m"
		echo "$res" > .temp
		for site in $(cat .temp); do
			scan "$site"
		done
	else
		echo -e "\e[91mReverse_ip: $domen NOT FOUND SQLI\e[0m"
	fi
}
export -f reverse_ip scan
parallel -j 20 reverse_ip :::: "$1"
