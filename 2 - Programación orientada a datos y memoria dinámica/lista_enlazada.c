#include "lista_enlazada.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


lista_t* nueva_lista(void) {
    lista_t* lista = malloc(sizeof(lista_t));
    lista->head = NULL;
    return lista;
}

uint32_t longitud(lista_t* lista) {
    if(lista == NULL) return 0;
    uint32_t l = 0;
    nodo_t* actual = lista->head;

    while(actual != NULL) {
        l++;
        actual = actual->next;
    }
    
    return l;
}


// Agrega un nodo al final de la lista.
// El nuevo nodo contendrá al array pasado como segundo argumento con su tamaño indicado por el tercer argumento.
// IMPORTANTE: se deberá almacenar una copia del arreglo pasado por parámetro,
// y dicha copia deberá ser válida durante todo el tiempo de vida de la lista.
void agregar_al_final(lista_t* lista, uint32_t* arreglo, uint64_t longitud) {
    if(lista == NULL) return;
    if(lista->head == NULL) {
        lista->head = malloc(sizeof(nodo_t));
        lista->head->arreglo = malloc(longitud * sizeof(uint32_t));
        for(size_t i = 0; i < longitud; i++) {
            lista->head->arreglo[i] = arreglo[i];
        }
        lista->head->longitud = longitud;
        lista->head->next = NULL;
        return;
    }

    nodo_t* actual = lista->head;

    while(actual->next != NULL) {
        actual = actual->next;
    }
    
    actual->next = malloc(sizeof(nodo_t));
    actual = actual->next;
    actual->arreglo = malloc(longitud * sizeof(uint32_t));
    for(size_t i = 0; i < longitud; i++) {
        actual->arreglo[i] = arreglo[i];
    }
    actual->longitud = longitud;
    actual->next = NULL;
}

nodo_t* iesimo(lista_t* lista, uint32_t i) {
    nodo_t* actual = lista->head;

    while(i != 0) {
        actual = actual->next;
        i--;
    }
    
    return actual;
}

uint64_t cantidad_total_de_elementos(lista_t* lista) {
    if(lista == NULL) return 0;
    uint64_t cant = 0;
    nodo_t* actual = lista->head;

    while(actual != NULL) {
        cant += actual->longitud;
        actual = actual->next;
    }
    
    return cant;
}

void imprimir_lista(lista_t* lista) {
 
    if(lista->head == NULL){
        printf("null");
        return;
    }

    nodo_t* actual = lista->head;

    while(actual->next != NULL){
        printf("| %ld | -> ", actual->longitud);
        actual = actual->next;
    }

    printf("null");
}

// Función auxiliar para lista_contiene_elemento
int array_contiene_elemento(uint32_t* array, uint64_t size_of_array, uint32_t elemento_a_buscar) {
    uint64_t i = 0;
    while (i < size_of_array && array[i] != elemento_a_buscar) i++;

    return i != size_of_array;
}

int lista_contiene_elemento(lista_t* lista, uint32_t elemento_a_buscar) {
    if(lista == NULL) return 0;

    nodo_t* actual = lista->head;

    while (actual != NULL) {
        if (array_contiene_elemento(actual->arreglo, actual->longitud, elemento_a_buscar)) return 1;

        actual = actual->next;
    }

    return 0;
}


// Devuelve la memoria otorgada para construir la lista indicada por el primer argumento.
// Tener en cuenta que ademas, se debe liberar la memoria correspondiente a cada array de cada elemento de la lista.
void destruir_lista(lista_t* lista) {
    nodo_t* actual = lista->head;

    while (actual != NULL) {
        free(actual->arreglo);

        nodo_t* tmp = actual;
        actual = actual->next;
        free(tmp);

    }
    
    free(lista);
}
