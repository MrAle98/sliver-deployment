cd C:\temp\inceptor\inceptor
python3.10.exe -m venv venv
.\venv\Scripts\Activate.ps1
pip.exe install -r requirements.txt
cd inceptor
cat inceptor-config.txt | python .\update-config.py
