#!/usr/bin/env python
# src/utils/checkpointing.py

import os
import torch
import json
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

class CheckpointManager:
    """Manages model checkpointing during training."""

    def __init__(self, checkpoint_dir, model_name="model", max_to_keep=3):
        """Initialize the checkpoint manager.

        Args:
            checkpoint_dir: Directory to save checkpoints
            model_name: Base name for checkpoint files
            max_to_keep: Maximum number of recent checkpoints to keep
        """
        self.checkpoint_dir = Path(checkpoint_dir)
        self.model_name = model_name
        self.max_to_keep = max_to_keep
        self.checkpoint_files = []

        # Create checkpoint directory if it doesn't exist
        os.makedirs(self.checkpoint_dir, exist_ok=True)

    def save(self, model, optimizer, epoch, metrics, filename=None):
        """Save a checkpoint.

        Args:
            model: The model to checkpoint
            optimizer: The optimizer state
            epoch: Current epoch
            metrics: Metrics dictionary
            filename: Optional custom filename

        Returns:
            str: Path to the saved checkpoint
        """
        if filename is None:
            filename = f"{self.model_name}_epoch{epoch}.pt"

        checkpoint_path = self.checkpoint_dir / filename

        # Create checkpoint
        checkpoint = {
            'epoch': epoch,
            'model_state_dict': model.state_dict(),
            'optimizer_state_dict': optimizer.state_dict(),
            'metrics': metrics
        }

        # Save checkpoint
        torch.save(checkpoint, checkpoint_path)
        logger.info(f"Saved checkpoint to {checkpoint_path}")

        # Track checkpoint file
        self.checkpoint_files.append(str(checkpoint_path))

        # Remove old checkpoints if needed
        self._cleanup_old_checkpoints()

        # Save checkpoint metadata
        self._save_metadata(epoch, metrics, checkpoint_path)

        return str(checkpoint_path)

    def load(self, checkpoint_path=None, model=None, optimizer=None):
        """Load a checkpoint.

        Args:
            checkpoint_path: Path to checkpoint file or None for latest
            model: Model to restore (optional)
            optimizer: Optimizer to restore (optional)

        Returns:
            tuple: (checkpoint, model, optimizer)
        """
        # If no path specified, use the latest checkpoint
        if checkpoint_path is None:
            if not self.checkpoint_files:
                # Try to find checkpoints in the directory
                checkpoint_files = list(self.checkpoint_dir.glob(f"{self.model_name}_epoch*.pt"))
                if not checkpoint_files:
                    logger.warning("No checkpoints found to load")
                    return None, model, optimizer
                checkpoint_path = str(sorted(checkpoint_files)[-1])
            else:
                checkpoint_path = self.checkpoint_files[-1]

        logger.info(f"Loading checkpoint from {checkpoint_path}")
        checkpoint = torch.load(checkpoint_path)
        #!/usr/bin/env python
# src/utils/checkpointing.py

import os
import torch
import json
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

class CheckpointManager:
    """Manages model checkpointing during training."""

    def __init__(self, checkpoint_dir, model_name="model", max_to_keep=3):
        """Initialize the checkpoint manager.

        Args:
            checkpoint_dir: Directory to save checkpoints
            model_name: Base name for checkpoint files
            max_to_keep: Maximum number of recent checkpoints to keep
        """
        self.checkpoint_dir = Path(checkpoint_dir)
        self.model_name = model_name
        self.max_to_keep = max_to_keep
        self.checkpoint_files = []

        # Create checkpoint directory if it doesn't exist
        os.makedirs(self.checkpoint_dir, exist_ok=True)

    def save(self, model, optimizer, epoch, metrics, filename=None):
        """Save a checkpoint.

        Args:
            model: The model to checkpoint
            optimizer: The optimizer state
            epoch: Current epoch
            metrics: Metrics dictionary
            filename: Optional custom filename

        Returns:
            str: Path to the saved checkpoint
        """
        if filename is None:
            filename = f"{self.model_name}_epoch{epoch}.pt"

        checkpoint_path = self.checkpoint_dir / filename

        # Create checkpoint
        checkpoint = {
            'epoch': epoch,
            'model_state_dict': model.state_dict(),
            'optimizer_state_dict': optimizer.state_dict(),
            'metrics': metrics
        }

        # Save checkpoint
        torch.save(checkpoint, checkpoint_path)
        logger.info(f"Saved checkpoint to {checkpoint_path}")

        # Track checkpoint file
        self.checkpoint_files.append(str(checkpoint_path))

        # Remove old checkpoints if needed
        self._cleanup_old_checkpoints()

        # Save checkpoint metadata
        self._save_metadata(epoch, metrics, checkpoint_path)

        return str(checkpoint_path)

    def load(self, checkpoint_path=None, model=None, optimizer=None):
        """Load a checkpoint.

        Args:
            checkpoint_path: Path to checkpoint file or None for latest
            model: Model to restore (optional)
            optimizer: Optimizer to restore (optional)

        Returns:
            tuple: (checkpoint, model, optimizer)
        """
        # If no path specified, use the latest checkpoint
        if checkpoint_path is None:
            if not self.checkpoint_files:
                # Try to find checkpoints in the directory
                checkpoint_files = list(self.checkpoint_dir.glob(f"{self.model_name}_epoch*.pt"))
                if not checkpoint_files:
                    logger.warning("No checkpoints found to load")
                    return None, model, optimizer
                checkpoint_path = str(sorted(checkpoint_files)[-1])
            else:
                checkpoint_path = self.checkpoint_files[-1]

        logger.info(f"Loading checkpoint from {checkpoint_path}")
        checkpoint = torch.load(checkpoint_path)
