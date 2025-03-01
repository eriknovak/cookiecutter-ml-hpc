import argparse
import logging
import os
import pandas as pd
from pathlib import Path

from src.utils.logger import setup_logger

logger = setup_logger(__name__)

def setup_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='Process raw data for ML model')
    parser.add_argument('--input_path', type=str, required=True, help='Path to raw data')
    parser.add_argument('--output_path', type=str, required=True, help='Path to save processed data')
    parser.add_argument('--split_ratio', type=float, default=0.2, help='Test split ratio')
    parser.add_argument('--seed', type=int, default=42, help='Random seed')
    return parser.parse_args()

def load_data(input_path):
    """Load data from input path."""
    logger.info(f"Loading data from {input_path}")
    # Add your data loading code here
    # Example:
    if input_path.endswith('.csv'):
        return pd.read_csv(input_path)
    elif input_path.endswith('.json'):
        return pd.read_json(input_path)
    else:
        raise ValueError(f"Unsupported file format: {input_path}")

def preprocess_data(df):
    """Preprocess the data."""
    logger.info("Preprocessing data")
    # Add your preprocessing code here
    # Example:
    # df = df.dropna()
    # df = df.drop_duplicates()
    return df

def split_data(df, split_ratio, seed):
    """Split data into train and test sets."""
    logger.info(f"Splitting data with ratio {split_ratio} and seed {seed}")
    from sklearn.model_selection import train_test_split
    return train_test_split(df, test_size=split_ratio, random_state=seed)

def save_data(train_df, test_df, output_path):
    """Save processed data to output path."""
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    train_path = os.path.join(os.path.dirname(output_path), 'train.csv')
    test_path = os.path.join(os.path.dirname(output_path), 'test.csv')

    logger.info(f"Saving training data to {train_path}")
    train_df.to_csv(train_path, index=False)

    logger.info(f"Saving test data to {test_path}")
    test_df.to_csv(test_path, index=False)

def main():
    """Main function for data processing."""
    args = setup_args()

    df = load_data(args.input_path)
    df = preprocess_data(df)
    train_df, test_df = split_data(df, args.split_ratio, args.seed)
    save_data(train_df, test_df, args.output_path)

    logger.info("Data processing completed successfully")

if __name__ == "__main__":
    main()