from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional


class UserRegister(BaseModel):
    email: EmailStr
    username: str
    password: str
    job_title: Optional[str] = None
    salary_amount: Optional[float] = None
    salary_period: str = "month"  # "month" или "year"
    hours_per_week: Optional[float] = None


class UserProfileCreate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    age: Optional[int] = None
    bio: Optional[str] = None


class UserResponse(BaseModel):
    id: int
    email: str
    username: str
    job_title: Optional[str] = None
    salary_amount: Optional[float] = None
    salary_period: str = "month"
    hours_per_week: Optional[float] = None
    created_at: datetime

    class Config:
        from_attributes = True


class UserProfileResponse(BaseModel):
    id: int
    user_id: int
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    age: Optional[int] = None
    bio: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ToiletVisitCreate(BaseModel):
    duration_minutes: Optional[float] = None  # Если указано — создаётся завершённое посещение


class ToiletVisitResponse(BaseModel):
    id: int
    user_id: int
    started_at: datetime
    ended_at: Optional[datetime] = None
    duration_minutes: Optional[float] = None

    class Config:
        from_attributes = True


class CostEstimate(BaseModel):
    user_id: int
    username: str
    total_visits: int
    total_time_minutes: float
    hourly_rate: float
    total_cost: float


class LeaderboardEntry(BaseModel):
    user_id: int
    username: str
    job_title: Optional[str] = None
    total_visits: int
    total_time_minutes: float
    total_cost_to_company: float
    rank_position: int

    class Config:
        from_attributes = True
