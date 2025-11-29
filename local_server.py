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
GEMINI_API_KEY = "AIzaSyDGxP2al9gkytl2YNy0yl4Rl2su8NE3BH0"  # ← Replace with your actual key
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
        # Use Gemini 2.0 Flash - FASTEST model available!
        model = genai.GenerativeModel('models/gemini-2.0-flash')
        
        # Configure for FAST responses
        generation_config = {
            'temperature': 0.8,
            'top_p': 0.9,
            'top_k': 32,
            'max_output_tokens': 120,  # Short and fast
        }
        
        # Build short prompt
        full_prompt = _build_prompt(request.prompt, request.context)
        
        print(f"📝 Prompt: {request.prompt[:50]}...")
        response = model.generate_content(full_prompt, generation_config=generation_config)
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
    """Build strict finance-only prompt"""
    
    # Build minimal context for speed
    context_str = ""
    if context:
        if 'financial_health_score' in context:
            context_str += f"Financial Health Score: {context['financial_health_score']}/100. "
        if 'monthly_spending' in context:
            context_str += f"Monthly Spending: ${context['monthly_spending']}. "
        if 'monthly_savings' in context:
            context_str += f"Monthly Savings: ${context['monthly_savings']}. "
    
    return f"""You are FinAI, a personal finance advisor AI assistant. Your role is STRICTLY LIMITED to:
- Personal finance advice (budgeting, saving, investing)
- Spending analysis and recommendations
- Financial health insights
- Money management tips
- Budget planning

STRICT RULES:
1. ONLY answer questions related to personal finance, money, budgeting, savings, investments, or spending
2. If the question is NOT about finance (e.g., general knowledge, jokes, recipes, sports, etc.), respond EXACTLY with: "I'm FinAI, your personal finance assistant. I can only help with finance-related questions. Please ask me about budgeting, saving, spending, or investments."
3. Do NOT provide information on non-finance topics under any circumstances
4. Keep responses under 3 sentences
5. Be helpful and friendly for finance questions only

User's Financial Context: {context_str if context_str else "No financial data provided."}

User Question: {user_prompt}

Your Response:"""


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
    uvicorn.run(app, host="0.0.0.0", port=8000)
