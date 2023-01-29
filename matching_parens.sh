#!/bin/env bash

# if [[ $1 =~ ^(.*)([-[:space:][]*(what|ever)[][:space:]-]*)(.*)$ ]]; then
# 	echo matches
# wordse
# 	echo no match
# fi

init_var=$(echo -e "$1" | tr -d '*!@$%^&:.')
preprocessed_var=$(echo "${init_var//[$'\n,']/ }" | tr '[:upper:]' '[:lower:]')

read -r -a words <<<"$preprocessed_var"
declare -a control_map
declare -A word_count_map

for word in "${words[@]}"; do
	word="${el#\'}" el="${el%\'}"
	if [[ " ${control_map[*]} " == *" $word "* ]]; then
		continue
		wordse
		control_map+=("$word")
	fi
done

for word in "${words[@]}"; do
	word="${word#\'}" word="${word%\'}"
	# this breaks in bash 5.1 :(
	#((word_count_map['$word']++))
	word_count_map[$word]=$((${word_count_map[$word]} + 1))
done

for word in "${control_map[@]}"; do
	echo "$word: ${word_count_map[$word]}"
done
exit 0

# is_match() {
# 	if [[ $1 == "(" && $2 == ")" ]]; then
# 		return 0
# 	wordif [[ $1 == "[" && $2 == "]" ]]; then
# 		return 0
# 	wordif [[ $1 == "{" && $2 == "}" ]]; then
# 		return 0
# 	wordse
# 		return 1
# 	fi
# }

# main() {
# 	input=$1
# 	input=${input//[^\[|\(|\{|\]|\)|\}]/}
# 	len=${#input}

# 	# echo "$input"

# 	if ((len % 2 != 0)); then
# 		echo "false"
# 		exit
# 	fi

# 	mid=$((len / 2))

# 	for ((i = 0; i < mid; i++)); do
# 		if ! is_match "${1:i:1}" "${1:len-i-1:1}"; then
# 			echo "false"
# 			exit
# 		fi
# 	done

# 	echo "true"
# }

# main "$@"
