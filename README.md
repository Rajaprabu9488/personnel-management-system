# personnel-management-system
A standalone application designed to **analyze and manage critical threat scenarios** such as **military operations, hijacks, bomb threats, terrorist attacks, and cyber incidents**. The system uses **Machine Learning** for threat assessment and recommends the **optimal personnel allocation** based on soldier skills and threat severity.

---

## 🚀 Features
- Detects and categorizes **various threat types** (Hijack, Bomb Threat, Cyber Attack, etc.).
- Predicts **number of personnel required** using a trained ML model.
- Assigns suitable soldiers from the database based on:
  - **Specialized skills** (Sniper, Recon, Cyber Ops, Bomb Disposal, etc.)
  - **Operational grade** (A, B, C)
- Integrated with **Python backend** and **Flutter frontend**.
- **MySQL** database for soldier details and assignments.
- Secure and **standalone application** (not web-based).

---

## 🛠 Tech Stack
- **Python 3.10.8** (Backend & ML Model)
- **Flutter** (Frontend UI)
- **MySQL** (Database)
- **Libraries & Tools**:
  - `scikit-learn` – for predictive modeling
  - `joblib` – for model persistence
  - `pandas`, `numpy` – data handling
  - `FastAPI`- for communication between Flutter & backend

---

## 🔍 How It Works
1. **Threat Input** (via Flutter UI):
   - User selects threat type (Hijack, Bomb Threat, Cyber Attack, etc.).
   - Inputs severity and additional details.
2. **Prediction**:
   - Backend loads ML model (`joblib`) to predict **required personnel count**.
3. **Soldier Assignment**:
   - System queries MySQL for available soldiers.
   - Filters soldiers by **skill mapping** and **operational grade**.
4. **Result Display**:
   - Flutter UI displays assigned soldiers in a **DataTable** with details.

---

## 🧠 Machine Learning Model
- Model predicts **number of personnel required** for a given threat.
- Algorithm: **Supervised learning** using `scikit-learn` (e.g., XGBoostRegression).
- Trained on **historical threat data** and **skill mapping**.

---

## ▶️ Installation & Usage
### **1. Clone the repository:**
```bash
git clone https://github.com/Rajaprabu9488/personnel-management-system.git
cd personnel-management-system
---

## 📈 Future Enhancements
   - Add real-time notification system.
   - Integrate NLP-based threat report analysis.
   - Add geo-location tracking for soldier deployment.
   - Deploy backend on Docker for portability.
