import numpy as np
from sklearn.metrics import (
    accuracy_score,
    precision_recall_fscore_support,
    confusion_matrix,
    roc_auc_score,
    mean_squared_error,
    r2_score
)

def compute_classification_metrics(y_true, y_pred, y_prob=None):
    """Compute classification metrics.

    Args:
        y_true: True labels
        y_pred: Predicted labels
        y_prob: Predicted probabilities

    Returns:
        dict: Dictionary of metrics
    """
    metrics = {}

    # Basic metrics
    metrics['accuracy'] = accuracy_score(y_true, y_pred)

    # Precision, recall, F1
    precision, recall, f1, _ = precision_recall_fscore_support(
        y_true, y_pred, average='weighted'
    )
    metrics['precision'] = precision
    metrics['recall'] = recall
    metrics['f1'] = f1

    # Confusion matrix
    metrics['confusion_matrix'] = confusion_matrix(y_true, y_pred).tolist()

    # AUC if probabilities are provided
    if y_prob is not None and len(np.unique(y_true)) == 2:
        metrics['auc'] = roc_auc_score(y_true, y_prob)

    return metrics

def compute_regression_metrics(y_true, y_pred):
    """Compute regression metrics.

    Args:
        y_true: True values
        y_pred: Predicted values

    Returns:
        dict: Dictionary of metrics
    """
    metrics = {}

    # Mean squared error
    metrics['mse'] = mean_squared_error(y_true, y_pred)
    metrics['rmse'] = np.sqrt(metrics['mse'])

    # R-squared
    metrics['r2'] = r2_score(y_true, y_pred)

    # Mean absolute error
    metrics['mae'] = np.mean(np.abs(y_true - y_pred))

    return metrics