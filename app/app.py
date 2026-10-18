"""DevOps Student Application — Rasylhan Aldiyar (IT2-2309).

Prints the student's information. Values come from environment variables
(STUDENT_NAME, STUDENT_SURNAME, STUDENT_GROUP, STUDENT_ID).

APP_MODE=print  (default) — print the information and exit.
APP_MODE=server — also serve it over HTTP on APP_PORT (default 8080).
"""
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

LINE = "=" * 32
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# Inside the container config is in /app/config, locally it is in ../config
CONFIG_CANDIDATES = [
    os.path.join(BASE_DIR, "config", "app.conf"),
    os.path.join(BASE_DIR, "..", "config", "app.conf"),
]


def read_config(path=None):
    """Read KEY=VALUE pairs from app.conf (lines starting with # are skipped)."""
    config = {}
    if path is None:
        path = next((p for p in CONFIG_CANDIDATES if os.path.exists(p)), "")
    if path and os.path.exists(path):
        with open(path, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    key, value = line.split("=", 1)
                    config[key.strip()] = value.strip()
    return config


def build_message(env=None, config=None):
    env = os.environ if env is None else env
    config = read_config() if config is None else config
    return "\n".join([
        LINE,
        "DevOps Student Application",
        LINE,
        f"Name: {env.get('STUDENT_NAME', 'Unknown')}",
        f"Surname: {env.get('STUDENT_SURNAME', 'Unknown')}",
        f"Group: {env.get('STUDENT_GROUP', 'Unknown')}",
        f"Student ID: {env.get('STUDENT_ID', 'Unknown')}",
        f"Version: {config.get('APP_VERSION', 'unknown')}",
        LINE,
        "Application is running successfully!",
    ])


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            body = "OK"
        else:
            body = build_message()
        data = (body + "\n").encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)


def main():
    print(build_message(), flush=True)
    if os.environ.get("APP_MODE", "print") == "server":
        port = int(os.environ.get("APP_PORT", "8080"))
        print(f"HTTP server listening on port {port}", flush=True)
        HTTPServer(("0.0.0.0", port), Handler).serve_forever()


if __name__ == "__main__":
    main()
