#include "ej2.h"

void combinarImagenes(uint8_t *src_a, uint8_t *src_b, uint8_t *dst, uint32_t width, uint32_t height)
{   

    uint32_t pixelesTotales = width * height;

    // Una vez tengo los pixeles, los multiplico por 4, asi puedo recorrer cada byte
    // (componente BGRA) en memoria 

    for (size_t i = 0; i < pixelesTotales * 4 ; i += 4)
    {
        uint8_t Ab = src_a[i];
        uint8_t Ag = src_a[i + 1];
        uint8_t Ar = src_a[i + 2];
        
        uint8_t Bb = src_b[i];
        uint8_t Bg = src_b[i + 1];
        uint8_t Br = src_b[i + 2];

        dst[i] = Ab + Br;
        
        if (Ag > Bg)
        {
            dst[i + 1] = Ag - Bg;
        }
        else
        {
            dst[i + 1] = (Ag + Bg + 1) / 2;
        }
        
        
        dst[i + 2] = Bb - Ar,
        dst[i + 3] = 255;

    }
    
}
