torchrun --nproc_per_node=4 --master_port=8222 train_models.py \
    --model_name_or_path "decapoda-research/llama-7b-hf" \
    --data_path '../../dataset_gen/datasets/cot_train_data.json' \
    --output_dir './saved_cot_llama_model' \
    --bf16 True \
    --num_train_epochs 30 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size  1\
    --gradient_accumulation_steps 8 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 200 \
    --save_total_limit 100 \
    --learning_rate 2e-5 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --fsdp "full_shard auto_wrap"\
    --fsdp_transformer_layer_cls_to_wrap 'LlamaDecoderLayer' \
    --tf32 True