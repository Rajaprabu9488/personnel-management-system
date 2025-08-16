from fastapi import FastAPI, Request
import uvicorn
import decision_maker as dm
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],

)

class input_data(BaseModel):
    user:str
    passwd:str

class threat_details(BaseModel):
    threat_type: str
    severity: int
    location:str
    civilian_count:int
    military_asset:int

@app.post("/add-threat")
async def add_threat(request: threat_details):
    data = request
    print(data)
    print("Received threat data:", data)
    person=dm.assign_person(data)
    return person

@app.post("/login")
async def login(data: input_data):
    data_in ={"username":data.user,"password":data.passwd}
    print("Received threat data:", data_in)
    check_res=dm.login_in(data_in)
    return {"check":check_res}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
