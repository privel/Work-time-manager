# Toilet Tracker

A mobile application for tracking restroom break time with financial cost estimation and a gamified leaderboard.

## 📸 Demo

> **Add screenshots:**
> - Registration/login screen
> - Break timer and visit history
> - Personal statistics and financial report
> - Global leaderboard

## 👥 End Users

- **Employees** who want to track their breaks and see how much work time (and money) they spend.
- **Managers/HR** (optional), interested in overall team work-time loss analytics.

## ❌ Problem

Unproductive breaks eat into work time invisibly. Employees don't realize how many minutes per day go to distractions, and employers don't see the real financial impact of these losses.

## ✅ Solution

Toilet Tracker automatically logs the duration of each break, converts it into a monetary equivalent based on the user's salary, and presents the results in a clear format — personal charts, leaderboards, and summaries. Gamification motivates users to reduce unnecessary absences.

---

## 🧩 Features

### Version 1 — Backend & API
- ✅ PostgreSQL database setup (Docker)
- ✅ FastAPI backend with REST endpoints
- ✅ User registration and authentication
- ✅ User profile management
- ✅ Break timer (start/stop) and manual duration entry
- ✅ Financial cost calculation based on salary
- ✅ Visit history with filtering
- ✅ Global leaderboard (by cost and by time)
- ✅ Docker Compose orchestration (PostgreSQL + pgAdmin + Backend)

### Version 2 — Flutter Mobile App
- ✅ Flutter mobile client
- ✅ Registration and login screens
- ✅ Break timer UI with start/stop controls
- ✅ Manual visit entry with custom duration
- ✅ Personal cost dashboard
- ✅ Leaderboard view
- ✅ Calendar-based visit history

### Not Yet Implemented
- ⬜ Personal statistics with advanced charts (daily/weekly/monthly)
- ⬜ Achievement and badge system
- ⬜ Push notifications for exceeding limits
- ⬜ Report export (CSV, PDF)
- ⬜ Dark theme and multi-language support
- ⬜ Team/department leaderboards
- ⬜ Manager dashboard for supervisors

---

## 📖 Usage

### Version 1 — Backend & API

See [API.md](API.md) for full endpoint documentation.

**Quick start:**
```bash
docker compose up --build -d
```

Register a user and interact with the API via `curl` or any HTTP client on `http://localhost:8000`.

### Version 2 — Flutter Mobile App

1. **Register** — provide email, username, password, and salary details (for cost calculation).
2. **Log a break** — press "Start" when entering and "Stop" when leaving, or enter duration manually.
3. **View cost** — the "Cost" screen shows total time and its financial equivalent.
4. **Compete** — open the leaderboard and compare your rank with colleagues.

---

## 🚀 Deployment

### Target OS

- **Ubuntu 24.04 LTS** (recommended, same as university VMs)
- Windows/macOS also supported for local development

### Prerequisites

| Component | Version | Used in |
|-----------|---------|---------|
| Docker    | 24+     | Version 1 (Backend) |
| Docker Compose | 2.20+ | Version 1 (Backend) |
| Git       | any     | Both |
| Flutter SDK | 3.x   | Version 2 (Flutter App) |
| Android Studio / Xcode | latest | Version 2 (Flutter App) |

### Step-by-Step Deployment

#### Version 1 — Backend & API

**1. Clone the repository**

```bash
git clone https://github.com/<your-username>/se-toolkit-lab-9.git
cd se-toolkit-lab-9
```

**2. Configure environment variables**

```bash
cp .env.example .env
nano .env
```

Fill in the values:

```env
DATABASE_URL=postgresql://postgres:postgres@db:5432/toilet_tracker
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=toilet_tracker
```

> `OPENAI_API_KEY` and `SECRET_KEY` can be left empty — they are not required for basic functionality.

**3. Start services with Docker Compose**

```bash
docker compose up --build -d
```

This will start three containers:
- **PostgreSQL** — port `5432`
- **pgAdmin** — port `5050` (login: `admin@example.com`, password: `admin`)
- **Backend (FastAPI)** — port `8000`

**4. Verify the backend**

```bash
curl http://localhost:8000/
# Expected response: {"message":"Backend is running"}
```

**5. (Optional) Access pgAdmin**

Open `http://<vm-ip>:5050` and connect to the database:

| Parameter | Value          |
|-----------|----------------|
| Host      | db             |
| Port      | 5432           |
| Database  | toilet_tracker  |
| Username  | postgres       |
| Password  | postgres       |

---

#### Version 2 — Flutter Mobile App

**1. Prerequisites**

Make sure you have Flutter SDK installed:

```bash
flutter --version
```

**2. Install dependencies**

```bash
cd mobile_app
flutter pub get
```

**3. Configure the backend URL**

Update the base URL in the app to point to your running backend (default: `http://localhost:8000`).

**4. Run the app**

```bash
flutter run
```

Or run from your IDE (Android Studio / VS Code) on an emulator or physical device.

---

## 📁 Project Structure

```
se-toolkit-lab-9/
├── backend/
│   ├── main.py              # FastAPI application
│   ├── models.py            # SQLAlchemy models
│   ├── schemas.py           # Pydantic schemas
│   ├── database.py          # Database connection
│   ├── Dockerfile           # Backend container
│   ├── requirements.txt     # Python dependencies
│   └── pyproject.toml       # Project configuration
├── mobile_app/
│   └── lib/                 # Flutter application
├── docker-compose.yml       # Service orchestration
├── .env.example             # Environment variables template
├── API.md                   # Full API documentation
└── README.md
```

---

## 🔒 Privacy & Ethics

The application is designed with privacy in mind:
- All data is **opt-in** — users decide whether to participate
- Ability to **hide yourself** from the leaderboard
- Account deletion **completely erases** all associated data
- Compliance with **GDPR** and local data protection laws

---
