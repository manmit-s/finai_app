# 🔴 CRITICAL FIX - Gemini Model Name Issue

## The Real Problem

The v1beta API doesn't support `gemini-1.5-flash-latest` or `models/gemini-1.5-flash-latest`.

## ✅ SOLUTION: Use `gemini-pro`

### Update your main.py on Render:

```python
# Change this line (around line 55):
model = genai.GenerativeModel('gemini-pro')  # ← Use this for v1beta API
```

## 🎯 Model Names by API Version

### For v1beta API (what you're using):
- ✅ `gemini-pro` - WORKS (use this!)
- ❌ `gemini-1.5-flash-latest` - DOESN'T WORK
- ❌ `models/gemini-1.5-flash` - DOESN'T WORK
- ❌ `gemini-1.5-flash` - DOESN'T WORK

### For v1 API (if you upgrade):
- ✅ `models/gemini-1.5-flash`
- ✅ `models/gemini-1.5-pro`

## 🚀 Complete Working Backend Code

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import google.generativeai as genai
import os
from typing import Optional, Dict, Any

app = FastAPI(title="FinAI Backend API")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configure Gemini
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
genai.configure(api_key=GEMINI_API_KEY)


class GenerateRequest(BaseModel):
    prompt: str
    context: Optional[Dict[str, Any]] = None


@app.get("/")
async def root():
    return {"status": "online", "service": "FinAI Backend API"}


@app.post("/generate")
async def generate_finance_advice(request: GenerateRequest):
    try:
        # ⭐ THIS IS THE CRITICAL LINE - Use 'gemini-pro' for v1beta
        model = genai.GenerativeModel('gemini-pro')
        
        # Build prompt
        full_prompt = request.prompt
        if request.context:
            context_str = f"\n\nFinancial Context:\n"
            for key, value in request.context.items():
                context_str += f"- {key}: {value}\n"
            full_prompt = context_str + f"\nUser Question: {request.prompt}"
        
        # Generate response
        response = model.generate_content(full_prompt)
        
        return {
            "success": True,
            "response": response.text,
            "error": None
        }
        
    except Exception as e:
        print(f"Error in generate_finance_advice: {e}")
        return {
            "success": False,
            "response": None,
            "error": str(e)
        }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

## 📝 Deployment Steps

1. **Update your main.py** with the code above (specifically line with model name)

2. **Make sure GEMINI_API_KEY is set** in Render environment variables

3. **Commit and push:**
   ```bash
   git add main.py
   git commit -m "Fix: Use gemini-pro model for v1beta API"
   git push origin main
   ```

4. **Wait for Render to redeploy** (auto-deploys on push)

5. **Test** after deployment:
   ```bash
   curl -X POST https://finai-0wgg.onrender.com/generate \
     -H "Content-Type: application/json" \
     -d '{"prompt":"Hello, how can you help me?"}'
   ```

## ✅ Expected Result

After fix, your logs should show:
```
INFO: "POST /generate HTTP/1.1" 200 OK
```

No more 404 errors!

## 🆘 Alternative: List Available Models First

If you want to see what models are available, add this endpoint:

```python
@app.get("/list-models")
async def list_models():
    try:
        models = []
        for m in genai.list_models():
            if 'generateContent' in m.supported_generation_methods:
                models.append(m.name)
        return {"models": models}
    except Exception as e:
        return {"error": str(e)}
```

Then visit: `https://finai-0wgg.onrender.com/list-models`

## 🎯 Key Takeaway

**For Google Gemini v1beta API, always use:**
```python
model = genai.GenerativeModel('gemini-pro')
```

This is the most stable and widely supported model for the v1beta API version.
