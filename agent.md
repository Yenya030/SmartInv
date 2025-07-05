# SmartInv Repo Guide

This repository implements **SmartInv**, a toolchain for inferring and verifying invariants in Solidity smart contracts.  Below is a high level overview to help new contributors understand the layout and main entry points.

## Key Components

- **dataset_gen/** – Scripts and data for constructing training datasets.  `generator.py` converts manually curated spreadsheets into JSON and text datasets.  The `datasets` subfolder contains various TXT and JSON files used for fine-tuning and PEFT models.  Run `python generator.py` from inside `dataset_gen` to regenerate datasets.  Use `clean.py` to clear previous output.
- **finetune/** and **evaluation/** – Scripts for model training and evaluation.  These include helpers for GPT‐style models and PEFT LoRA models.
- **main.py** – Provides a Gradio interface to fine‑tune or run a LoRA Llama model.  Launch with `python main.py` and open the displayed URL to train or generate text.
- **smartinv.py** – Command line driver that orchestrates invariant inference and optional verification.  Heavy mode uses local PEFT models while light mode queries GPT‑4.  Example:
  ```bash
  python smartinv.py --light True --file <path/to/contract.sol> --contract <ContractName>
  ```
  Use `--heavy True` for the fine‑tuned model or enable `--verify` to run the VeriSol verifier.
- **verifier/** – Contains the inference and verification logic.  `infer.py` and `infer_upgrade.py` implement step‑wise invariant inference.  `verify.py` wraps the VeriSol tool and helper utilities.  The `prompts` folder holds GPT prompts used in inference.
- **tests/** – Benchmarks, sample contracts and helper scripts.  The `scripts` directory describes how large contract datasets were collected from Etherscan and provides utilities for adding line numbers or retrieving contract sources.

## Typical Workflow

1. **Prepare datasets** using scripts in `dataset_gen/` if you wish to re-train models.
2. **Fine‑tune models** via `main.py` or use the provided LoRA checkpoints.
3. **Infer invariants** with `smartinv.py` (light or heavy mode).  Results are written under `all_results/`.
4. **(Optional) Verify** inferred invariants using the VeriSol pipeline.  Verification logs are stored in `verified_results/`.

## Notes

- Most paths in the repo assume local directories (see comments in `smartinv.py` and `verifier/infer.py`).  Update them to match your environment before running experiments.
- `requirements.txt` lists Python dependencies (transformers, peft, gradio, openai, etc.).  Create a virtual environment and install these packages prior to running any scripts.

