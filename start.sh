#!/bin/sh

# Пробуем разные варианты запуска приложения
if [ -f "server.js" ]; then
    echo "Starting with server.js..."
    node server.js
elif [ -f "app.js" ]; then
    echo "Starting with app.js..."
    node app.js
elif [ -f "index.js" ]; then
    echo "Starting with index.js..."
    node index.js
elif [ -f "src/server.js" ]; then
    echo "Starting with src/server.js..."
    node src/server.js
elif [ -f "src/app.js" ]; then
    echo "Starting with src/app.js..."
    node src/app.js
elif [ -f "src/index.js" ]; then
    echo "Starting with src/index.js..."
    node src/index.js
else
    echo "No main file found. Checking package.json for main field..."
    MAIN_FILE=$(node -pe "require('./package.json').main || 'index.js'")
    echo "Starting with $MAIN_FILE..."
    node $MAIN_FILE
fi
