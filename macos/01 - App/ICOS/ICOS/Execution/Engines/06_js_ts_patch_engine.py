from pathlib import Path
import re

def replace_function_body(path, function_name, new_body):
    p = Path(path)
    if not p.exists():
        return {"status": "MISSING_FILE", "path": str(path)}

    text = p.read_text(errors="ignore")
    pattern = re.compile(rf"(function\\s+{function_name}\\s*\\([^)]*\\)\\s*\\{{)(.*?)(\\n\\}})", re.S)
    match = pattern.search(text)

    if not match:
        return {"status": "FUNCTION_NOT_FOUND", "function": function_name, "path": str(path)}

    updated = text[:match.start(2)] + "\\n" + new_body + text[match.end(2):]
    p.write_text(updated)

    return {"status": "JS_PATCH_APPLIED", "path": str(path), "function": function_name}
