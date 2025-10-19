# Используем базовый образ Node.js для ARM v7
FROM arm32v7/node:14-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем необходимые системные зависимости
# Добавляем ruby и compass для grunt-contrib-compass
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git \
    bash \
    ruby \
    ruby-dev

# Устанавливаем Compass (требуется для grunt-contrib-compass)
RUN gem install compass --no-document

# Копируем все файлы
COPY . .

# Делаем скрипт исполняемым и патчим package.json
RUN chmod +x patch-package.sh && ./patch-package.sh

# Устанавливаем зависимости
RUN npm install --legacy-peer-deps --ignore-scripts

# Устанавливаем grunt-cli глобально
RUN npm install -g grunt-cli

# Открываем порт (Grunt обычно использует 9000)
EXPOSE 9000

# Запускаем Grunt сервер
CMD ["grunt", "serve"]
