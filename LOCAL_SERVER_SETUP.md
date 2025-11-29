# 🚀 Local FastAPI Server Setup Guide

## Step 1: Install Python Dependencies

Open a new PowerShell terminal and run:

```powershell
pip install fastapi uvicorn google-generativeai pydantic
```

Or if using pip3:
```powershell
pip3 install fastapi uvicorn google-generativeai pydantic
```

## Step 2: Configure Gemini API Key

Open `local_server.py` and add your Gemini API key on line 23:

```python
GEMINI_API_KEY = "YOUR_ACTUAL_API_KEY_HERE"  # ← Replace this
```

## Step 3: Start the Local Server

In PowerShell:

```powershell
cd "C:\NEW\PROGRAMMING\Mumhacks'25\finai"
python local_server.py
```

Or:
```powershell
python3 local_server.py
```

You should see:
```
🚀 Starting FinAI Local Server...
📍 Server will run at: http://localhost:8000
📱 Flutter app will connect to this server
⚡ Keep this terminal open during hackathon!
--------------------------------------------------
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
```

## Step 4: Test the Server

Open browser and go to:
- http://localhost:8000 - Should show "status: online"
- http://localhost:8000/health - Check if Gemini is connected

Or test with PowerShell:
```powershell
Invoke-WebRequest -Uri http://localhost:8000 -Method GET
```

## Step 5: Run Your Flutter App

In a NEW PowerShell terminal:

```powershell
cd "C:\NEW\PROGRAMMING\Mumhacks'25\finai"
flutter run
```

The app will now connect to your local server at http://localhost:8000

## ✅ What's Changed

1. **Flutter app** now points to `http://localhost:8000` (already updated)
2. **Local server** runs on your machine
3. **No Render dependency** - works offline with just internet for Gemini API

## 🔧 Important Notes

### For Android Device/Emulator:
If testing on Android device or emulator, use your PC's IP address instead:

1. Find your PC's IP:
```powershell
ipconfig
# Look for IPv4 Address (e.g., 192.168.1.5)
```

2. Update `lib/config/api_config.dart`:
```dart
static const String baseUrl = 'http://192.168.1.5:8000';  // Use your IP
```

### For iOS Simulator:
Use `http://localhost:8000` - it works fine

### For Chrome/Edge (Web):
Use `http://localhost:8000` - works fine

## 📱 Testing Checklist

- [ ] Install Python packages (fastapi, uvicorn, google-generativeai)
- [ ] Add Gemini API key in local_server.py
- [ ] Start local server (python local_server.py)
- [ ] See "Application startup complete" message
- [ ] Test http://localhost:8000 in browser
- [ ] Run Flutter app (flutter run)
- [ ] Go to AI Assistant tab
- [ ] Send a message
- [ ] See AI response!

## 🆘 Troubleshooting

### Port 8000 already in use?
Change port in local_server.py (line 138):
```python
uvicorn.run(app, host="0.0.0.0", port=8001, reload=True)
```

And update Flutter config:
```dart
static const String baseUrl = 'http://localhost:8001';
```

### "Module not found" error?
Install missing package:
```powershell
pip install <package-name>
```

### Server logs show errors?
Check if Gemini API key is correct in local_server.py

### Flutter can't connect?
- Make sure server is running
- Check if using correct IP for Android device
- Disable any firewall temporarily

## 💡 During Hackathon

1. **Keep the server terminal open** - don't close it!
2. **If server crashes** - just restart with `python local_server.py`
3. **Server logs** show each request in real-time
4. **Hot reload works** - server auto-reloads on code changes

## 🎯 You're All Set!

Your setup:
- ✅ Local FastAPI server on port 8000
- ✅ Flutter app connects to localhost
- ✅ Gemini API integrated
- ✅ No dependency on Render
- ✅ Fast responses (local network)

Keep your system on during hackathon and you're good to go! 🔥
