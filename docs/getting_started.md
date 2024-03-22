# Getting Started

## Install

Clone the Articular repository.

```bash
git clone https://github.com/edwardanderson/articular.git
```

Change to the Articular directory.

```bash
cd articular
```

Create a new virtual environment called `.env` with a recent version of Python.

```bash
python3.10 -m venv .env
```

Activate the virtual environment.

```bash
source .env/bin/activate
```

Install the package.

```bash
pip install --editable .
```

Check that the application is working.

```bash
articular --help
```

Run the tests.

```bash
python tests/tests.py
```
