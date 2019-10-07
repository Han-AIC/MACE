source ./Params/ModelSettings.txt

echo "Concatenating thread results ..."
if [ $modelType == QuestionSets ]
    then
        python ../MACE/310CollectedDataProcessing/010ConcatenatorProcessor.py ../MACE/300CollectedDataRepository/${trial} ../MACE/300CollectedDataRepository/${trial}/001ConcatenatedUnformatted.csv &&
        python ../MACE/310CollectedDataProcessing/011QuestionSetExpander.py ../MACE/300CollectedDataRepository/${trial}/001ConcatenatedUnformatted.csv ../MACE/300CollectedDataRepository/${trial}/100Concatenated.csv 
else
    python ../MACE/310CollectedDataProcessing/010ConcatenatorProcessor.py ../MACE/300CollectedDataRepository/${trial} ../MACE/300CollectedDataRepository/${trial}/100Concatenated.csv
fi

wait
echo "Using concatenated data for vote-counting ..."
python ../MACE/310CollectedDataProcessing/020CounterProcessor.py ../MACE/300CollectedDataRepository/${trial}/100Concatenated.csv ../MACE/300CollectedDataRepository/${trial}/200VoteCounts.csv 8 