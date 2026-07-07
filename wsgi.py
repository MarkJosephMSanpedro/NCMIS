# wsgi.py
from app import app  # import your Flask app object

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)