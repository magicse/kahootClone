# Используем базовый образ Node.js для ARM v7
FROM arm32v7/node:14-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем необходимые системные зависимости
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git

# Копируем package.json и package-lock.json
COPY package*.json ./

# Удаляем phantomjs из зависимостей перед установкой
# Phantomjs устарел и не поддерживает ARM
RUN npm pkg delete dependencies.phantomjs devDependencies.phantomjs || true

# Устанавливаем зависимости, игнорируя опциональные и скрипты
RUN npm install --legacy-peer-deps --no-optional || \
    npm install --legacy-peer-deps --no-optional --ignore-scripts

# Копируем остальные файлы приложения
COPY . .

# Открываем порт (обычно 3000 для Node.js приложений)
EXPOSE 3000

# Запускаем приложение
CMD ["npm", "start"]
