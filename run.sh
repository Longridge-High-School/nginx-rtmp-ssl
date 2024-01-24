echo "Running build..."

/run/build.sh

echo "Starting server..."
/opt/nginx/sbin/nginx -g "daemon off;"