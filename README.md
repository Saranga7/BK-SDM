
## To train BK-SDM models 

Please refer to the "Distillation Pretraining" section of BK-SDM_original_README.md


Note: All .sh are inside the directory scripts


### To run BK-SDM models with number of attention heads halved


Set UNET_CONFIG_PATH in the kd_train* .sh files to 
```
./src/saranga/unet_config
```

And UNET_NAME to "bk_base", "bk_small", or "bk_tiny"


### To run BK-SDM trainings with the SiLUs replaced by identity function of the Studnet UNet

Set argument ``replace_silu_with_identity`` to True in kd_train *.sh files


### For evaluation

Please refer to "Evaluation on MS-COCO Benchmark" section of BK-SDM_original_README.md



## For fine-tuning on Pokemon Dataset

### Create the required dataset

- To create Dreambooth like Pokemon dataset, first download the images from 
https://www.kaggle.com/datasets/lantian773030/pokemonclassification


- Then add the prompts_and_classes.txt file in the data directory along with the sub-directories containing pokemon images.


### Fine-tuning

Adjust both SUBJECT_NAME, CLASS_NAME in finetune_full.sh or finetune_lora.sh according to required Pokemon. For example, if you want Pikachu, 

```
SUBJECT_NAME="Pikachu" 
CLASS_NAME="Pikachu"
```


For full fine-tuning:
```
bash scripts/finetune_full.sh 
bash scripts/generate_after_full_ft.sh
```
For LoRA fine-tuning
```
bash scripts/finetune_lora.sh # learning rate 1e-4
bash scripts/generate_after_lora_ft.sh  
```













