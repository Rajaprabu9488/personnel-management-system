import joblib
import pandas as pd
import numpy as np
import mysql.connector as db_connect

my_sql=db_connect.connect(
    host="localhost",
    user="root",
    password="raja@05",
    database="officers"
)

skill_mapping = {
    "Hijack": ["Tactics","Strategy","Intelligence", "Negotiation", "Combat",'Bomb Disposal','Surveillance', "Sniper",'Weapons'],
    "Terrorist Attack": ["Sniper", "Combat", 'Bomb Disposal', "Tactics","Strategy",'Weapons'],
    "Cyber Attack": ["Cyber", "Intelligence"],
    "Bomb Threat": ['Bomb Disposal', "Engineering", 'Surveillance','Weapons',"Combat"],
    "Military Invasion": ["Combat", "Tactics", 'Surveillance', "Recon"],
    'Natural Disaster':['Medical', 'Surveillance',"Combat"],
    'Riots':["Tactics","Strategy","Intelligence",'Surveillance','Weapons'],
}

all_skills=["Bomb Disposal","Engineering",'Surveillance',"Combat",'Weapons',"Intelligence","Cyber",'Medical',
            "Tactics","Strategy","Recon","Negotiation","Sniper"]

cursor=my_sql.cursor()

def login_in(data):
    cursor.execute("select user_name,pass_word from login_credential where user_name=%s and pass_word=%s",[data["username"],data["password"]])
    if(cursor.fetchone()):
        return 1
    else:
        return 0


def assign_person(data):
    model=joblib.load('C:\\Users\\RAJPRABU\\Desktop\\vscode\\thread_management\\thread_model.pkl')

    new_data = pd.DataFrame([{
    'Threat_Type': data.threat_type,
    'Severity': data.severity,
    'Location_Type':data.location,
    'Civilian_Count': data.civilian_count,
    'Military_Assets': data.military_asset
    }])
    pred=model.predict(new_data)
    pred=np.round(pred.reshape(-1)).astype(int)
    pred[pred<0]=0
    type=data.threat_type
    if(data.severity<=2):
        grade='C'
    elif(data.severity<=4):
        grade='B'
    else:
        grade='A'
    details={}
    for i,j in zip(all_skills,pred):
        if(j!=0):
            details[i]=int(j)
    total=0
    office_id=[]
    office_name=[]
    batch=[]
    officer_skills=[]
    for i,j in details.items():
        cursor.execute('select * from army_specialist where Skills LIKE %s and Status=%s and Grade=%s limit %s',[f'%{i}%',"Active",grade,int(j)])
        lis=cursor.fetchall()
        for val in lis:
            if val[0] not in office_id:
                office_id.append(val[0])
                office_name.append(val[1])
                batch.append(val[2])
                officer_skills.append(i)
                print(val)
                
    details["total"]=int(len(office_id))
    details["officer_id"]=office_id
    details["officer_name"]=office_name
    details["batch"]=batch
    details["officer_skills"]=officer_skills
    return details

if __name__=="__main__":
    e={
    'threat_type': 'Hijack',
    'severity': 1,
    'location':"Airport",
    'civilian_count': 1500,
    'military_assets': 10
    }
    h=assign_person(e)
    print(h)


#     max_personnel_by_threat = {
#     "Cyber Attack": 30,
#     "Hijack": 100,
#     "Terrorist Attack": 300,
#     "Bomb Threat": 50,
#     "Military Operation": 500,
# }
