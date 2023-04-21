# Дипломная работа к профессии «iOS-разработчик» (Нетология)

## Основные экраны:
### 1. Экран утентификации/регистрации
![Экран утентификации/регистрации](https://downloader.disk.yandex.ru/preview/0b6eef95b2ccc948e3ad0848dfe0cf6ad85a4a1468f0ccb2c976f3d7741b2275/644253d8/_JCNo9srCvaM_9VxgfguGS6Sqw3MkXrw11P2jIAzEe-BCmxqhoY4E9AwdiTFdbIj-gWsjGM-29_US3npkw-uMw%3D%3D?uid=0&filename=Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-21%20at%2008.10.45.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=0&tknv=v2&size=2048x2048)
### 2. Экран ленты постов/публикаций
![Экран ленты постов/публикаций](https://downloader.disk.yandex.ru/preview/043f39f2c6de7b4634fbae41a88975efbb0428e8d42a81bfe0147b9659cb81f4/6442542b/LrZsiDqRQHGhbnNAu8J4jyoMgYTXObsU-YDKyp7xttgLmQKWQZPXioMEFiuqzKDkK04cBcadbS7okicy-58ZaQ%3D%3D?uid=0&filename=Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-21%20at%2008.11.48.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=0&tknv=v2&size=2048x2048)
### 3. Экран детальной информации поста/публикации с комментариями
![Экран детальной информации поста/публикации с комментариями](https://downloader.disk.yandex.ru/preview/65171c3d3836e512bdbef928964f4322980f2191854ec37aaa8055e9522efcf9/64425481/OQrc38lwcSwsLtoWqeLviawRPTRW3M1qbdSsd4Fh3OcWKVzVeA3l34mGMEFjtNvuiYMkkeT5Gnw3ggOwM7pzkA%3D%3D?uid=0&filename=Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-21%20at%2008.12.02.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=0&tknv=v2&size=2048x2048)
### 4. Экран персональной страницы со списком постов/публикаций
![Экран персональной страницы со списком постов/публикаций](https://downloader.disk.yandex.ru/preview/395d648f4634d59b05f5606674540254cbc1850f2bd15ac66b01068bd291f5f8/644254a6/8DqKebVEpJIossfNt1KNlv-PchPQlQlH7xmGjS8pKMJy16dQBlWQ4WDFGvTXgARBVKz8ChHBhCaIhcnOVjkaLA%3D%3D?uid=0&filename=Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-21%20at%2008.12.12.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=0&tknv=v2&size=2048x2048)
### 5. Экран со списком избранных постов/публикаций
![Экран со списком избранных постов/публикаций](https://downloader.disk.yandex.ru/preview/02b12f40b9a0753ef73a15a11bf2b6b3843f216105fe45dceecc1af7521ec4a7/644254f2/mxr0Ft3C0gX9EpuC42H1I_-PchPQlQlH7xmGjS8pKMJhulLoCyplnD04bDzamBtFTVeXtKa5ENAr6S9psWIhfg%3D%3D?uid=0&filename=Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-21%20at%2008.12.20.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=0&tknv=v2&size=2048x2048)
### 6. Экран создания поста/публикации
### 7. Экран редактирования персональных данных

## Основные компоненты:
### 1. UIKitFacade
UIKitFacade используется в качестве общего конфигурируемого сайлгайда, внутри которого собраны все настройки цветов и шрифтов.
### 2. База данных
В качестве базы данных используется Fairebase + Firestore. Все данные сохраняются и получаются из этих сервисов посредством запросов (используется официальный клиент).
Firebase используется в качестве сервиса аутентификации/регистрации, а Firestore в качестве непосредственной базы хранения контента.
В Firestore представлены основные сущности, а именно: `bloggers`, `posts`, `post-comments`, `post-favorites`, `post-likes`.
### 3. Сервис хранения изображений
В качестве сервиса, куда загружаются, хранятся и возвращаются изображения используется сервис Uploadcare.
* У сервиса Uploadcare есть ограничение на размер одного изображения при загрузке - 10МБ (на это в приложении имеется проверка)
### 4. Кеширование
В качестве оптимизации получения изображений, они кешируются в локальном хранилище пользователя (` class ImageService`).
Также, кешируется и авторизация пользователя: для этого используется кеширование локальной базе данных Realm (`class RealmAuthUserStorage`) и сохранение в памяти (`class CurrentUserService`).
### 5. FaceID
Чтобы упростить и обезопасить аутентификацию пользователя используется FaceID.

