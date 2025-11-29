-- ============================================
-- FinAI App - Supabase Database Schema
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. USER PROFILES TABLE
-- ============================================
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    avatar_url TEXT,
    phone TEXT,
    currency TEXT DEFAULT 'USD',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
CREATE POLICY "Users can view own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- ============================================
-- 2. TRANSACTIONS TABLE
-- ============================================
CREATE TABLE public.transactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    category TEXT NOT NULL,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    date TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    description TEXT,
    payment_method TEXT,
    is_recurring BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

-- Indexes for better query performance
CREATE INDEX idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX idx_transactions_date ON public.transactions(date DESC);
CREATE INDEX idx_transactions_category ON public.transactions(category);
CREATE INDEX idx_transactions_type ON public.transactions(transaction_type);

-- Enable Row Level Security
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Policies for transactions
CREATE POLICY "Users can view own transactions"
    ON public.transactions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own transactions"
    ON public.transactions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own transactions"
    ON public.transactions FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own transactions"
    ON public.transactions FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 3. BUDGETS TABLE
-- ============================================
CREATE TABLE public.budgets (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    category TEXT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    period TEXT NOT NULL CHECK (period IN ('weekly', 'monthly', 'yearly')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    UNIQUE(user_id, category, period, start_date)
);

-- Indexes
CREATE INDEX idx_budgets_user_id ON public.budgets(user_id);
CREATE INDEX idx_budgets_period ON public.budgets(period);

-- Enable Row Level Security
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

-- Policies for budgets
CREATE POLICY "Users can view own budgets"
    ON public.budgets FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own budgets"
    ON public.budgets FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own budgets"
    ON public.budgets FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own budgets"
    ON public.budgets FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 4. FINANCIAL GOALS TABLE
-- ============================================
CREATE TABLE public.financial_goals (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    target_amount DECIMAL(12, 2) NOT NULL,
    current_amount DECIMAL(12, 2) DEFAULT 0,
    deadline DATE,
    category TEXT NOT NULL,
    priority TEXT CHECK (priority IN ('low', 'medium', 'high')),
    status TEXT DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed', 'paused')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

-- Indexes
CREATE INDEX idx_goals_user_id ON public.financial_goals(user_id);
CREATE INDEX idx_goals_status ON public.financial_goals(status);

-- Enable Row Level Security
ALTER TABLE public.financial_goals ENABLE ROW LEVEL SECURITY;

-- Policies for financial goals
CREATE POLICY "Users can view own goals"
    ON public.financial_goals FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own goals"
    ON public.financial_goals FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own goals"
    ON public.financial_goals FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own goals"
    ON public.financial_goals FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 5. NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE public.notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('anomaly', 'high_risk', 'budget_alert', 'goal_milestone', 'general')),
    is_read BOOLEAN DEFAULT FALSE,
    related_transaction_id UUID REFERENCES public.transactions(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

-- Indexes
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX idx_notifications_created_at ON public.notifications(created_at DESC);

-- Enable Row Level Security
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Policies for notifications
CREATE POLICY "Users can view own notifications"
    ON public.notifications FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own notifications"
    ON public.notifications FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications"
    ON public.notifications FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own notifications"
    ON public.notifications FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 6. AI CHAT HISTORY TABLE
-- ============================================
CREATE TABLE public.chat_messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    message TEXT NOT NULL,
    is_user_message BOOLEAN NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

-- Indexes
CREATE INDEX idx_chat_messages_user_id ON public.chat_messages(user_id);
CREATE INDEX idx_chat_messages_created_at ON public.chat_messages(created_at DESC);

-- Enable Row Level Security
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

-- Policies for chat messages
CREATE POLICY "Users can view own chat messages"
    ON public.chat_messages FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own chat messages"
    ON public.chat_messages FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own chat messages"
    ON public.chat_messages FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 7. RECURRING TRANSACTIONS TABLE
-- ============================================
CREATE TABLE public.recurring_transactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    category TEXT NOT NULL,
    transaction_type TEXT NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    frequency TEXT NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly', 'yearly')),
    next_occurrence DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL
);

-- Indexes
CREATE INDEX idx_recurring_transactions_user_id ON public.recurring_transactions(user_id);
CREATE INDEX idx_recurring_transactions_next_occurrence ON public.recurring_transactions(next_occurrence);

-- Enable Row Level Security
ALTER TABLE public.recurring_transactions ENABLE ROW LEVEL SECURITY;

-- Policies for recurring transactions
CREATE POLICY "Users can view own recurring transactions"
    ON public.recurring_transactions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own recurring transactions"
    ON public.recurring_transactions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own recurring transactions"
    ON public.recurring_transactions FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own recurring transactions"
    ON public.recurring_transactions FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 8. FUNCTIONS AND TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::TEXT, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON public.transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON public.budgets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_goals_updated_at BEFORE UPDATE ON public.financial_goals
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_recurring_updated_at BEFORE UPDATE ON public.recurring_transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, email)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'User'),
        NEW.email
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile automatically
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- 9. SAMPLE DATA (Optional - for testing)
-- ============================================

-- Insert sample transaction categories
CREATE TABLE public.transaction_categories (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    icon TEXT,
    color TEXT,
    type TEXT CHECK (type IN ('income', 'expense', 'both'))
);

INSERT INTO public.transaction_categories (name, type) VALUES
    ('Salary', 'income'),
    ('Freelance', 'income'),
    ('Investment', 'income'),
    ('Groceries', 'expense'),
    ('Transport', 'expense'),
    ('Entertainment', 'expense'),
    ('Healthcare', 'expense'),
    ('Shopping', 'expense'),
    ('Bills', 'expense'),
    ('Education', 'expense'),
    ('Dining', 'expense'),
    ('Travel', 'expense');

-- Make categories table public for all authenticated users
ALTER TABLE public.transaction_categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view categories"
    ON public.transaction_categories FOR SELECT
    TO authenticated
    USING (true);

-- ============================================
-- 10. VIEWS FOR ANALYTICS
-- ============================================

-- View for monthly spending summary
CREATE OR REPLACE VIEW public.monthly_spending_summary AS
SELECT 
    user_id,
    DATE_TRUNC('month', date) AS month,
    category,
    SUM(amount) AS total_amount,
    COUNT(*) AS transaction_count
FROM public.transactions
WHERE transaction_type = 'expense'
GROUP BY user_id, DATE_TRUNC('month', date), category;

-- View for financial health score calculation
CREATE OR REPLACE VIEW public.financial_health_metrics AS
SELECT 
    user_id,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) AS total_expenses,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE -amount END) AS net_balance,
    COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) AS expense_count,
    AVG(CASE WHEN transaction_type = 'expense' THEN amount END) AS avg_expense
FROM public.transactions
WHERE date >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY user_id;

-- ============================================
-- SETUP COMPLETE
-- ============================================
-- Run this SQL in your Supabase SQL Editor
-- Then configure your Flutter app with the credentials
-- ============================================
