# --- Logging setup ------------------------------------------------------------
import logging
import os
from logging.handlers import TimedRotatingFileHandler
from datetime import datetime

# Create logs folder if not exists
os.makedirs("logs", exist_ok=True)

# Log file pattern -> logfile-20-09-2025.log
logfile = os.path.join("logs", f"logfile-{datetime.now().strftime('%d-%m-%Y')}.log")

# Create a timed rotating handler (rotates daily)
file_handler = TimedRotatingFileHandler(
    filename=logfile,
    when="midnight",      # rotate at midnight
    interval=1,
    backupCount=7,        # keep last 7 days
    encoding="utf-8",
)
# Suffix for rotated files (optional, but keeps your format consistent)
file_handler.suffix = "%d-%m-%Y"

formatter = logging.Formatter(
    "%(asctime)s [%(levelname)s] %(name)s:%(lineno)d - %(message)s"
)
file_handler.setFormatter(formatter)

# Console handler (optional, shows in terminal too)
console_handler = logging.StreamHandler()
console_handler.setFormatter(formatter)

# Root logger config
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)   # DEBUG = trace + info + error
logger.addHandler(file_handler)
logger.addHandler(console_handler)

# Your app logger
app_logger = logging.getLogger("app")
