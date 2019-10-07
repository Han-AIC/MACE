## Readme

MACE, or Multi-Annotator-Competence-Estimation, is a means of statistically inferring the trustworthiness of a quiz-taker, or annotator. It models the quiz-taker by randomly sampling a set of parameters from probability distributions, representing trustworthiness and spamming strategy. It then uses these parameters to derive an answer which it thinks that the annotator would give based on those parameters. 

It compares this predicted answer to what the annotator actually gave, and then repeats the process until it finds a set of parameters which provide the best possible representation of the real-world data. 

The model is run entirely from bash control scripts in ```~/MACEControlCenter```, the description and use of which, as part of the process of running MACE, is detailed below. 

#### Some useful commands kept here for convenience

You may need to use these commands outside of the prepared control scripts, particularly at the end of model training cycles, when you will need to shift collected data from the Docker container which the model runs on, to the EC2 environment which hosts that container. 

To SSH into an EC2 instance (From Local):

```ssh -i ~/KeyPair.pem ec2-user@ec2IPv4Address```

To shift files from within Docker containers to EC2 root directory (From EC2):

```sudo docker cp DockerID:/MACE/200Model/030IntermediateDataRepository ~/```

### Preparing Data ( 010DataPrepController.sh )

From the root folder, cd to ```MACEControlCenter```, and run ```sh 010DataPrepController.sh```. This will take the dataset (```A_Good_World.csv```) contained in ```MACE/100DataSetPreparation/010AGWData```, and convert it into three different formats, using processors 010 - 030, which are stored in ```MACE/100DataSetPreparation/020ProcessedData/Formats```. 

####Detailed Explanation

In each format, all of the answers are converted to integer values using a standardized answer key. 

#####010QuestionSets

Each row of the dataset consists of a question, an array of answers given to that question, and an array of annotators who are index-matched to the array of answers. In essence, this is a condensed format, in which each row can contains hundreds of individual data points. 

#####020Indiscriminate

This format is indistinguishable from the original dataset, except that all of the answers have been converted into a number from 0 - 7. 

#####030QuestionsPlacedTogether

In this format, all datapoints are sorted in order of questions, segmenting it into distinct blocks based on question.

######Further Processing

The dataPrepController will perform two more operations. It will use processor ```040CutterQSI (Question sets and Indiscriminate)``` and ```050CutterQPT (Questions Placed Together)``` to cut the formatted datasets into segments. This is intended for use by the model's multiple threads, without which, running the model may be computationally intractable. 

QuestionSets will be divided into 10 segments of 19 questions each. 

Indiscriminate is divided into 26 segments of ~744 questions each.

QuestionsPlacedTogether is divided into 190 segments, each for a single question, and each containing all of the responses to that particular question.

The controller will then use ```060CounterProcessor``` to create a count-file for the original data set, ```A_Good_World.csv```. This counter file is stored in ```MACE/100DataSetPreparation/040Counts```, and consists of each question paired with an eight-length vector, representing the number of responses given to that question. 

Each answer is denoted by index. For example, index 0 represents the number of 'good' answers, index 1 is the number of 'bad', index 2 is the number of 'neutral', and so on. 


### Preparing to Deploy to AWS ( 020AWS.sh )

Now that you have prepared your datasets for use, it is time to prepare the model for use on AWS EC2. The first step is to launch an EC2 instance. I recommend a compute-optimized instance with at least 16 cores. I've found c4.8xlarge to be just right for running ```030QuestionsPlacedTogether``` on 190 threads, though CPU usage was strained at ~99% on average.

Once you've settled on an instance, launched it, and downloadeded an AWS keyPair, please navigate to ```MACEControlCenter/Params/AWS.txt``` and edit the variables there. Provide your EC2's IPv4 address, and the path to your downloaded keypair. These variables will be used by ```020AWS.sh```, which is responsible for uploading necessary files and deploying the model on AWS. 

With AWS Settings done, navigate to ```MACEControlCenter/Params/ModelSettings.txt``` and edit your model parameters. Choose the type of data which you wish the model to be run on, and edit modeltype and datatype appropriately. Remember that datatype is identical to modeltype, save for index numbers.

Choose from the following list of options for formatting

1. modelType=QuestionSets
2. dataType=010QuestionSets

1. modelType=Indiscriminate
2. dataType=020Indiscriminate

1. modelType=QuestionsPlacedTogether
2. dataType=030QuestionsPlacedTogether

Also choose sample size, burn size, lag size, and a desired trial number. If this is your first run, a trial number of 1 would make sense. 

For high accuracy, I've found that a sample size of 500, lag of 10, and burn of 60000 provides high accuracy while minimizing memory usage. 

#### 021ModelRunController Settings

