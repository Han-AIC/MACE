source ./Params/AWS.txt
echo "Downloading data from EC2 instance @${AWSADDRESS}"
scp -i ${EC2KEY} -r ${AWSUSER}@${AWSADDRESS}:~/030IntermediateDataRepository/* ../MACE/300CollectedDataRepository
