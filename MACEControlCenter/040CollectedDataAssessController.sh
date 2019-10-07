source ./Params/ModelSettings.txt
acc=$(python ../MACE/400CollectedDataAssessment/010AssessorProcessor.py ../MACE/100DataSetPreparation/040Counts/010AGWCounts.csv ../MACE/300CollectedDataRepository/${trial}/200VoteCounts.csv ../MACE/500Reports/${trial}Report.csv 2>&1)
echo "Accuracy of run rated at $acc"
echo "Writing initial report ..."
python ../MACE/400CollectedDataAssessment/020WriterProcessor.py ../MACE/100DataSetPreparation/040Counts/010AGWCounts.csv ${trial} ${acc} ../MACE/500Reports/${trial}Report.csv ../MACE/300CollectedDataRepository/${trial}/200VoteCounts.csv ../MACE/300CollectedDataRepository/${trial}/timing.csv  
echo "Adding annotator information to report ..."
python ../MACE/400CollectedDataAssessment/030AnnotatorInfoProcessor.py ../MACE/300CollectedDataRepository/${trial}/100Concatenated.csv ../MACE/500Reports/${trial}Report.csv
echo "Report completed."