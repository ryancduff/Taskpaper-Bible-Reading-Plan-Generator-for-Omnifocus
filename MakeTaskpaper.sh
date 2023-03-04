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

read -p "Enter a title for the reading plan: " Title
read -p "Enter a year and month for the reading plan (YYYY-MM): " YearMonth

PS3="Choose a reading plan: "
select plan in "${!PlansList[@]}";
do
	PlanFile="${PlansList[$plan]}"
	break;
done

declare -A ReadingPlanData
declare -a ReadingPlanOrder

while IFS='=' read key value; do
	ReadingPlanData[$key]=$value
	if [[ $key =~ ^[0-9]+$ ]]; then
		ReadingPlanOrder+=("$key")
	fi
done < "$PlanFile"

Estimate=${ReadingPlanData[estimate]}
Filename="${Title} ${YearMonth}"

echo "- Bible Plan - "$Title" @parallel(true) @autodone(true)" >> "$Filename.taskpaper"
for Day in "${ReadingPlanOrder[@]}"
do
	Date="${YearMonth}-${Day}"
	echo "  - ${ReadingPlanData[$Day]} @defer($Date) @due($Date 10pm) @estimate($Estimate)" >> "$Filename.taskpaper"
done
