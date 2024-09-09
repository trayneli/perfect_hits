#!/usr/bin/env bash
blast_command=blastn;
queryInputFile="$1";
subjectInputFile="$2";
outputFile="$3";
task='blastn-short';
$blast_command -query $queryInputFile -subject $subjectInputFile -task $task -outfmt 6 -out $outputFile; 
queryLength=$(cat $queryInputFile | sed '1d');
queryLengthCount=$(printf $queryLength | wc -c);
## Filter for 100% match and matching sequence length
cat $outputFile | awk -F '\t' '$3 == 100 && $4 == '$queryLengthCount' {print $2}' | uniq > tmp_sequence_files;
echo "Number of Perfect Matches" $(cat tmp_sequence_files | wc -l) ;
echo "The Fasta File" $subjectInputFile "contains Perfect Matches at" $(cat tmp_sequence_files);

outputRowTargetCount=$(cat $subjectInputFile | grep -n "^>" | grep -a1 -f tmp_sequence_files | sed '1d' | awk -F ':' '{print $1}');
MinRowRegion=$(echo $outputRowTargetCount | sort -n | head -1);
MaxRowRegion=$(echo $outputRowTargetCount | sort -n | tail -1);
