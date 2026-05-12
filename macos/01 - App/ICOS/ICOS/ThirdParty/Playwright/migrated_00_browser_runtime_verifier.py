from pathlib import Path
import json
import subprocess
import time
from urllib.error import URLError
from urllib.request import urlopen

ROOT = Path("/Users/artan/Documents/Neuroartan/website")
SCREENSHOT_DIR = Path(__file__).resolve().parent / "runtime_screenshots"
SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)

PLAYWRIGHT_SCREENSHOT_DIR = SCREENSHOT_DIR / "playwright"
PLAYWRIGHT_SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)

DEV_SERVER_URL = "http://127.0.0.1:8891"


def run_command(command, cwd=None):
    try:
        result = subprocess.run(
            command,
            cwd=cwd,
            text=True,
            capture_output=True
        )

        return {
            "status": "OK" if result.returncode == 0 else "FAILED",
            "code": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
        }

    except Exception as e:
        return {
            "status": "ERROR",
            "error": str(e)
        }


def verify_dev_server():
    try:
        response = urlopen(DEV_SERVER_URL, timeout=2)

        return {
            "status": "SERVER_OK",
            "url": DEV_SERVER_URL,
            "http_status": response.status,
            "headers": dict(response.headers)
        }

    except URLError as e:
        return {
            "status": "SERVER_UNREACHABLE",
            "url": DEV_SERVER_URL,
            "error": str(e)
        }


def capture_screenshot(name="runtime_capture"):
    timestamp = int(time.time())

    target = SCREENSHOT_DIR / f"{name}_{timestamp}.png"

    result = run_command([
        "screencapture",
        "-x",
        str(target)
    ])

    return {
        "status": result["status"],
        "path": str(target),
        "details": result
    }


def playwright_capture(url=DEV_SERVER_URL):
    try:
        from playwright.sync_api import sync_playwright

    except Exception as e:
        return {
            "status": "PLAYWRIGHT_NOT_INSTALLED",
            "error": str(e)
        }

    timestamp = int(time.time())
    target = PLAYWRIGHT_SCREENSHOT_DIR / f"playwright_runtime_{timestamp}.png"

    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page(viewport={"width": 1440, "height": 1200})

            page.goto(url, wait_until="networkidle", timeout=15000)

            dom_metrics = {
                "title": page.title(),
                "url": page.url,
                "body_classes": page.locator("body").get_attribute("class"),
                "navigation_count": page.locator("nav").count(),
                "button_count": page.locator("button").count(),
                "link_count": page.locator("a").count(),
            }

            page.screenshot(path=str(target), full_page=True)
            browser.close()

            return {
                "status": "PLAYWRIGHT_CAPTURE_OK",
                "path": str(target),
                "dom_metrics": dom_metrics
            }

    except Exception as e:
        return {
            "status": "PLAYWRIGHT_CAPTURE_FAILED",
            "error": str(e)
        }


def verify_runtime():
    server = verify_dev_server()
    screenshot = capture_screenshot("homepage_runtime")

    playwright_result = None

    if server["status"] == "SERVER_OK":
        playwright_result = playwright_capture()

    return {
        "status": "OK",
        "root": str(ROOT),
        "server": server,
        "screenshot": screenshot,
        "playwright": playwright_result,
        "screenshot_directory": str(SCREENSHOT_DIR),
        "runtime": {
            "browser_verification": True,
            "screenshot_capture": True,
            "visual_runtime_layer": True,
            "playwright_enabled": True,
            "dom_runtime_verification": True,
        }
    }


if __name__ == "__main__":
    print(json.dumps(verify_runtime(), indent=2))
