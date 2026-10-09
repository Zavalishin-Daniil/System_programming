#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    // Проверяем, что передано ровно 3 аргумента
    if (argc != 4) {
        printf("Использование: %s a b c\n", argv[0]);
        return 1;
    }

    // Преобразуем строки в целые числа (аналог str_number)
    long long a = atoll(argv[1]);
    long long b = atoll(argv[2]);
    long long c = atoll(argv[3]);

    // Вычисляем ((((a/b)-a)/b)*c)+a
    // Целочисленное деление — как idiv в ассемблере
    long long result = ((((a / b) - a) / b) * c) + a;

    // Выводим результат (аналог print_number + sys_write)
    printf("%lld\n", result);

    return 0;
}
