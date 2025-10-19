# Используем базовый образ Node.js для ARM v7
FROM arm32v7/node:14-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы приложения
COPY . .

# Открываем порт (проверьте какой порт использует приложение, обычно 3000)
EXPOSE 3000

# Запускаем приложение
CMD ["npm", "start"]
