import google.generativeai as genai

# Your API key
GEMINI_API_KEY = "AIzaSyCNU4sg8KPFsUvvPAo7DQl7Zd2TPdLd0hI"
genai.configure(api_key=GEMINI_API_KEY)

print("🔍 Checking available models...\n")

try:
    for m in genai.list_models():
        if 'generateContent' in m.supported_generation_methods:
            print(f"✅ {m.name}")
            print(f"   Display: {m.display_name}")
            print(f"   Methods: {m.supported_generation_methods}")
            print()
except Exception as e:
    print(f"❌ Error: {e}")
