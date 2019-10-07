echo "Beginning Data Processing ... "
echo "Processing into QuestionSets Format ... "
python ../MACE/100DataSetPreparation/030Processors/010QuestionSetsProcessor.py '../MACE/100DataSetPreparation/010AGWData/A_Good_World.csv' '../MACE/100DataSetPreparation/020ProcessedData/Formats/010QuestionSets/010QuestionSetData.csv'  &&
echo "Processing into Indiscriminate Format ... "
python ../MACE/100DataSetPreparation/030Processors/020IndiscriminateProcessor.py '../MACE/100DataSetPreparation/010AGWData/A_Good_World.csv' '../MACE/100DataSetPreparation/020ProcessedData/Formats/020Indiscriminate/020IndiscriminateData.csv' &&
echo "Processing into QuestionsPlacedTogether Format ... "
python ../MACE/100DataSetPreparation/030Processors/030QPTProcessor.py '../MACE/100DataSetPreparation/010AGWData/A_Good_World.csv' '../MACE/100DataSetPreparation/020ProcessedData/Formats/030QuestionsPlacedTogether/030QuestionsPlacedTogether.csv' &&
echo "Now segmenting all three data sets ... "
echo "Cutting Question Sets ..."
python ../MACE/100DataSetPreparation/030Processors/040CutterQSI.py '../MACE/100DataSetPreparation/020ProcessedData/Formats/010QuestionSets/010QuestionSetData.csv' '../MACE/100DataSetPreparation/020ProcessedData/Formats/010QuestionSets/segmentData/' 19 190 &&
echo "Cutting Indiscriminate ..."
python ../MACE/100DataSetPreparation/030Processors/040CutterQSI.py '../MACE/100DataSetPreparation/020ProcessedData/Formats/020Indiscriminate/020IndiscriminateData.csv' '../MACE/100DataSetPreparation/020ProcessedData/Formats/020Indiscriminate/segmentData/' 744 18626 &&
echo "Cutting QPT format ... "
python ../MACE/100DataSetPreparation/030Processors/050CutterQPT.py '../MACE/100DataSetPreparation/020ProcessedData/Formats/030QuestionsPlacedTogether/030QuestionsPlacedTogether.csv' '../MACE/100DataSetPreparation/020ProcessedData/Formats/030QuestionsPlacedTogether/segmentData/' &&
echo "Creating count file for analysis ... "
python ../MACE/100DataSetPreparation/030Processors/060CounterProcessor.py '../MACE/100DataSetPreparation/010AGWData/A_Good_World.csv' '../MACE/100DataSetPreparation/040Counts/010AGWCounts.csv' 8 
echo "Data Preparation Complete."