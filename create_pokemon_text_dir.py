import os
import pandas as pd
from shutil import copyfile
from sklearn.model_selection import train_test_split
from tqdm import tqdm
from PIL import Image

# Read the CSV file into a DataFrame
df = pd.read_csv("pokemon_text.csv")

# Split the data into training and testing datasets (10% for testing)
train_df, test_df = train_test_split(df, test_size = 0.1, random_state = 7)

# Directories for train and test datasets
train_dir = "train"
test_dir = "test"

# Create the directories if they don't exist
os.makedirs(train_dir, exist_ok=True)
os.makedirs(test_dir, exist_ok=True)

def process_data(data, directory):
    file_names = []
    texts = []

    # Iterate through each row in the DataFrame
    for index, row in tqdm(data.iterrows(), total=data.shape[0]):
        image_path = row['Image Path']
        description = row['Description']

        try:
            img = Image.open(image_path)

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            print(f"Image file error-prone: {image_path}")
            continue

        file_name = f"{index}.jpg"
        file_names.append(file_name)
        texts.append(description)

        # Define paths
        source_image_path = image_path
        destination_image_path = os.path.join(directory, file_name)
        description_path = os.path.join(directory, f"{index}.txt")

        # Copy the image to the destination directory
        try:
            copyfile(source_image_path, destination_image_path)
        except FileNotFoundError:
            print(f"Image file not found: {source_image_path}")

        # Write the description to a text file
        with open(description_path, 'w') as f:
            f.write(description)

    return pd.DataFrame({
        'file_name': file_names,
        'text': texts
    })

# Process train and test datasets
train_metadata = process_data(train_df, train_dir)
test_metadata = process_data(test_df, test_dir)

# Save the DataFrames to CSV files
train_metadata.to_csv(os.path.join(train_dir, 'metadata.csv'), index=False)
test_metadata.to_csv(os.path.join(test_dir, 'metadata.csv'), index=False)

print(f"Train data size: {len(train_metadata)}\nTest data size: {len(test_metadata)}")

print("Training and testing files have been processed and saved.")
