import json, pyarrow as pa

def handler(event, context):
    _ = pa.array([1,2,3])  # sanity
    return {"statusCode": 200, "body": json.dumps({"ok": True, 
        "engine": "container"})}

       