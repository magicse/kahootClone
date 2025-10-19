# Используем Node.js 10 (последняя версия совместимая со старым Grunt)
FROM arm32v7/node:10-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем необходимые системные зависимости
RUN apk add --no-cache \
    python2 \
    make \
    g++ \
    git \
    ruby \
    ruby-dev

# Устанавливаем Compass
RUN gem install compass --no-document

# Копируем package.json, bower.json и другие конфиги
COPY package*.json bower.json .bowerrc .jshintrc .editorconfig Gruntfile.js ./

# Удаляем phantomjs из зависимостей
RUN npm pkg delete dependencies.phantomjs devDependencies.phantomjs || true

# Устанавливаем grunt-cli и bower глобально
RUN npm install -g grunt-cli bower

# Устанавливаем npm зависимости
RUN npm install --legacy-peer-deps --no-optional --ignore-scripts || \
    npm install --legacy-peer-deps --ignore-scripts

# Устанавливаем bower зависимости (фронтенд библиотеки)
RUN bower install --allow-root --config.interactive=false || true

# Копируем остальные файлы приложения
COPY . .

# Открываем порт
EXPOSE 9000

# Запускаем Grunt сервер
CMD ["grunt", "serve", "--force"]
