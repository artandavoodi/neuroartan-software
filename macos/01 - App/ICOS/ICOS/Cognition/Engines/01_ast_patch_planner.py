from pathlib import Path
from ast_analyzer import find_selector

def plan_css_declaration_patch(path, selector, property_name, target_value):
    result = find_selector(path, selector)

    if result["status"] != "OK" or not result["matches"]:
        return {
            "status": "SELECTOR_NOT_FOUND",
            "path": path,
            "selector": selector
        }

    block = result["matches"][0]
    declarations = block["declarations"]

    for declaration in declarations:
        if declaration["property"] == property_name:
            current_value = declaration["value"]

            if current_value == target_value:
                return {
                    "status": "NO_CHANGE_REQUIRED",
                    "path": path,
                    "selector": selector,
                    "property": property_name,
                    "value": current_value
                }

            return {
                "status": "PATCH_READY",
                "path": path,
                "selector": selector,
                "property": property_name,
                "from": current_value,
                "to": target_value
            }

    return {
        "status": "PROPERTY_NOT_FOUND",
        "path": path,
        "selector": selector,
        "property": property_name
    }

if __name__ == "__main__":
    import sys, json

    if len(sys.argv) != 5:
        print("usage: ast_patch_planner.py <file> <selector> <property> <value>")
        raise SystemExit(1)

    print(json.dumps(
        plan_css_declaration_patch(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]),
        indent=2
    ))
