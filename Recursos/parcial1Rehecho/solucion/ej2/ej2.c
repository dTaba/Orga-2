#include "ej2.h"

void mezclarColores_c(uint8_t *X, uint8_t *Y, uint32_t width, uint32_t height){

    // Un pixel tiene 4 componentes -> R G B A
    uint32_t pixelesTotales = width * height;


    for (uint32_t i = 0; i < pixelesTotales * 4; i += 4)
    {
        // Agarro R|G|B|A

        uint8_t R = X[i];
        uint8_t G = X[i + 1];
        uint8_t B = X[i + 2];

        if (R > G && G > B )
        {
            Y[i] = B; // Y red
            Y[i + 1] = R; // Y green
            Y[i + 2] = G; // Y blue
        }
        else if (R < G && G < B)
        {
            Y[i] = G; // Y red
            Y[i + 1] = B; // Y green
            Y[i + 2] = R; // Y blue
        }
        else
        {
            Y[i] = R; // Y red
            Y[i + 1] = G; // Y green
            Y[i + 2] = B; // Y blue
        }

        Y[i + 3] = 0; // Transparencia
    }
}
