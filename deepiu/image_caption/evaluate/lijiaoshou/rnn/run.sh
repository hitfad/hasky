#python ./inference-score-bytextsim-ad.py > ~/new/temp/image-caption/lijiaoshou/model/rnn/ad.html 
#python ./inference-score-bytextsim-ad.py --text_file /home/gezi/data/lijiaoshou/wenan.special.txt > ~/new/temp/image-caption/lijiaoshou/model/rnn/ad.special.html 
#python ./inference-score-bytextsim.py --text_file /home/gezi/data/lijiaoshou/wenan.special.txt > ~/new/temp/image-caption/lijiaoshou/model/rnn/noad.special.html 
#python ./inference-score-bytextsim-ad.py --model_dir /home/gezi/new/temp/image-caption/keyword/model/rnn/ --vocab /home/gezi/new/temp/image-caption/keyword/tfrecord/seq-basic/vocab.txt --text_file /home/gezi/data/lijiaoshou/wenan.special.txt > ~/new/temp/image-caption/lijiaoshou/model/rnn/ad.special.keyword.html 
python ./inference-score-bytextsim-ad.py --model_dir /home/gezi/new/temp/image-caption/keyword/model/rnn.lijiaoshou/ --vocab /home/gezi/new/temp/image-caption/keyword/tfrecord/seq-basic/vocab.txt --text_file /home/gezi/data/lijiaoshou/wenan.special.txt > ~/new/temp/image-caption/lijiaoshou/model/rnn/ad.special.finetune.html 