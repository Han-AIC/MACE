mkdir ../MACE/100DataSetPreparation &
mkdir ../MACE/100DataSetPreparation/010AGWData & 
mkdir ../MACE/100DataSetPreparation/020ProcessedData & 
mkdir ../MACE/100DataSetPreparation/020ProcessedData/Formats &
mkdir ../MACE/100DataSetPreparation/020ProcessedData/Formats/010QuestionSets & 
mkdir ../MACE/100DataSetPreparation/020ProcessedData/Formats/010QuestionSets/segmentData & 
mkdir ../MACE/100DataSetPreparation/020ProcessedData/Formats/020Indiscriminate &
mkdir ../MACE/100DataSetPreparation/020ProcessedData/Formats/020Indiscriminate/segmentData & 
mkdir ../MACE/100DataSetPreparation/020ProcessedData/Formats/030QuestionsPlacedTogether &
mkdir ../MACE/100DataSetPreparation/020ProcessedData/Formats/030QuestionsPlacedTogether/segmentData & 
mkdir ../MACE/100DataSetPreparation/030Processors & 
cp  ./resources/templatePython.py ../MACE/100DataSetPreparation/030Processors/010QuestionSetsProcessor.py &
cp  ./resources/templatePython.py ../MACE/100DataSetPreparation/030Processors/020IndiscriminateProcessor.py &
cp  ./resources/templatePython.py ../MACE/100DataSetPreparation/030Processors/030OrganizrProcessor.py &
cp  ./resources/templatePython.py ../MACE/100DataSetPreparation/030Processors/040Cutter.py &

# mkdir ../MACE/100DataSetPreparation/030Processors & 
# mkdir ../MACE/100DataSetPreparation/030Processors & 
# mkdir ../MACE/100DataSetPreparation/030Processors & 

mkdir ../MACE/200Model & 
mkdir ../MACE/200Model/mainCode & 
mkdir ../MACE/200Model/threadCode & 

mkdir ../MACE/300CollectedDataRepository &

mkdir ../MACE/310CollectedDataProcessing &
cp  ./resources/templatePython.py ../MACE/310CollectedDataProcessing/010ConcatenatorProcessor.py &
cp  ./resources/templatePython.py ../MACE/310CollectedDataProcessing/020CounterProcessor.py &

mkdir ../MACE/400CollectedDataAssessment &
cp  ./resources/templatePython.py ../MACE/400CollectedDataAssessment/010AssessorProcessor.py &
cp  ./resources/templatePython.py ../MACE/400CollectedDataAssessment/020WriterProcessor.py &


# mkdir ../MACE/500Reports &

# mkdir ./MACEControlCenter &
# cp  constructor.sh ./MACEControlCenter/010DataPrepController.sh &
# cp  constructor.sh ./MACEControlCenter/020ModelRunController.sh &
# cp  constructor.sh ./MACEControlCenter/030DataCollectionController.sh &
# cp  constructor.sh ./MACEControlCenter/040CollectedDataAssessController.sh &
# cp  constructor.sh ./MACEControlCenter/050RUNMACE.sh &

# mkdir ./MACEControlCenter/Resources 