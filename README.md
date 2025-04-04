# Simple Docker

Введение в докер. Разработка простого докер-образа для собственного сервера.

## Part 1. Готовый докер


##### Возьмем официальный докер-образ с **nginx** и выкачаем его при помощи `docker pull`.
![](src/screenshots/e-1.png)

##### Проверим наличие докер-образа через `docker images`.
![](src/screenshots/e-2.png)


##### Запустим докер-образ через `docker run -d [image_id|repository]`.
![](src/screenshots/e-3.png)


##### Проверим, что образ запустился через `docker ps`.
![](src/screenshots/e-4.png)


##### Посмотрим информацию о контейнере через `docker inspect [container_id|container_name]`.
![](src/screenshots/e-6.png)
##### По выводу команды определим и поместим в отчёт размер контейнера:
![](src/screenshots/e-5.png)

#### Список замапленных портов:
![](src/screenshots/e-7.png)

#### и ip контейнера:
![](src/screenshots/e-8.png)


##### Остановим докер контейнер через `docker stop [container_id|container_name]`.
![](src/screenshots/e-9.png)


##### Проверим, что контейнер остановился через `docker ps`.
![](src/screenshots/e-10.png)


##### Запустим докер с портами 80 и 443 в контейнере, замапленными на такие же порты на локальной машине, через команду *run*.
![](src/screenshots/e-11.png)


##### Проверим, что в браузере по адресу *localhost:80* доступна стартовая страница **nginx**.
![](src/screenshots/e-12.png)

##### Перезапустим докер контейнер через `docker restart [container_id|container_name]`.
![](src/screenshots/e-13.png)


##### Проверим любым способом, что контейнер запустился.
![](src/screenshots/e-14.png)


#### Проверим стартовой страницы **nginx** по адресу *localhost:80* после перезапуска.
![](src/screenshots/e-15.png)


## Part 2. Операции с контейнером


##### Прочитаем конфигурационный файл *nginx.conf* внутри докер контейнера через команду *exec*:
![](src/screenshots/e-16.png)

##### Создадим на локальной машине файл *nginx.conf* с данными из конфигурационного файла *nginx.conf* и откроем для редактирования через *vim*:
![](src/screenshots/e-17.png)

##### Настроем в нем по пути */status* отдачу страницы статуса сервера **nginx**.
![](src/screenshots/e-18.png)


##### Скопируем созданный файл *nginx.conf* внутрь докер-образа через команду `docker cp`.
![](src/screenshots/e-19.png)

##### Перезапустим **nginx** внутри докер-образа через команду *exec*.
![](src/screenshots/e-20.png)


##### Проверим, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**.
![](src/screenshots/e-21.png)


##### Экспортируем контейнер в файл *container.tar* через команду *export*.
![](src/screenshots/e-22.png)


##### Остановим контейнер.
![](src/screenshots/e-23.png)



##### Удалим образ через `docker rmi [image_id|repository]`, не удаляя перед этим контейнеры.
![](src/screenshots/e-24.png)


##### Удалим остановленный контейнер.
![](src/screenshots/e-25.png)


##### Импортируем контейнер обратно через команду *import*.
![](src/screenshots/e-26.png)


##### Запустим импортированный контейнер.
![](src/screenshots/e-27.png)


##### Проверим, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**.
![](src/screenshots/e-28.png)


## Part 3. Мини веб-сервер


##### Напишим мини-сервер на **C** и **FastCgi**, который будет возвращать простейшую страничку с надписью `Hello World!`.
#### Сначало скачаем `nginx` командой `docker pull nginx`
![](src/screenshots/e-29.png)

#### Запустим контейнер командой `docker run --rm -d -p 81:81 [container_id|container_name] nginx`
![](src/screenshots/e-30.png)


#### Проверим систему на наличие обновлений командой `docker exec [container_id|container_name] apt update`
![](src/screenshots/e-31.png)


#### Командой `docker exec [container_id|container_name] apt install -y gcc spawn-fcgi libfcgi-dev` установим необходимые инструменты для компиляции сервера.
![](src/screenshots/e-37.png)


#### Командой `docker commit [container_id|container_name] [new image]` зафиксируем изменения.
![](src/screenshots/e-32.png)


