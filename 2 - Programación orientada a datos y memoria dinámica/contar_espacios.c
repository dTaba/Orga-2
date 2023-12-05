#include "contar_espacios.h"
#include <stdio.h>

uint32_t longitud_de_string(char* string) {
    if (string == NULL) return 0;
    uint32_t longitud = 0;
    for (size_t i = 0; string[i] != '\0'; i++)
    {
        longitud++;
    }

    return longitud;
    
}

uint32_t contar_espacios(char* string) {
    if (string == NULL) return 0;
    uint32_t espacios = 0;
    for (size_t i = 0; string[i] != '\0'; i++) {
        espacios += string[i] == ' ';
    }

    return espacios;
    
}

// Pueden probar acá su código (recuerden comentarlo antes de ejecutar los tests!)
/*
int main() {

    printf("1. %d\n", contar_espacios("hola como andas?"));

    printf("2. %d\n", contar_espacios("holaaaa orga2"));
}
*/