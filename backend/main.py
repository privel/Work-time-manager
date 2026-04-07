from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
import bcrypt
from datetime import datetime

from database import engine, get_db, Base
from models import User, UserProfile, ToiletVisit, Leaderboard
from schemas import (
    UserRegister, UserUpdate, UserProfileCreate, UserResponse, UserProfileResponse,
    ToiletVisitCreate, ToiletVisitResponse, CostEstimate, LeaderboardEntry,
    UserLogin
)

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return bcrypt.checkpw(plain_password.encode("utf-8"), hashed_password.encode("utf-8"))


def calculate_hourly_rate(user: User) -> float:
    """Вычисляет часовую ставку пользователя"""
    if not user.salary_amount or not user.hours_per_week:
        return 0.0

    hours_per_month = user.hours_per_week * 4.33

    if user.salary_period == "year":
        monthly_salary = user.salary_amount / 12
    else:
        monthly_salary = user.salary_amount

    return monthly_salary / hours_per_month


def update_leaderboard(db: Session, user_id: int):
    """Обновляет данные в leaderboard для пользователя"""
    visits = db.query(ToiletVisit).filter(
        ToiletVisit.user_id == user_id,
        ToiletVisit.ended_at.isnot(None)
    ).all()

    total_visits = len(visits)
    total_time = sum(v.duration_minutes for v in visits if v.duration_minutes)

    user = db.query(User).filter(User.id == user_id).first()
    hourly_rate = calculate_hourly_rate(user)

    total_cost = (total_time / 60) * hourly_rate

    leaderboard = db.query(Leaderboard).filter(Leaderboard.user_id == user_id).first()
    if not leaderboard:
        leaderboard = Leaderboard(user_id=user_id)
        db.add(leaderboard)

    leaderboard.total_visits = total_visits
    leaderboard.total_time_minutes = total_time
    leaderboard.total_cost_to_company = total_cost
    db.commit()

    update_all_ranks(db)


def update_all_ranks(db: Session):
    """Пересчитывает ранги в leaderboard"""
    entries = db.query(Leaderboard).order_by(
        Leaderboard.total_cost_to_company.desc()
    ).all()

    for idx, entry in enumerate(entries, 1):
        entry.rank_position = idx

    db.commit()


@app.get("/")
def read_root():
    return {"message": "Backend is running"}


