import os
import json
import pandas as pd
from pathlib import Path
import argparse
from datetime import datetime

def setup_args():
    parser = argparse.ArgumentParser(description='Track and compare experiment results')
    parser.add_argument('--results_dir', type=str, default='results', help='Directory with experiment results')
    parser.add_argument('--output', type=str, default='experiment_summary.csv', help='Output file for summary')
    return parser.parse_args()

def gather_experiment_results(results_dir):
    results = []

    # Walk through all subdirectories in results_dir
    for root, dirs, files in os.walk(results_dir):
        # Check if metrics.json exists in this directory
        if 'metrics.json' in files and 'config.json' in files:
            # Load metrics
            with open(os.path.join(root, 'metrics.json'), 'r') as f:
                metrics = json.load(f)

            # Load configuration
            with open(os.path.join(root, 'config.json'), 'r') as f:
                config = json.load(f)

            # Get experiment name from directory
            exp_name = os.path.basename(root)

            # Combine information
            result = {
                'experiment_name': exp_name,
                'timestamp': get_timestamp_from_path(root),
                **{f'metric_{k}': v for k, v in metrics.items()},
                **{f'param_{k}': v for k, v in config.items() if k != 'output_dir'},
            }

            results.append(result)

    return results

def get_timestamp_from_path(path):
    """Extract timestamp from path if available"""
    # Assume timestamp is in format YYYYMMDD_HHMMSS
    path_parts = path.split('_')
    for part in path_parts:
        if len(part) == 8 and part.isdigit():  # YYYYMMDD
            if len(path_parts) > path_parts.index(part) + 1:
                time_part = path_parts[path_parts.index(part) + 1]
                if len(time_part) == 6 and time_part.isdigit():  # HHMMSS
                    return f"{part}_{time_part}"

    # Return current time if no timestamp found
    return datetime.now().strftime('%Y%m%d_%H%M%S')

def main():
    args = setup_args()

    # Gather experiment results
    results = gather_experiment_results(args.results_dir)

    if not results:
        print(f"No experiment results found in {args.results_dir}")
        return

    # Convert to DataFrame and sort by performance
    df = pd.DataFrame(results)

    # Sort by a key metric (e.g., accuracy)
    if 'metric_accuracy' in df.columns:
        df = df.sort_values('metric_accuracy', ascending=False)
    elif 'metric_f1' in df.columns:
        df = df.sort_values('metric_f1', ascending=False)

    # Save to CSV
    df.to_csv(args.output, index=False)
    print(f"Experiment summary saved to {args.output}")

    # Print top experiments
    print("\nTop performing experiments:")
    print(df.head(5).to_string())

if __name__ == "__main__":
    main()