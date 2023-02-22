# Сборка PHP 8.2, Nginx, PostgreSQL, Redis

В сборке 2 окружения dev и prod.

В dev добавлен xdebug  PgAdmin
В prod добавлен opcache

Ссылки
Web - http://127.0.0.1:3080/

И, если запущена dev окружение
PgAdmin - http://127.0.0.1:5050

### Сборка
Если есть make
> make build

Если нет
> docker compose build

### Запуск Dev окружения
Если есть make
> make up

Если нет
> docker compose up -d

### Запуск Prod окружения
Если есть make
> make up-prod

Если нет
> docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

### Остановка
Если есть make
> make down

Если нет
> docker compose down --remove-orphans
