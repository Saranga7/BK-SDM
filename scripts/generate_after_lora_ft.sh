# ------------------------------------------------------------------------------------
# Copyright 2023. Nota Inc. All Rights Reserved.
# ------------------------------------------------------------------------------------

IDENTIFIER_NAME="sks11df" # must be the unique identifier used in DreamBooth finetuning
SUBJECT_NAME="Pikachu" # 1st column value in https://github.com/google/dreambooth/blob/main/dataset/prompts_and_classes.txt#L1-L33
CLASS_NAME="Pikachu" # 2nd column value in https://github.com/google/dreambooth/blob/main/dataset/prompts_and_classes.txt#L1-L33

SRC_MODEL="nota-ai/bk-sdm-base" # source model to be combined with LoRA weights
MODEL_DIR="./my_results_ft/lora/$SUBJECT_NAME/bk-sdm-base" # the path of LoRA weights; please adjust it if needed
IMG_DIR="./outputs_ft/lora/$SUBJECT_NAME/bk-sdm-base" # please adjust it if needed

# prompt examples: https://github.com/google/dreambooth/blob/main/dataset/prompts_and_classes.txt#L35-L95
# VAL_TEXT="a $IDENTIFIER_NAME $CLASS_NAME in the snow"
# VAL_TEXT="a $IDENTIFIER_NAME $CLASS_NAME in the jungle"
# VAL_TEXT="a $IDENTIFIER_NAME $CLASS_NAME with a city in the background"
# VAL_TEXT="a painting of $IDENTIFIER_NAME $CLASS_NAME in the style of leonardo da vinci"
# VAL_TEXT="a $IDENTIFIER_NAME $CLASS_NAME in front of Eiffel Tower"
# VAL_TEXT="a $IDENTIFIER_NAME $CLASS_NAME in space"
VAL_TEXT="a $IDENTIFIER_NAME $CLASS_NAME with the Northern lights in the sky"

CUDA_VISIBLE_DEVICES=0 python3 src/generate_single_prompt.py \
    --use_dpm_solver \
    --model_id $SRC_MODEL \
    --save_dir $IMG_DIR \
    --lora_weight_path $MODEL_DIR \
    --is_lora_checkpoint \
    --num_images 4 \
    --val_prompt "$VAL_TEXT"
