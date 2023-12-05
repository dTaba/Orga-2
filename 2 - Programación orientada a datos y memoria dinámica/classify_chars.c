#include "classify_chars.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
typedef struct classifier_s {
    char** vowels_and_consonants;
	char* string;
} classifier_t;
*/

int is_vowel(char c){
    return 
        c == 'a' ||
        c == 'A' ||
        c == 'e' ||
        c == 'E' ||
        c == 'i' ||
        c == 'I' ||
        c == 'o' ||
        c == 'O' ||
        c == 'u' ||
        c == 'U' ;
}

void classify_chars_in_string(char* string, char** vowels_and_cons) {
    size_t size_vowels = 0;
    size_t size_consonants = 0;

    for (size_t i = 0; string[i] != '\0'; i++) {
        if (is_vowel(string[i])) {
            vowels_and_cons[0][size_vowels++] = string[i];
        } else {
            vowels_and_cons[1][size_consonants++] = string[i];
        }
    }
}

void classify_chars(classifier_t* array, uint64_t size_of_array) {
    
    for (size_t i = 0; i < size_of_array; i++) {    
        array[i].vowels_and_consonants = malloc(2 * sizeof(char*));   // 0: Vocales. 1: Consonantes
        array[i].vowels_and_consonants[0] = calloc(64, sizeof(char)); // Máximo 64 vocales
        array[i].vowels_and_consonants[1] = calloc(64, sizeof(char)); // Máximo 64 consonantes

        classify_chars_in_string(array[i].string, array[i].vowels_and_consonants);
    }
}
