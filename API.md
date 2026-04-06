# Toilet Tracker API Documentation

## Setup

```bash
docker compose up --build -d
```

## Endpoints

### User

#### Register
```
POST http://localhost:8000/register
Content-Type: application/json

{
  "email": "test@test.com",
  "username": "ivan",
  "password": "123456",
  "job_title": "Developer",
  "salary_amount": 150000,
  "salary_period": "month",
  "hours_per_week": 40
}
```

**Required fields:** `email`, `username`, `password`  
**Optional fields:** `job_title`, `salary_amount`, `salary_period` (`"month"` or `"year"`), `hours_per_week`

#### Login
```
POST http://localhost:8000/login?email=test@test.com&password=123456
```

#### Get User
```
GET http://localhost:8000/users/1
```

#### Update User
```
PUT http://localhost:8000/users/1
Content-Type: application/json

{
  "email": "new@test.com",
  "username": "newname",
  "password": "newpass",
  "job_title": "Senior",
  "salary_amount": 200000,
  "salary_period": "year",
  "hours_per_week": 35
}
```

---

### User Profile

#### Create Profile
```
POST http://localhost:8000/users/1/profile
Content-Type: application/json

{
  "first_name": "Ivan",
  "last_name": "Ivanov",
  "age": 25,
  "bio": "Coffee lover"
}
```

#### Get Profile
```
GET http://localhost:8000/users/1/profile
```

#### Update Profile
```
PUT http://localhost:8000/users/1/profile
Content-Type: application/json

{
  "first_name": "Petr"
}
```

---

### Toilet Visits

#### Start Visit (Timer)
```
POST http://localhost:8000/users/1/visits
```
Returns visit `id`. Must be ended separately via the end endpoint.

#### End Visit
```
POST http://localhost:8000/users/1/visits/1/end
```
Duration is calculated automatically: `ended_at - started_at`.

#### Manual Visit Entry (Specify Duration)
```
POST http://localhost:8000/users/1/visits/manual
Content-Type: application/json

{
  "duration_minutes": 123
}
```
Creates a visit with the specified duration. `123` = 2 hours 3 minutes.

#### Visit History
```
GET http://localhost:8000/users/1/visits
```

---

### Company Cost Estimation

#### Get Cost Estimate
```
GET http://localhost:8000/users/1/cost
```

**Response:**
```json
{
  "user_id": 1,
  "username": "ivan",
  "total_visits": 5,
  "total_time_minutes": 45.5,
  "hourly_rate": 866.38,
  "total_cost": 656.7
}
```

**Calculation Formula:**
```
hourly_rate = (salary_amount / 12) / (hours_per_week * 4.33)   # if salary_period = "year"
hourly_rate = salary_amount / (hours_per_week * 4.33)          # if salary_period = "month"
cost = (total_time_minutes / 60) * hourly_rate
```

---

### Leaderboard

#### Top by Company Cost
```
GET http://localhost:8000/leaderboard?limit=10
```

#### Top by Time Spent
```
GET http://localhost:8000/leaderboard/time?limit=10
```

**Response:**
```json
[
  {
    "user_id": 2,
    "username": "bob",
    "job_title": "Manager",
    "total_visits": 3,
    "total_time_minutes": 85.0,
    "total_cost_to_company": 2450.5,
    "rank_position": 1
  }
]
```

Leaderboard updates automatically after each visit is completed.

---

## pgAdmin

- URL: `http://localhost:5050`
- Email: `admin@example.com`
- Password: `admin`

**Database Connection:**
- Host: `db`
- Port: `5432`
- Database: `toilet_tracker`
- Username: `postgres`
- Password: `postgres`
