# Используем базовый образ Node.js для ARM v7
FROM arm32v7/node:14-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем необходимые системные зависимости
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git \
    ruby \
    ruby-dev

# Устанавливаем Compass (требуется для grunt-contrib-compass)
RUN gem install compass --no-document

# Копируем package.json и package-lock.json
COPY package*.json ./

# Удаляем phantomjs из зависимостей перед установкой
RUN npm pkg delete dependencies.phantomjs devDependencies.phantomjs || true

# Устанавливаем зависимости, игнорируя опциональные и скрипты
RUN npm install --legacy-peer-deps --no-optional || \
    npm install --legacy-peer-deps --no-optional --ignore-scripts

# Устанавливаем grunt-cli глобально
RUN npm install -g grunt-cli

# Копируем остальные файлы приложения
COPY . .

# Открываем порт (Grunt использует 9000)
EXPOSE 9000

# Запускаем Grunt сервер
CMD ["grunt", "serve"]
