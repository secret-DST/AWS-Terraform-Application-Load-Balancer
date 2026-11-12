#!/bin/bash
set -Ee

# Log output for troubleshooting

exec > >(tee -a /var/log/user-data.log) 2>&1

echo "Starting EC2 user-data script..."

# Update packages and install Apache

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y apache2

# Get the instance hostname directly from Linux

HOSTNAME=$(hostname)

echo "Instance hostname: ${HOSTNAME}"

# Create the custom website

cat > /var/www/html/index.html <<EOF

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>EC2 Demo Website</title>
</head>
<body>
    <h1>Hello from EC2!</h1>
    <h2>Hostname: ${HOSTNAME}</h2>
    <p>Apache is running successfully.</p>
</body>
</html>
EOF

# Enable Apache at startup and restart it

systemctl enable apache2
systemctl restart apache2

echo "Website created successfully for ${HOSTNAME}."
echo "User-data script completed successfully."
