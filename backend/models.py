from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Float, Boolean
from sqlalchemy.sql import func
from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Профессиональные данные
    job_title = Column(String, nullable=True)  # Кем работает
    salary_amount = Column(Float, nullable=True)  # Сумма зарплаты
    salary_period = Column(String, default="month")  # "month" или "year" — флаг периода зарплаты
    hours_per_week = Column(Float, nullable=True)  # Рабочих часов в неделю


class UserProfile(Base):
    __tablename__ = "user_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    first_name = Column(String, nullable=True)
    last_name = Column(String, nullable=True)
    age = Column(Integer, nullable=True)
    bio = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())


class ToiletVisit(Base):
    __tablename__ = "toilet_visits"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    started_at = Column(DateTime(timezone=True), server_default=func.now())
    ended_at = Column(DateTime(timezone=True), nullable=True)
    duration_minutes = Column(Float, nullable=True)  # Вычисляется после завершения


class Leaderboard(Base):
    __tablename__ = "leaderboard"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    total_visits = Column(Integer, default=0)  # Всего посещений
    total_time_minutes = Column(Float, default=0)  # Общее время в туалете
    total_cost_to_company = Column(Float, default=0)  # Общая стоимость для компании
    rank_position = Column(Integer, nullable=True)  # Позиция в рейтинге
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
