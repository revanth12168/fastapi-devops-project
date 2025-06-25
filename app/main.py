from fastapi import FastAPI
from app.routers import health

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "FastAPI DevOps Project"}

app.include_router(health.router)

