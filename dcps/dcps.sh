#!/usr/bin/env bash
dcps() {
	shopt -s checkwinsize
	# Get max lengths for all four columns
	declare -A col_len
	local id image names status total_len containers container i
	IFS=$'\n' mapfile containers < <(docker ps --format '{{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}')
	for container in "${containers[@]}"; do
		while IFS=$'\t' read -r id image names status; do
			if (( ${#id} > col_len['id'] )); then
				col_len['id']=${#id}
			fi
			if (( ${#image} > col_len['image'] )); then
				col_len['image']=${#image}
			fi
			if (( ${#names} > col_len['names'] )); then
				col_len['names']=${#names}
			fi
			if (( ${#status} > col_len['status'] )); then
				col_len['status']=${#status}
			fi
		done <<< "${container}"
	done
	((col_len['id'] += 4))
	((col_len['image'] += 4))
	((col_len['names'] += 4))
	total_len=$((col_len['id'] + col_len['image'] + col_len['names'] + col_len['status']))
	# Print headers
	printf '\e[34m  %-*s%-*s%-*s%-*s\e[0m\n' "${col_len['id']}" ID "${col_len['image']}" Image "${col_len['names']}" Names "${col_len['status']}" Status

	# Get all project names
	declare -A projects
	while IFS="," read -r -a labels; do 
		for label in "${labels[@]}"; do
			if [[ $label = com.docker.compose.project"="* ]]; then
				projects["${label#*=}"]=""
			fi
		done
	done<<<"$(docker ps --format "{{.Labels}}")"
	
	# Loop through project names and find all containers in each project
	for project in "${!projects[@]}"; do
		IFS=$'\n' mapfile -t containers < <(docker ps --format '{{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}' --filter label=com.docker.compose.project="$project")
		
		# If more than one container in a project, display all with a fancy border that denotes the proejct name
		if (( ${#containers[@]} > 1 )); then
			printf '\e[33m╔═ %s ' "$project"
			for ((i=0; i < (total_len - ${#project} - 1); i++)){ printf '═'; }
			printf '╗\e[0m\n'
			for container in "${containers[@]}"; do
				while IFS=$'\t' read -r id image names status; do
					printf '\e[33m║\e[0m %-*s%-*s%-*s%-*s \e[33m║\e[0m\n' "${col_len['id']}" "$id" "${col_len['image']}" "$image" "${col_len['names']}" "$names" "${col_len['status']}" "$status"
				done <<< "$container"
			done
			printf '\e[33m╚'
			for ((i=0; i < (total_len + 2); i++)){ printf '═'; }
			printf '╝\e[0m\n'	
		# If only one container in a project just display it normally without the fancy border
		else
			while IFS=$'\t' read -r id image names status; do
				printf '  %-*s%-*s%-*s%-*s\n' "${col_len['id']}" "$id" "${col_len['image']}" "$image" "${col_len['names']}" "$names" "${col_len['status']}" "$status"
			done <<< "${containers[0]}"
		fi
	done
	if (( total_len + 4 > COLUMNS )); then
		printf '\e[31mTerminal too narrow. >= %d required for proper formatting\e[0m\n' $(( total_len + 4 )) >&2
        fi
}
if ( return 0 &>/dev/null ); then
	# sourced
	true
else
	dcps
fi
