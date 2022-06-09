#!/usr/bin/env bash

# declare -A cipher=(
# 	[a]=z
# 	[b]=y
# 	[c]=x
# 	[d]=w
# 	[e]=v
# 	[f]=u
# 	[g]=t
# 	[h]=s
# 	[i]=r
# 	[j]=q
# 	[k]=p
# 	[l]=o
# 	[m]=n
# 	[n]=m
# 	[o]=l
# 	[p]=k
# 	[q]=j
# 	[r]=i
# 	[s]=h
# 	[t]=g
# 	[u]=f
# 	[v]=e
# 	[w]=d
# 	[x]=c
# 	[y]=b
# 	[z]=a
# )

# declare -A plainText=(
# 	[z]=a
# 	[y]=b
# 	[x]=c
# 	[w]=d
# 	[v]=e
# 	[u]=f
# 	[t]=g
# 	[s]=h
# 	[r]=i
# 	[q]=j
# 	[p]=k
# 	[o]=l
# 	[n]=m
# 	[m]=n
# 	[l]=o
# 	[k]=p
# 	[j]=q
# 	[i]=r
# 	[h]=s
# 	[g]=t
# 	[f]=u
# 	[e]=v
# 	[d]=w
# 	[c]=x
# 	[b]=y
# 	[a]=z
# )

# inputSting="x123 yes"
# cipherText=""

# for ((i = 0; i < ${#inputSting}; i++)); do
# 	if [[ ${inputSting:$i:1} =~ [a-zA-Z] ]]; then
# 		cipherText+="${cipher[${inputSting:$i:1}]}"
# 	else
# 		cipherText+="${inputSting:$i:1}"
# 	fi
# done

# echo $cipherText

year=$1

div4=$((year % 4))
div100=$((year % 100))
div400=$((year % 400))

if [[ $div4 -eq 0 && ($div100 -ne 0 || $div400 -eq 0) ]]; then
	echo "Leap year"
else
	echo "Not a leap year"
fi
