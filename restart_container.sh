#!/bin/bash

# Имя контейнера
CONTAINER_NAME="deploy-node-1"

# Фильтр ошибки
ERROR_FILTER="One of the blocks specified in filter"

# Команда для перезапуска контейнера
RESTART_COMMAND="docker restart ${CONTAINER_NAME}"

# Файл для хранения количества перезапусков
RESTART_COUNT_FILE="/var/log/docker/${CONTAINER_NAME}_restart_count.log"

# Бесконечный цикл
while true; do
    # Инициализация счетчика перезапусков
    if [ ! -f $RESTART_COUNT_FILE ]; then
        echo 0 > $RESTART_COUNT_FILE
    fi

    # Чтение логов контейнера с конца (последние 5 строк) и следование за новыми записями
    docker logs --tail 5 -f $CONTAINER_NAME | while read line ; do
        echo "Прочитанная строка: $line"  # Отладочная информация
        echo "$line" | grep -q "$ERROR_FILTER"
        if [ $? = 0 ]
        then
            echo "Ошибка обнаружена: $line"
            echo "Перезапуск контейнера..."

            # Перезапуск контейнера
            $RESTART_COMMAND

            # Увеличение счетчика перезапусков
            RESTART_COUNT=$(cat $RESTART_COUNT_FILE)
            RESTART_COUNT=$((RESTART_COUNT + 1))
            echo $RESTART_COUNT > $RESTART_COUNT_FILE

            echo "Количество перезапусков: $RESTART_COUNT"
        fi
    done
done
