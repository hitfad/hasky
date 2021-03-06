conf_path=./prepare/default/app-conf/keyword/bow
cp $conf_path/conf.py .
source $conf_path/config 

model_dir=/home/gezi/new/temp/image-caption/keyword/model/bow
mkdir -p $model_dir

#valid_output_path=/home/gezi/new/temp/image-caption/keyword/tfrecord/bow/valid.lijiaoshou/
python ./train.py \
  --train_input=$train_output_path/'train-*' \
  --valid_input=$valid_output_path/'test-*' \
  --fixed_valid_input=$fixed_valid_output_path/'test-*' \
  --valid_resource_dir=$valid_output_path \
  --vocab=$dir/vocab.txt \
  --num_records_file=$train_output_path/num_records.txt \
  --image_url_prefix='D:\data\image-text-sim\evaluate\imgs\' \
  --label_file=$valid_output_path/'image_labels.npy' \
  --image_name_bin=$valid_output_path/'image_names.npy' \
  --image_feature_bin=$valid_output_path/'image_features.npy' \
  --img2text=$valid_output_path/'img2text.npy' \
  --text2id=$valid_output_path/'text2id.npy' \
  --fixed_eval_batch_size 10 \
  --num_fixed_evaluate_examples 10 \
  --num_evaluate_examples 10 \
  --show_eval 1 \
  --train_only 0 \
  --metric_eval 1 \
  --monitor_level 2 \
  --no_log 0 \
  --batch_size 256 \
  --num_gpus 0 \
  --min_after_dequeue 1000 \
  --eval_interval_steps 1000 \
  --metric_eval_interval_steps 1000 \
  --save_interval_seconds 7200 \
  --save_interval_steps 5000 \
  --save_interval_epochs 1 \
  --num_metric_eval_examples 1000 \
  --metric_eval_batch_size 500 \
  --debug 0 \
  --num_negs 1 \
  --interval 100 \
  --eval_batch_size 100 \
  --feed_dict 0 \
  --margin 0.1 \
  --algo bow \
  --combiner=sum \
  --exclude_zero_index 1 \
  --dynamic_batch_length 1 \
  --emb_dim 256 \
  --hidden_size 1024 \
  --model_dir $model_dir \
  --num_records 0 \
  --min_records 12 \
  --log_device 0 
 
