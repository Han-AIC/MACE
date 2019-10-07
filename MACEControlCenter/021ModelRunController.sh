#!/bin/bash
# source ./Params/ModelSettings.txt

# Model Types

# QuestionSets
# 010QuestionSets

# Indiscriminate
# 020Indiscriminate

# QuestionsPlacedTogether
# 030QuestionsPlacedTogether

modelType=QuestionsPlacedTogether
dataType=030QuestionsPlacedTogether

sampleSize=1
burnSize=1
lagSize=1

# numberOfThreads=$(ls ../MACE/100DataSetPreparation/020ProcessedData/Formats/${dataType}/segmentData | wc -l)
numberOfThreads=1
trialNumber=8

mainTrialName=0${trialNumber}0S${sampleSize}B${burnSize}L${lagSize}${modelType}

echo "Commencing run of trial ${mainTrialName} with ${numberOfThreads} threads."

echo "Making sure that no existing directories exist that would cause conflict ... "

rm -r ../MACE/200Model/030IntermediateDataRepository/${mainTrialName}/ 

rm -r ../MACE/200Model/030IntermediateDataRepository/*

mkdir ../MACE/200Model/030IntermediateDataRepository/${mainTrialName}/ 

rm -r ../MACE/200Model/020ThreadCode/* 

wait
echo "Writing .wppl file to .js threads ... "
for threadNumber in `seq 1 ${numberOfThreads%.*}` 
        do
                webppl --require webppl-csv ../MACE/200Model/010MainCode/MACE${modelType}.wppl --compile --out ../MACE/200Model/020ThreadCode/0${threadNumber}0Thread.js &
                mkdir ../MACE/200Model/030IntermediateDataRepository/${mainTrialName}/0${threadNumber}0ThreadData/ &
        done  
wait
echo "Commencing thread run cycle."
python ../MACE/200Model/040Timer/timer.py ../MACE/200Model/030IntermediateDataRepository/${mainTrialName}/timing.csv BEGAN TRAINING ${mainTrialName} && 
for threadNumber in `seq 1 ${numberOfThreads%.*}`
        do
                echo "Executing thread #${threadNumber}"
                node --max-old-space-size=16000 ../MACE/200Model/020ThreadCode/0${threadNumber}0Thread.js $sampleSize $burnSize $lagSize ${threadNumber} ${trialNumber} ${modelType} &
        done  
wait
python ../MACE/200Model/040Timer/timer.py ../MACE/200Model/030IntermediateDataRepository/${mainTrialName}/timing.csv  ENDED TRAINING ${mainTrialName}

echo "Model Inference Cycle Complete"

