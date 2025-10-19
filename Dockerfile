# Используем Alpine 3.17.0 для ARM32v7 и устанавливаем Node.js 10 вручную
FROM arm32v7/alpine:3.17.0

# Используем Node.js 10 (совместим со старым Grunt и избегает ошибки primordials)
# FROM arm32v7/node:10-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем необходимые системные зависимости (БЕЗ Ruby/Compass)
RUN apk add --no-cache \
    nodejs \
    npm \
    #python2 \
    python3 \
    make \
    g++ \
    git

# Копируем конфигурационные файлы
COPY package*.json bower.json .bowerrc Gruntfile.js ./

# Удаляем phantomjs и grunt-contrib-compass из зависимостей
RUN npm pkg delete dependencies.phantomjs devDependencies.phantomjs devDependencies.grunt-contrib-compass || true

# Устанавливаем grunt-cli и bower глобально
RUN npm install -g grunt-cli bower

# Устанавливаем npm зависимости
RUN npm install --legacy-peer-deps --ignore-scripts || \
    npm install --legacy-peer-deps

# Устанавливаем bower зависимости (фронтенд библиотеки)
RUN bower install --allow-root --config.interactive=false || echo "Bower install completed with warnings"

# Копируем остальные файлы приложения
COPY . .

# Открываем порт (Grunt использует 9000)
EXPOSE 9000

# Запускаем с флагом --force чтобы игнорировать ошибки отсутствующих задач Compass
CMD ["grunt", "serve", "--force"]
