# Выполнено ДЗ №8

 - [x] Основное ДЗ

## В процессе сделано:

 - подготовлен скрипт myps.sh реализующий функционал аналогичный команде ps ax
 - скрипт анализирует информацию из pseudofs /proc, а именно /status, /stat, /cmdline, /fd
 - для форматирования вывода используется функция printf
 - для разбора содержимого файлов используются команды grep, cut и awk
 - для отображения процессов в порядке возрастания PID используется конструкция: for filename in `ls -v /proc/`

## Как проверить
 - vagrant up
 - vagrant ssh
 - /vagrant/myps.sh 

## Основные источники
 - http://man7.org/linux/man-pages/man5/proc.5.html
 - http://man7.org/linux/man-pages/man1/ps.1.html
