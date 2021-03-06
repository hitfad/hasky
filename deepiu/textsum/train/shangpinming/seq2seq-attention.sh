source ./prepare/default/config 
cp ./prepare/default/conf.py  .
cp ./inputs/default/input.py .

model_dir=/home/gezi/new/temp/makeup/title2name/model/seq2seq.attention
assistant_model_dir=/home/gezi/new/temp/makeup/title2name/model/bow
mkdir -p $model_dir

#--fixed_valid_input $fixed_valid_output_path/'test' \
#--train_input $train_output_path/'train_*' \
python ./train.py \
  --train_input $train_output_path/'train*' \
  --valid_input $valid_output_path/'test*' \
	--valid_resource_dir $valid_output_path \
	--vocab $dir/vocab.txt \
  --num_records_file  $train_output_path/num_records.txt \
  --image_url_prefix '' \
  --model_dir=$model_dir \
  --algo seq2seq \
  --num_sampled 0 \
  --log_uniform_sample 1 \
  --fixed_eval_batch_size 10 \
  --num_fixed_evaluate_examples 1 \
  --num_evaluate_examples 10 \
  --eval_batch_size 200 \
  --debug 0 \
  --show_eval 1 \
  --train_only 0 \
  --gen_predict 1 \
  --monitor_level 2 \
  --no_log 0 \
  --batch_size 256 \
  --num_gpus 0 \
  --eval_batch_size 100 \
  --min_after_dequeue 500 \
  --learning_rate 0.01 \
  --eval_interval_steps 500 \
  --save_interval_steps 1000 \
  --save_interval_epochs 1 \
  --metric_eval 1 \
  --num_metric_eval_examples 100 \
  --metric_eval_batch_size 100 \
  --metric_eval_interval_steps 1000 \
  --feed_dict 0 \
  --seg_method $online_seg_method \
  --feed_single $feed_single \
  --seq_decode_method 0 \
  --word_embedding_file $dir/word2vec/word_embedding.npy \
  --beam_size 10 \
  --decode_max_words 20 \
  --dynamic_batch_length 1 \
  --rnn_method forward \
  --emb_dim 256 \
  --rnn_hidden_size 1024 \
  --experiment_rnn_decoder 0 \
  --show_beam_search 1 \
  --gen_predict 1 \
  --add_text_start 1 \
  --rnn_output_method 3 \
  --use_attention 1 \
  --attention_option luong \
  --cell lstm_block \
  --num_records 0 \
  --min_records 0 \
  --log_device 0 \
  --clip_gradients 1 \
  --work_mode full \
  --assistant_algo dual_bow \
  --assistant_model_dir $assistant_model_dir \

