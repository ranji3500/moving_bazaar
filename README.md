# 🐍 Python Project Setup

This project uses a Python virtual environment and installs dependencies from `requirements.txt`.

---

## 🔧 Setup Instructions

### 1. Create Virtual Environment

Run the following command in your project directory:

note:pythopn version 3.9
```bash
python -m venv venv
```

This creates a virtual environment named `venv`.

---

### 2. Activate the Environment

**Windows (CMD):**

```cmd
venv\Scripts\activate
```

**Windows (PowerShell):**

```powershell
.\venv\Scripts\Activate.ps1
```

**macOS / Linux:**

```bash
source venv/bin/activate
```

---

### 3. Install Dependencies

Make sure `requirements.txt` is in the root of your project.

Then run:

```bash
pip install -r requirements.txt
```

---

### 4. Deactivate the Environment

When you're done:

```bash
deactivate
```

---

## 📁 Project Structure

```
project-root/
│
├── venv/                  # Virtual environment (after setup)
├── requirements.txt       # Python dependencies
├── your_code.py           # Your main Python script(s)
└── README.md              # This file
```

---

## 💡 Notes

- Always activate the environment before running your code.
- Never commit the `venv/` folder to GitHub. Use `.gitignore`.

---

## ✅ `.gitignore` Sample

Add this to your `.gitignore` file:

```
venv/
__pycache__/
*.pyc
```


---

### 5. Run the Application

After installing dependencies, run your Python app:

```bash
python app.py
```

Make sure `app.py` exists in the project root.
