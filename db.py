import pymysql
import os

def get_db_connection():
    try:
        # 🌐 Running on Railway
        if os.getenv("MYSQLHOST"):
            conn = pymysql.connect(
                host=os.getenv("MYSQLHOST"),
                user=os.getenv("MYSQLUSER"),
                password=os.getenv("MYSQLPASSWORD"),
                database=os.getenv("MYSQLDATABASE"),
                port=int(os.getenv("MYSQLPORT")),
                cursorclass=pymysql.cursors.DictCursor
            )
            print("Connected to Railway database")

        # 🐳 Running in Docker
        elif os.getenv("DB_HOST") == "mysql_db":
            conn = pymysql.connect(
                host="mysql_db",  # Docker service
                user=os.getenv("DB_USER", "root"),
                password=os.getenv("DB_PASSWORD", "root"),
                database=os.getenv("DB_NAME", "ncmis"),
                port=int(os.getenv("DB_PORT", 3306)),
                cursorclass=pymysql.cursors.DictCursor
            )
            print("Connected to Docker database")

        # 💻 Running locally on desktop
        else:
            conn = pymysql.connect(
                    host=os.getenv("DB_HOST", "127.0.0.1"),  # localhost
                    user=os.getenv("DB_USER", "root"),
                    password=os.getenv("DB_PASSWORD", ""),  # add password
                    database=os.getenv("DB_NAME", "ncmis"),
                    port=int(os.getenv("DB_PORT", 3306)),
                    cursorclass=pymysql.cursors.DictCursor
                )
            print("Connected to local MySQL database")

        return conn

    except Exception as e:
        print(f"Database connection error: {e}")
        raise 