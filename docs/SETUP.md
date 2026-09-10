# Setup

1. Create the PostgreSQL database using the SQL scripts in `database/README.md`.
2. Copy `backend/.env.example` to `backend/.env` and set `DATABASE_URL` to your PostgreSQL credentials.
3. Start the API:

```powershell
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload --port 5000
```

4. In a second terminal, start the frontend:

```powershell
cd frontend
npm run dev
```

Vite runs on `http://localhost:5173`; FastAPI documentation is at `http://localhost:5000/docs`.
