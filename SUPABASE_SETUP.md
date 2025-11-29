# Supabase Integration Setup Guide

## Prerequisites
1. Create a Supabase project at https://supabase.com
2. Get your project URL and anon key from Settings > API

## Configuration Steps

### 1. Update Supabase Credentials
Edit `lib/config/supabase_config.dart` and replace:
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 2. Install Dependencies
Run:
```bash
flutter pub get
```

### 3. Configure Deep Links for OAuth

#### Android Configuration
Add to `android/app/src/main/AndroidManifest.xml` inside the `<activity>` tag:
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="io.supabase.finai"
        android:host="login-callback" />
</intent-filter>
```

#### iOS Configuration
Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>io.supabase.finai</string>
        </array>
    </dict>
</array>
```

### 4. Configure OAuth Providers in Supabase

#### Google OAuth
1. Go to your Supabase project > Authentication > Providers
2. Enable Google provider
3. Add your OAuth credentials from Google Cloud Console
4. Add redirect URL: `io.supabase.finai://login-callback/`

#### Apple OAuth
1. Enable Apple provider in Supabase
2. Configure Apple Developer account
3. Add redirect URL: `io.supabase.finai://login-callback/`

### 5. Database Setup (Optional)
Create a `profiles` table to store user data:
```sql
create table profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  avatar_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
alter table profiles enable row level security;

-- Create policies
create policy "Users can view own profile"
  on profiles for select
  using ( auth.uid() = id );

create policy "Users can update own profile"
  on profiles for update
  using ( auth.uid() = id );
```

### 6. Test Authentication
1. Run the app: `flutter run`
2. Try signing up with email/password
3. Check your email for verification
4. Try signing in with Google OAuth

## Features Implemented
✅ Email/Password authentication
✅ Google OAuth sign in
✅ Apple OAuth sign in
✅ Password reset functionality
✅ Email verification
✅ Auto-navigation on successful login
✅ Error handling with user feedback

## Troubleshooting
- **Email not sending**: Check Supabase email settings
- **OAuth not working**: Verify deep link configuration
- **Connection error**: Check your Supabase URL and keys