@app.post("/register", response_model=UserResponse)
def register(user_data: UserRegister, db: Session = Depends(get_db)):
    existing_user = db.query(User).filter(
        (User.email == user_data.email) | (User.username == user_data.username)
    ).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email or username already exists")

    new_user = User(
        email=user_data.email,
        username=user_data.username,
        hashed_password=hash_password(user_data.password),
        job_title=user_data.job_title,
        salary_amount=user_data.salary_amount,
        salary_period=user_data.salary_period,
        hours_per_week=user_data.hours_per_week,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    db.add(Leaderboard(user_id=new_user.id))
    db.commit()

    return new_user


@app.post("/login")
def login(login_data: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == login_data.email).first()
    if not user or not verify_password(login_data.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return {"message": "Login successful", "user_id": user.id}


@app.get("/users/{user_id}", response_model=UserResponse)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@app.put("/users/{user_id}", response_model=UserResponse)
def update_user(user_id: int, user_data: UserUpdate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    for field in user_data.model_dump(exclude_unset=True):
        if field == "password":
            setattr(user, "hashed_password", hash_password(getattr(user_data, field)))
        else:
            setattr(user, field, getattr(user_data, field))

    db.commit()
    db.refresh(user)
    return user


@app.post("/users/{user_id}/profile", response_model=UserProfileResponse)
def create_profile(user_id: int, profile_data: UserProfileCreate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    existing_profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
    if existing_profile:
        raise HTTPException(status_code=400, detail="Profile already exists")

    new_profile = UserProfile(
        user_id=user_id,
        first_name=profile_data.first_name,
        last_name=profile_data.last_name,
        age=profile_data.age,
        bio=profile_data.bio,
    )
    db.add(new_profile)
    db.commit()
    db.refresh(new_profile)
    return new_profile


@app.get("/users/{user_id}/profile", response_model=UserProfileResponse)
def get_profile(user_id: int, db: Session = Depends(get_db)):
    profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    return profile


@app.put("/users/{user_id}/profile", response_model=UserProfileResponse)
def update_profile(user_id: int, profile_data: UserProfileCreate, db: Session = Depends(get_db)):
    profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")

    for field in profile_data.model_dump(exclude_unset=True):
        setattr(profile, field, getattr(profile_data, field))

    db.commit()
    db.refresh(profile)
    return profile


# === Toilet Visits ===

@app.post("/users/{user_id}/visits", response_model=ToiletVisitResponse)
def start_visit(user_id: int, visit_data: ToiletVisitCreate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    visit = ToiletVisit(user_id=user_id)
    db.add(visit)
    db.commit()
    db.refresh(visit)
    return visit


@app.post("/users/{user_id}/visits/manual", response_model=ToiletVisitResponse)
def create_manual_visit(user_id: int, visit_data: ToiletVisitCreate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    if visit_data.duration_minutes is None or visit_data.duration_minutes <= 0:
        raise HTTPException(status_code=400, detail="duration_minutes is required and must be > 0")

    now = datetime.now()
    visit = ToiletVisit(
        user_id=user_id,
        started_at=now,
        ended_at=now,
        duration_minutes=visit_data.duration_minutes,
    )
    db.add(visit)
    db.commit()
    db.refresh(visit)

    update_leaderboard(db, user_id)

    return visit


@app.post("/users/{user_id}/visits/{visit_id}/end", response_model=ToiletVisitResponse)
def end_visit(user_id: int, visit_id: int, db: Session = Depends(get_db)):
    visit = db.query(ToiletVisit).filter(
        ToiletVisit.id == visit_id,
        ToiletVisit.user_id == user_id
    ).first()
    if not visit:
        raise HTTPException(status_code=404, detail="Visit not found")
    if visit.ended_at:
        raise HTTPException(status_code=400, detail="Visit already ended")

    visit.ended_at = datetime.now(visit.started_at.tzinfo if visit.started_at.tzinfo else None)
    duration = (visit.ended_at - visit.started_at).total_seconds() / 60
    visit.duration_minutes = round(duration, 2)

    db.commit()
    db.refresh(visit)

    update_leaderboard(db, user_id)

    return visit


@app.get("/users/{user_id}/visits", response_model=list[ToiletVisitResponse])
def get_visits(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    return db.query(ToiletVisit).filter(
        ToiletVisit.user_id == user_id
    ).order_by(ToiletVisit.started_at.desc()).all()


@app.delete("/users/{user_id}/visits/{visit_id}")
def delete_visit(user_id: int, visit_id: int, db: Session = Depends(get_db)):
    visit = db.query(ToiletVisit).filter(
        ToiletVisit.id == visit_id,
        ToiletVisit.user_id == user_id
    ).first()
    if not visit:
        raise HTTPException(status_code=404, detail="Visit not found")

    db.delete(visit)
    db.commit()

    update_leaderboard(db, user_id)

    return {"message": "Visit deleted"}


@app.get("/users/{user_id}/cost", response_model=CostEstimate)
def get_cost_estimate(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    visits = db.query(ToiletVisit).filter(
        ToiletVisit.user_id == user_id,
        ToiletVisit.ended_at.isnot(None)
    ).all()

    total_visits = len(visits)
    total_time = sum(v.duration_minutes for v in visits if v.duration_minutes)

    hourly_rate = calculate_hourly_rate(user)
    total_cost = (total_time / 60) * hourly_rate

    return CostEstimate(
        user_id=user.id,
        username=user.username,
        total_visits=total_visits,
        total_time_minutes=round(total_time, 2),
        hourly_rate=round(hourly_rate, 2),
        total_cost=round(total_cost, 2),
    )


# === Leaderboard ===

@app.get("/leaderboard", response_model=list[LeaderboardEntry])
def get_leaderboard(limit: int = 10, db: Session = Depends(get_db)):
    entries = db.query(Leaderboard).join(User).order_by(
        Leaderboard.total_cost_to_company.desc()
    ).limit(limit).all()

    result = []
    for entry in entries:
        user = db.query(User).filter(User.id == entry.user_id).first()
        result.append(LeaderboardEntry(
            user_id=entry.user_id,
            username=user.username if user else "Unknown",
            job_title=user.job_title if user else None,
            total_visits=entry.total_visits,
            total_time_minutes=round(entry.total_time_minutes, 2),
            total_cost_to_company=round(entry.total_cost_to_company, 2),
            rank_position=entry.rank_position or 0,
        ))

    return result


@app.get("/leaderboard/time", response_model=list[LeaderboardEntry])
def get_leaderboard_by_time(limit: int = 10, db: Session = Depends(get_db)):
    entries = db.query(Leaderboard).join(User).order_by(
        Leaderboard.total_time_minutes.desc()
    ).limit(limit).all()

    result = []
    for idx, entry in enumerate(entries, 1):
        user = db.query(User).filter(User.id == entry.user_id).first()
        result.append(LeaderboardEntry(
            user_id=entry.user_id,
            username=user.username if user else "Unknown",
            job_title=user.job_title if user else None,
            total_visits=entry.total_visits,
            total_time_minutes=round(entry.total_time_minutes, 2),
            total_cost_to_company=round(entry.total_cost_to_company, 2),
            rank_position=idx,
        ))

    return result
