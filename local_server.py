"""
FinAI Backend - FastAPI Local Server
Run this on your local machine during hackathon
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import google.generativeai as genai
from typing import Optional, Dict, Any

app = FastAPI(title="FinAI Local Backend")

# CORS - Allow Flutter app to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configure Gemini - Put your API key here
GEMINI_API_KEY = "AIzaSyCNU4sg8KPFsUvvPAo7DQl7Zd2TPdLd0hI"  # ← Replace with your actual key
genai.configure(api_key=GEMINI_API_KEY)


class GenerateRequest(BaseModel):
    prompt: str
    context: Optional[Dict[str, Any]] = None


@app.get("/")
async def root():
    return {
        "status": "online",
        "service": "FinAI Local Backend",
        "message": "Server is running!"
    }


@app.post("/generate")
async def generate_finance_advice(request: GenerateRequest):
    try:
        # Use gemini-pro model
        model = genai.GenerativeModel('gemini-pro')
        
        # Build prompt with context
        full_prompt = _build_prompt(request.prompt, request.context)
        
        # Generate response
        print(f"📝 Prompt: {request.prompt[:50]}...")
        response = model.generate_content(full_prompt)
        print(f"✅ Response generated successfully")
        
        return {
            "success": True,
            "response": response.text,
            "error": None
        }
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return {
            "success": False,
            "response": None,
            "error": str(e)
        }


def _build_prompt(user_prompt: str, context: Optional[Dict[str, Any]]) -> str:
    """Build enhanced prompt with financial context"""
    if not context:
        return f"""You are FinAI, a helpful personal finance assistant.
Answer this question in a friendly, concise way:

{user_prompt}"""
    
    # Build context
    context_parts = []
    
    if 'user_name' in context:
        context_parts.append(f"User: {context['user_name']}")
    
    if 'currency' in context:
        context_parts.append(f"Currency: {context['currency']}")
    
    if 'financial_health_score' in context:
        context_parts.append(f"Financial Health Score: {context['financial_health_score']}/100")
    
    if 'monthly_spending' in context:
        context_parts.append(f"Monthly Spending: {context['monthly_spending']}")
    
    if 'monthly_savings' in context:
        context_parts.append(f"Monthly Savings: {context['monthly_savings']}")
    
    if 'spending_by_category' in context:
        categories = context['spending_by_category']
        category_str = ", ".join([f"{k}: {v}" for k, v in categories.items()])
        context_parts.append(f"Spending by Category: {category_str}")
    
    context_text = "\n".join(context_parts)
    
    return f"""You are FinAI, a helpful personal finance assistant.

FINANCIAL CONTEXT:
{context_text}

USER QUESTION:
{user_prompt}

Provide a helpful, personalized response based on the context. Be concise and friendly."""


@app.get("/health")
async def health():
    """Check server health"""
    try:
        # Test Gemini connection
        list(genai.list_models())
        return {
            "status": "healthy",
            "gemini_connected": True
        }
    except Exception as e:
        return {
            "status": "unhealthy",
            "error": str(e)
        }


if __name__ == "__main__":
    import uvicorn
    print("🚀 Starting FinAI Local Server...")
    print("📍 Server will run at: http://localhost:8000")
    print("📱 Flutter app will connect to this server")
    print("⚡ Keep this terminal open during hackathon!")
    print("-" * 50)
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)
