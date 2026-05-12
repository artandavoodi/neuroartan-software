import os

def exists(path):
    return os.path.exists(path)

def filter_existing(paths):
    return [p for p in paths if os.path.exists(p)]

def assert_all_exist(paths):
    missing = [p for p in paths if not os.path.exists(p)]
    if missing:
        raise Exception(f"Missing paths: {missing}")
    return True

if __name__ == "__main__":
    import sys
    for p in sys.argv[1:]:
        print(p, "OK" if exists(p) else "MISSING")
