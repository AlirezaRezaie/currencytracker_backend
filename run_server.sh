git pull

# Check if a process named "uvicorn" is running
if pgrep -f "uvicorn" > /dev/null; then
    echo "Killing the existing uvicorn process"
    pkill -f "uvicorn"
fi

echo "Creating a new uvicorn process"

# Run uvicorn with your desired parameters
nohup uvicorn server:app --host 0.0.0.0 --port 5000 &