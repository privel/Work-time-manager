# SE Toolkit - Restroom Break Tracker & Leaderboard

A Flutter-based mobile application with a PostgreSQL-backed backend and an AI assistant that tracks employees' restroom break time during work hours, calculates its estimated financial cost, stores personal statistics, and displays a global leaderboard in a gamified format.

## 📋 Project Overview

The app addresses the problem of low visibility of time lost during non-productive work breaks. Its key feature is converting this time into clear statistics and estimated financial cost, while maintaining user interest through gamification, rankings, and AI-generated feedback.

### Key Features
- ⏱️ Track restroom break duration during work hours
- 💰 Calculate estimated financial cost based on salary/hourly rate
- 📊 Personal statistics and insights
- 🏆 Global leaderboard with gamification
- 🤖 AI-powered assistant for motivation, engagement, and workplace communication suggestions
- 🔐 Secure user authentication

---

## 🗺️ Development Roadmap

### Version 1.0 - MVP (Minimum Viable Product)
**Goal:** Core functionality for tracking breaks and basic user management

#### Features
- [x] PostgreSQL database setup (Docker)
- [x] Backend API (Python FastAPI)
  - User registration and authentication
  - Basic REST endpoints for break logging
- [ ] Flutter mobile app
  - User registration/login screens
  - Timer to start/stop restroom breaks
  - Basic break history view
- [ ] Database schema
  - Users table
  - Breaks table
  - Basic indexing

#### Tech Stack
- **Frontend:** Flutter 3.x
- **Backend:** Python FastAPI
- **Database:** PostgreSQL 15+
- **Containerization:** Docker & Docker Compose

---

### Version 1.5 - Enhanced Tracking & Statistics
**Goal:** Add financial calculations and personal statistics

#### Features
- [ ] Salary/hourly rate configuration per user
- [ ] Automatic financial cost calculation
- [ ] Personal statistics dashboard
  - Daily/weekly/monthly break time
  - Cost breakdowns
  - Charts and visualizations
- [ ] Break history with filtering and sorting
- [ ] Push notifications for excessive break times

---

### Version 2.0 - Gamification & Leaderboard
**Goal:** Introduce social competition and engagement features

#### Features
- [ ] Global leaderboard
  - Anonymous usernames
  - Weekly/monthly/all-time rankings
  - Top "efficient" users (lowest break time)
- [ ] Achievement system
  - Badges for milestones
  - Streak tracking
- [ ] User profiles with avatars
- [ ] Social sharing (optional)
- [ ] Privacy controls (opt-in/out of leaderboard)

---

### Version 2.5 - AI Assistant Integration
**Goal:** Integrate LLM-based assistant for personalized feedback

#### Features
- [ ] AI assistant integration (OpenAI/GPT or similar)
- [ ] Motivational messages based on user behavior
- [ ] Engagement suggestions to reduce break times
- [ ] Workplace communication tips
- [ ] Personalized daily summaries
- [ ] Context-aware notifications

---

### Version 3.0 - Advanced Features & Polish
**Goal:** Production-ready application with advanced analytics

#### Features
- [ ] Advanced analytics
  - Trend analysis
  - Predictive insights
  - Comparison with team/department averages
- [ ] Manager dashboard (optional, opt-in)
- [ ] Team/department leaderboards
- [ ] Export functionality (CSV, PDF reports)
- [ ] Offline mode with sync
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Accessibility improvements

---

### Version 3.5 - Enterprise Features
**Goal:** Support for organizational deployment

#### Features
- [ ] SSO/SAML integration
- [ ] Role-based access control
- [ ] Compliance and audit logging
- [ ] Bulk user import/export
- [ ] Customizable policies and thresholds
- [ ] API rate limiting and monitoring
- [ ] Advanced security features (2FA, biometric login)

---

### Version 4.0 - AI-Powered Insights & Automation
**Goal:** Leverage AI for deeper insights and automation

#### Features
- [ ] AI-generated weekly/monthly reports
- [ ] Behavioral pattern recognition
- [ ] Smart suggestions for schedule optimization
- [ ] Integration with calendar apps
- [ ] Wellness tips based on usage patterns
- [ ] Conversational AI interface for quick logging
- [ ] Voice command support

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x
- Python 3.10+
- Docker & Docker Compose
- PostgreSQL 15+ (or use Docker)

### Running the Backend

```bash
cd backend
docker-compose up -d
pip install -r requirements.txt
uvicorn main:app --reload
```

### Running the Flutter App

```bash
cd frontend  # (to be created)
flutter pub get
flutter run
```

---

## 📁 Project Structure

```
se-toolkit-lab-9/
├── backend/
│   ├── main.py                 # FastAPI application
│   ├── requirements.txt        # Python dependencies
│   ├── pyproject.toml          # Project configuration
│   └── Dockerfile              # Backend container
├── frontend/                   # (to be created)
│   └── Flutter application
├── docker-compose.yml          # Services orchestration
├── .env.example                # Environment variables template
└── README.md                   # This file
```

---

## 📊 Database Schema (Planned)

### Users Table
- id (UUID, PK)
- username (VARCHAR)
- email (VARCHAR, UNIQUE)
- password_hash (VARCHAR)
- hourly_rate (DECIMAL)
- created_at (TIMESTAMP)
- settings (JSONB)

### Breaks Table
- id (UUID, PK)
- user_id (UUID, FK -> Users)
- start_time (TIMESTAMP)
- end_time (TIMESTAMP)
- duration (INTERVAL)
- cost (DECIMAL)
- created_at (TIMESTAMP)

### Leaderboard Table
- id (UUID, PK)
- user_id (UUID, FK -> Users)
- period (VARCHAR)  # weekly, monthly, all-time
- total_duration (INTERVAL)
- total_cost (DECIMAL)
- rank (INTEGER)
- updated_at (TIMESTAMP)

---

## 🔒 Privacy & Ethics

This application is designed with user privacy and consent in mind:
- All data is opt-in
- Users can choose to remain anonymous on leaderboards
- No data is shared without explicit consent
- Users can delete their accounts and all associated data
- Compliance with GDPR and local data protection regulations

---

## 📝 License

[To be determined]

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📧 Contact

[Your contact information]
