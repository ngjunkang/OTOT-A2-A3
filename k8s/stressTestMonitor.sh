echo "Starting stress test monitor..."

while true; clear; do kubectl describe hpa;sleep 5; done