#### Напишим свой *nginx.conf*, который будет проксировать все запросы с 81 порта на *127.0.0.1:8080*.
![](src/screenshots/e-33.png)

#### Командой `docker cp nginx.conf [container_id|container_name]:/etc/nginx/nginx.conf` внесем изменения в конфиругационный файл nginx
![](src/screenshots/e-38.png)


##### Запустим написанный мини-сервер через *spawn-fcgi* на порту 8080.
![](src/screenshots/e-36.png)

##### Проверим, что в браузере по *localhost:81* отдается написанная нами страничка.
![](src/screenshots/e-35.png)


## Part 4. Свой докер


#### Напишим свой докер-образ, который:
##### 1) собирает исходники мини сервера на FastCgi из [Части 3](#part-3-мини-веб-сервер);
##### 2) запускает его на 8080 порту;
##### 3) копирует внутрь образа написанный *./nginx/nginx.conf*;
##### 4) запускает **nginx**.
_**nginx** можно установить внутрь докера самостоятельно, а можно воспользоваться готовым образом с **nginx**'ом, как базовым._
![](src/screenshots/e-40.png)

#### Соберем написанный докер-образ через `docker build` при этом указав имя и тег.
![](src/screenshots/e-41.png)


#### Проверим через `docker images`, что все собралось корректно.
![](src/screenshots/e-42.png)


#### Запустим собранный докер-образ с маппингом 81 порта на 80 на локальной машине и маппингом папки *./nginx* внутрь контейнера по адресу, где лежат конфигурационные файлы **nginx**'а (см. [Часть 2](#part-2-операции-с-контейнером)).
![](src/screenshots/e-43.png)


#### Проверим, что по localhost:80 доступна страничка написанного мини сервера.
![](src/screenshots/e-44.png)


#### Допишим в *./nginx/nginx.conf* проксирование странички */status*, по которой будем отдавать статус сервера **nginx**.
![](src/screenshots/e-45.png)


#### Перезапустим докер-образ.
![](src/screenshots/e-46.png)


#### Проверим, что теперь по *localhost:80/status* отдается страничка со статусом **nginx**
![](src/screenshots/e-47.png)


## Part 5. **Dockle**


##### Просканируем образ из предыдущего задания через `dockle [image_id|repository]`.
![](src/screenshots/e-48.png)

##### Исправим образ так, чтобы при проверке через **dockle** не было ошибок и предупреждений.
![](src/screenshots/e-49.png)

##### Запустим команду `export DOCKER_CONTENT_TRUST=1` и пересоберем образ:
![](src/screenshots/e-50.png)

##### Проверим что ошибок и предубреждений нет:
![](src/screenshots/e-51.png)

## Part 6. Базовый **Docker Compose**


##### Напишим файл *docker-compose.yml*, с помощью которого:
##### 1) Поднимим докер-контейнер из [Части 5](#part-5-инструмент-dockle) _(он должен работать в локальной сети, т. е. не нужно использовать инструкцию **EXPOSE** и мапить порты на локальную машину)_.
![](src/screenshots/e-52.png)
![](src/screenshots/e-53.png)

##### 2) Поднимим докер-контейнер с **nginx**, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера.
##### Замапим 8080 порт второго контейнера на 80 порт локальной машины.
![](src/screenshots/e-54.png)
![](src/screenshots/e-55.png)

##### Nginx для первого контейнера
![](src/screenshots/e-60.png)

##### Nginx для второго контейнера
![](src/screenshots/e-61.png)

##### Dockerfile для первого контейнера
![](src/screenshots/e-62.png)

##### Dockerfile для второго контейнера
![](src/screenshots/e-63.png)

##### Docker-compose
![](src/screenshots/e-64.png)


##### Остановим все запущенные контейнеры.
![](src/screenshots/e-56.png)


##### Соберем и запустим проект с помощью команд `docker-compose build`
![](src/screenshots/e-57.png)

##### и `docker-compose up`.
![](src/screenshots/e-58.png)

##### Проверим, что в браузере по *localhost:80* отдается написанная нами страничка, как и ранее.
![](src/screenshots/e-59.png)
