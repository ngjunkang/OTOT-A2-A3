echo "Starting stress test..."

curl "localhost/?[0-4999]" --parallel -- parallel-max 100 --no-progress-meter > /dev/null
