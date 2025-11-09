from pydantic import BaseModel, Field, field_validator
from typing import Optional

class User(BaseModel):
    id: int
    email: Optional[str] = None
    first_name: str
    last_name: str
    avatar: Optional[str] = None
    
    @field_validator('email')
    @classmethod
    def normalize_email(cls,v):
        if v:
            return v.strip().lower()
        return v

    @field_validator('first_name', 'last_name', mode='before')
    @classmethod
    def capitalize_names(cls,v):
        return v.strip().title()