Unfortunately, I have not found a way to use ```AWS.txt``` as a source of variables WITHIN the EC2 instance itself. I haven't figured out why, but when I tried to run a bash script in EC2, it would reject or fail to find any source files. As such, it is necessary to edit ```021ModelRunController.sh``` separately, since this script will be run inside a docker container on EC2, and will not make use of the source parameter file. 

Simply choose the modeltype, datatype, model parameter settings, and thread number, identically to those in ModelSettings.txt.

####Deploying to AWS

Once your AWS and model settings are complete, and your data has been prepared, it's time to actually run the model. 

From ```MACEControlCenter```, run ```sh 020AWS.sh```. This will automatically deploy the model to AWS. It will upload dockerfile, a startDocker.sh script, the model code, the specific dataset which the model will be using, and the MACEControlCenter, only. It will then SSH into your EC2 environment, giving you back control. Type ```ls``` to verify that MACE has been successfully uploaded to the root folder. 

###Running the Model on AWS ( 021ModelRunController.sh )

MACE relies on extra dependencies. To install them in a quick and easy fashion, run ```sh startDocker.sh```. This will install WebPPL and WebPPL-CSV, and add the MACE paths to the docker environment. It will then run the ```bash``` command, sending you into the docker container's environment. 

Type ```ls``` to verify that the necessary files are within the docker container.

Now, cd to the ```MACEControlCenter``` and run ```sh 021ModelRunController.sh```. This will write all the WebPPL code to .js format, and then run the model using however many threads are required. 

Upon completion, the console will echo a "Done!" notification, and the data will be saved in ```MACE/200Model/030IntermediateDataRepository```. 

###Downloading Data from AWS

At the moment, your data exists in the docker container, and so it is necessary to shift it to the EC2 environment before transferring it to your local machine. 

Open another terminal tab, SSH into your EC2 instance ( Use this command: ```ssh -i "keyPair.pem" ec2-user@EC2IPv4Address```). 

Now, type ```docker ps``` to list all running docker containers. Select the container ID (The left-most column) of your MACE container, and run the following command:

```sudo docker cp ContainerIDGoesHere:/MACE/200Model/030IntermediateDataRepository ~/```

This will shift the collected data from your previous run to your EC2 root folder.

###Downloading with ( 030DataCollectionController.sh )

With that done, open another terminal tab, this time in your local machine. Run ```sh 030DataCollectionController.sh```. This will run an SCP command to transfer the contents of ```030IntermediateDataRepository```, which will be a csv of predictions per thread, to ```MACE/300CollectedDataRepository```. 

Have caution, especially if your sample size is large. When running ```S5000B50000L20``` with format ```QuestionsPlacedTogether```, you will have to download 190 csv files, each 12mb in size. Please make sure that you have adequate disk space before proceeding, and be prepared for a long download. 

###Processing Collected Data ( 031CollectedDataPrepper.sh )

Before we can assess and analyze the data, we need to concatenate the output of the many disparate threads. Run ```sh 031CollectedDataPrepper.sh```, to perform the following operations:

The scripts in ```310CollectedDataProcessing``` will be used here. ```010ConcatenatorProcessor.py``` will take in multiple csv files and concatenate the contents into ```MACE/300CollectedDataRepository/TrialName/100Concatenated.csv```. 

No matter what the data type is, the concatenated file is of a standardized format. ```011QuestionSetExpander.py``` is used to convert the QuestionSet results, which are a starkly different format from the other two.

After concatenation, we will create a count file for the results. ```020CounterProcessor.py``` will be used for this purpose, creating a count file from the results which is identical in format to ```MACE/100DataSetPreparation/040Counts/010AGWCounts.csv```. These count files will be used for accuracy analysis. 

###Assessing Collected Data ( 040CollectedDataAssessController.sh )

Once the collected data has been processed, run ```sh 040CollectedDataAssessController.sh```. This script will call the processors in ```400CollectedDataAssessment```. 

```010AssessorProcessor.py``` will take the original count file, and the count file of the trial, and score accuracy based on how often the most popular predicted answers from the results match the most popular answers from the original dataset. It returns this as a float between 0 and 1. 

```020WriterProcessor.py``` will write a report on the trial run, adding in timestamps, information about the training run and the data used, and overall accuracy attained. 

```030AnnotatorInfoProcessor.py``` will now analyze the annotators for trustworthiness and accuracy. Average trustworthiness is determined by summing all theta variables for an annotator across all threads, and dividing by the number of theta variables. Accuracy is determined in much the same way, except that the sum is over the number of times the annotator's answer matches the trueLabel, given by the model, for the question. This information is added to the report.

###Reviewing Results ( 500Reports )

The report for each run is saved to a csv file in ```MACE/500Reports```, which can now be perused at your leisure. This describes a single run of MACE from start to finish. 

