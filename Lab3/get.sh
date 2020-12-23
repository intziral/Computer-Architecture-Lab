#!/bin/bash

mcpat_outputs='../mcpat/mcpat_stats'
gem5_outputs='../mcpat/spec_results2'
energy_outputs='../mcpat/energy_results'

output='results.json'
echo [ > $output

for file in $(ls $mcpat_outputs/*.txt)
do
  name=$(echo $file | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)
  energy=$(cat $energy_outputs/$name.txt | grep energy | cut -d' ' -f3)
  runtime=$(cat $energy_outputs/$name.txt | grep runtime | cut -d' ' -f9)
  area=$(cat $mcpat_outputs/$name.txt | grep Area | head -1 | cut -d' ' -f5)
  peak_power=$(cat $mcpat_outputs/$name.txt | grep "Peak Power" | head -1 | cut -d' ' -f6)

  echo { >> $output
  echo \"benchmark\": \"$name\", >> $output
  echo \"energy\": $energy, >> $output
  echo \"runtime\": $runtime, >> $output
  echo \"area\": $area, >> $output
  echo \"peak_power\": $peak_power >> $output
  echo }, >> $output
done

echo ] >> $output