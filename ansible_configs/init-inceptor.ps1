cd C:\temp\inceptor
python3.10.exe -m venv venv
pip install -r requirements.txt
cd inceptor
cat inceptor-config.txt | python .\update-config.py
