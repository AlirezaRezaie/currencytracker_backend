source /home/aryasweb/virtualenv/currency_tracker/3.11/bin/activate && cd /home/aryasweb/currency_tracker

# Check if a process named "uvicorn" is running
if ! pgrep -f "uvicorn" > /dev/null; then
    echo "No uvicorn currenctly running Creating a new uvicorn process"
    # Run uvicorn with your desired parameters
    nohup uvicorn server:app --host 0.0.0.0 --port 5000 &
fi


