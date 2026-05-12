def compress_context(items, limit=20):
    return {
        "status": "CONTEXT_COMPRESSED",
        "count_in": len(items),
        "count_out": min(len(items), limit),
        "items": items[:limit]
    }
