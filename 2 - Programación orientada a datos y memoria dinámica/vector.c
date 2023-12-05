#include "vector.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
typedef struct vector_s {
	uint64_t size;	// Cantidad de elementos en el vector
    uint64_t capacity;    // Capacidad del vector
	// El array subyacente con los elementos del vector (el tamaño del array estará dado por el campo capacity):
	uint32_t* array;
} vector_t;
*/


vector_t* nuevo_vector(void) {
    vector_t* v = malloc(sizeof(vector_t));
    v->size = 0;
    v->capacity = 1;
    v->array = malloc(sizeof(uint32_t));

    return v;
}

uint64_t get_size(vector_t* vector) {
    return vector->size;
}

void push_back(vector_t* vector, uint32_t elemento) {
    if(vector->capacity <= vector->size){
        vector->array = realloc(vector->array, (vector->capacity*2)*sizeof(uint32_t));
        vector->capacity *= 2;
    }

    vector->array[vector->size] = elemento;
    vector->size++;

}

int son_iguales(vector_t* v1, vector_t* v2) {
    if(v1->size != v2->size) return 0;
    
    for(size_t i = 0; i < v1->size ; i++){
        if(v1->array[i] != v2->array[i]) return 0;
    }

    return 1;
}

uint32_t iesimo(vector_t* vector, size_t index) {
    return vector->array[index];
}

void copiar_iesimo(vector_t* vector, size_t index, uint32_t* out){
    *out = vector->array[index];
}


// Dado un array de vectores, devuelve un puntero a aquel con mayor longitud.
vector_t* vector_mas_grande(vector_t** array_de_vectores, size_t longitud_del_array) {
    vector_t* mayor = array_de_vectores[0];

    for (size_t i = 1; i < longitud_del_array; i++) {
        if(array_de_vectores[i]->size > mayor->size){
            mayor = array_de_vectores[i];
        }
    }

    return mayor;
}
