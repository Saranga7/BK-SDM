# ------------------------------------------------------------------------------------
# Copyright 2023. Nota Inc. All Rights Reserved.
# Code modified from https://github.com/huggingface/diffusers/tree/v0.15.0/examples/text_to_image
# ------------------------------------------------------------------------------------

MODEL_NAME="CompVis/stable-diffusion-v1-4"
TRAIN_DATA_DIR="./data/pokemon/train" # please adjust it if needed
UNET_CONFIG_PATH="./src/unet_config"

UNET_NAME="bk_small" # option: ["bk_base", "bk_small", "bk_tiny"]
OUTPUT_DIR="./results/kd_"$UNET_NAME # please adjust it if needed

BATCH_SIZE=256
GRAD_ACCUMULATION=2

NUM_GPUS=2

StartTime=$(date +%s)

CUDA_VISIBLE_DEVICES=0,1 accelerate launch --multi_gpu --num_processes ${NUM_GPUS} src/kd_train_text_to_image.py \
  --pretrained_model_name_or_path $MODEL_NAME \
  --train_data_dir $TRAIN_DATA_DIR\
  --use_ema \
  --resolution 128 --center_crop --random_flip \
  --train_batch_size $BATCH_SIZE \
  --gradient_checkpointing \
  --mixed_precision="fp16" \
  --learning_rate 5e-05 \
  --max_grad_norm 1 \
  --lr_scheduler="constant" --lr_warmup_steps=0 \
  --report_to="all" \
  --max_train_steps=100_000 \
  --seed 1234 \
  --gradient_accumulation_steps $GRAD_ACCUMULATION \
  --checkpointing_steps 50_000 \
  --valid_steps 5_000 \
  --lambda_sd 1.0 --lambda_kd_output 1.0 --lambda_kd_feat 1.0 \
  --use_copy_weight_from_teacher \
  --unet_config_path $UNET_CONFIG_PATH --unet_config_name $UNET_NAME \
  --output_dir $OUTPUT_DIR


EndTime=$(date +%s)
echo "** KD training takes $(($EndTime - $StartTime)) seconds."

