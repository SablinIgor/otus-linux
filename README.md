# Выполнено ДЗ №2

 - [x] Основное ДЗ
 - [x] Задание со *
 - [ ] Задание со **

## В процессе сделано:
 - Установлен пакет mdadm для управления рейдом
 - Подключены пять дисков для организации рейда
 - Очищены суперблоки RAID на разделах, из которых собран массив (не обязательный шаг, так как "диски" новые)
 - Запущена команда сборки 10-го рейда из пяти дисков
 - В файл /etc/mdadm.conf записана информация о рейде (тоже уже не обязтельно)
 - На рейде создан GPT-раздел, так же созданы и отформатированы разделы с файловой системой ext4
 - Соответствующие разделы примонтированы к каталогу /raid
 - (*) Реализован provisioner-скрипт, выполняющий все пречисленые выше шаги
 - (*) При запуске вагранта выполняется provisioner-скрипт

## Как запустить проект:
 - vagrant up

## Как проверить работоспособность:
 - vagrant ssh
 - cat /proc/mdstat
 - ls -lah /raid

