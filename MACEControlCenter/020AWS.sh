source ./Params/AWS.txt
source ./Params/ModelSettings.txt


chmod 400 ${EC2KEY} &&

scp -i ${EC2KEY} -r ../dockerfile ${AWSUSER}@${AWSADDRESS}:~/  &&
scp -i ${EC2KEY} -r ../startDocker.sh ${AWSUSER}@${AWSADDRESS}:~/ && 
scp -i ${EC2KEY} -r ./Resources/MACE ${AWSUSER}@${AWSADDRESS}:~/ &&
scp -i ${EC2KEY} -r ../MACE/100DataSetPreparation/020ProcessedData/Formats/${dataType} ${AWSUSER}@${AWSADDRESS}:~/MACE/100DataSetPreparation/020ProcessedData/Formats &&
scp -i ${EC2KEY} -r ../MACE/200Model ${AWSUSER}@${AWSADDRESS}:~/MACE &&
scp -i ${EC2KEY} -r ../MACEControlCenter ${AWSUSER}@${AWSADDRESS}:~/ && 

ssh -i ${EC2KEY} ${AWSUSER}@${AWSADDRESS} 



