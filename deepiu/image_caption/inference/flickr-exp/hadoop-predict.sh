#!/bin/sh
input=/app/tuku/chenghuige/temp/img2fea
outfile=tf-bow-predict
output=/app/tuku/chenghuige/temp/$outfile

$HADOOP_HOME/bin/hadoop fs -test -e $output
if [ $? -eq 0 ];then
	$HADOOP_HOME/bin/hadoop fs -rmr $output
fi

$HADOOP_HOME/bin/hadoop streaming \
	-D mapred.hce.replace.streaming="false" \
	-input $input \
	-output $output \
	-mapper "./deepiu/bin/python ./predict.py" \
	-reducer NONE \
	-file "./predict.py" \
	-file "./vocab.bin" \
	-file "./test.txt" \
    -file "./model.ckpt-12000" \
	-cacheArchive "/app/tuku/chenghuige/lib/deepiu.tar.gz#." \
	-jobconf stream.memory.limit=1200 \
	-jobconf mapred.job.name="chenghuige-predict" \
	-jobconf mapred.reduce.tasks=100 \
	-jobconf mapred.map.tasks=1 \
	-jobconf mapred.job.map.capacity=200 \
	-jobconf mapred.job.reduce.capacity=100

rm -rf ./$outfile.txt
hadoop fs -getmerge $output $outfile.txt
