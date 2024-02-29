#!/usr/bin/env bash
# Run environment bash which shoudl be v5 via homebrew not v3 via OSX

PlansFolder=plans
declare -A PlansList

# Get available reading plans
for file in ${PlansFolder}/*; do
	PlanTitle="$(basename "$file" .txt)"
	FileName="$(basename "$file")"
	PlansList[$PlanTitle]=$PlansFolder"/"$FileName
done

Tomorrow=$(date -d "today + 1 days" "+%Y-%m-%d")

read -p "Enter a title for the reading plan [Bible Reading Plan]: " Title
Title=${Title:-"Bible Reading Plan"}

read -p "Enter a start date [$Tomorrow]: " StartDate
StartDate=${StartDate:-"$Tomorrow"}

PS3="Choose a reading plan: "
select plan in "${!PlansList[@]}";
do
	PlanFile="${PlansList[$plan]}"
	break;
done

Estimate=$(sed -n '$p' "$PlanFile")
Days=$(sed -n '$=' "$PlanFile")
Filename="${Title}"

echo "- Bible Plan - "$Title" @parallel(true) @autodone(true)" >> "$Filename.taskpaper"

Day=0
while IFS= read -r line; do
	Date=$(date -d "$StartDate + $Day days" "+%Y-%m-%d")
	((Day++))
	if [ $Day -lt $Days ]; then
		echo "  - $line @defer($Date) @due($Date 10pm) @estimate($Estimate)" >> "$Filename.taskpaper"  
	fi
done < "$PlanFile"
