# ------------------------------------------------------------------------------------
# Copyright 2023. Nota Inc. All Rights Reserved.
# Code modified from https://github.com/huggingface/diffusers/tree/v0.15.0/examples/text_to_image
# ------------------------------------------------------------------------------------

MODEL_NAME="CompVis/stable-diffusion-v1-4"
TRAIN_DATA_DIR="./data/laion_aes/preprocessed_11k" # please adjust it if needed
UNET_CONFIG_PATH="./saranga/unet_config"

UNET_NAME="bk_tiny" # option: ["bk_base", "bk_small", "bk_tiny"]
OUTPUT_DIR="./results/toy_"$UNET_NAME # please adjust it if needed

BATCH_SIZE=16
GRAD_ACCUMULATION=4

StartTime=$(date +%s)

CUDA_VISIBLE_DEVICES=2 accelerate launch src/kd_train_text_to_image.py \
  --pretrained_model_name_or_path $MODEL_NAME \
  --replace_silu_with_identity False\   # Set to true to replace SiLU with Identity
  --train_data_dir $TRAIN_DATA_DIR\
  --use_ema \
  --resolution 64 --center_crop --random_flip \
  --train_batch_size $BATCH_SIZE \
  --gradient_checkpointing \
  --mixed_precision="fp16" \
  --learning_rate 5e-05 \
  --max_grad_norm 1 \
  --lr_scheduler="constant" --lr_warmup_steps=0 \
  --report_to="all" \
  --max_train_steps=5000 \
  --seed 1234 \
  --gradient_accumulation_steps $GRAD_ACCUMULATION \
  --checkpointing_steps 5000 \
  --valid_steps 500 \
  --lambda_sd 1.0 --lambda_kd_output 1.0 --lambda_kd_feat 1.0 \
  --use_copy_weight_from_teacher \
  --unet_config_path $UNET_CONFIG_PATH --unet_config_name $UNET_NAME \
  --output_dir $OUTPUT_DIR


EndTime=$(date +%s)
echo "** KD training takes $(($EndTime - $StartTime)) seconds."

