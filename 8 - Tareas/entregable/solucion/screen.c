/* ** por compatibilidad se omiten tildes **
================================================================================
 TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Definicion de funciones de impresion por pantalla.
*/

#include "screen.h"

void print(const char* text, uint32_t x, uint32_t y, uint16_t attr) {
  ca(*p)[VIDEO_COLS] = (ca(*)[VIDEO_COLS])VIDEO; 
  int32_t i;
  for (i = 0; text[i] != 0; i++) {
    p[y][x].c = (uint8_t)text[i];
    p[y][x].a = (uint8_t)attr;
    x++;
    if (x == VIDEO_COLS) {
      x = 0;
      y++;
    }
  }
}

void print_dec(uint32_t numero, uint32_t size, uint32_t x, uint32_t y,
               uint16_t attr) {
  ca(*p)[VIDEO_COLS] = (ca(*)[VIDEO_COLS])VIDEO; 
  uint32_t i;
  uint8_t letras[16] = "0123456789";

  for (i = 0; i < size; i++) {
    uint32_t resto = numero % 10;
    numero = numero / 10;
    p[y][x + size - i - 1].c = letras[resto];
    p[y][x + size - i - 1].a = attr;
  }
}

void print_hex(uint32_t numero, int32_t size, uint32_t x, uint32_t y,
               uint16_t attr) {
  ca(*p)[VIDEO_COLS] = (ca(*)[VIDEO_COLS])VIDEO; 
  int32_t i;
  uint8_t hexa[8];
  uint8_t letras[16] = "0123456789ABCDEF";
  hexa[0] = letras[(numero & 0x0000000F) >> 0];
  hexa[1] = letras[(numero & 0x000000F0) >> 4];
  hexa[2] = letras[(numero & 0x00000F00) >> 8];
  hexa[3] = letras[(numero & 0x0000F000) >> 12];
  hexa[4] = letras[(numero & 0x000F0000) >> 16];
  hexa[5] = letras[(numero & 0x00F00000) >> 20];
  hexa[6] = letras[(numero & 0x0F000000) >> 24];
  hexa[7] = letras[(numero & 0xF0000000) >> 28];
  for (i = 0; i < size; i++) {
    p[y][x + size - i - 1].c = hexa[i];
    p[y][x + size - i - 1].a = attr;
  }
}

void screen_draw_box(uint32_t fInit, uint32_t cInit, uint32_t fSize,
                     uint32_t cSize, uint8_t character, uint8_t attr) {
  ca(*p)[VIDEO_COLS] = (ca(*)[VIDEO_COLS])VIDEO;
  uint32_t f;
  uint32_t c;
  for (f = fInit; f < fInit + fSize; f++) {
    for (c = cInit; c < cInit + cSize; c++) {
      p[f][c].c = character;
      p[f][c].a = attr;
    }
  }
}

void screen_draw_text(uint32_t fInit, uint32_t cInit, char* c, uint8_t attr){
    while(*c != '\0')
        screen_draw_box(fInit, cInit++, 1, 1, *(c++), attr);
}

void screen_draw_layout(void) {
    screen_draw_box(0,0,50,80, ' ', 0);

    char* integrantes[] = {"Francisco Pacio", "Diego Tabarez", "Agustin Campagna"};

    for(uint8_t i = 0; i < sizeof(integrantes)/sizeof(char*); i++) {
        uint32_t col = 0;

        char* c = integrantes[i];

        screen_draw_text(i, col++, c, 0xF);

    }
}

void screen_draw_smiley(void) {
    screen_draw_box(10, 10, 20, 20, ' ', 0);  // Limpia un área en blanco

    // Dibuja el círculo exterior
    screen_draw_box(12, 15, 6, 10, '#', 0x0F);  // Borde azul

    // Dibuja los ojos
    screen_draw_box(13, 13, 2, 2, 'O', 0x0E);  // Ojo izquierdo (amarillo)
    screen_draw_box(13, 18, 2, 2, 'O', 0x0E);  // Ojo derecho (amarillo)

    // Dibuja la boca (una sonrisa)
    screen_draw_box(15, 14, 1, 6, '-', 0x0E);  // Sonrisa

    screen_draw_text(22, 14, "¡Feliz!", 0x0A);  // Agrega un mensaje
}

void screen_draw_cat(void) {
    screen_draw_box(10, 10, 10, 20, ' ', 0);  // Limpia un área en blanco

    // Dibuja el cuerpo del gato
    screen_draw_text(11, 13, "/\\_/\\", 0x0F);  // Cabeza
    screen_draw_text(12, 12, "( o.o )", 0x0F);  // Cuerpo
    screen_draw_text(13, 13, "> ^ <", 0x0F);    // Cola

    // Dibuja los ojos y la nariz
    screen_draw_text(12, 15, "o", 0x0E);  // Ojo izquierdo
    screen_draw_text(12, 17, "o", 0x0E);  // Ojo derecho
    screen_draw_text(12, 19, "^", 0x0C);  // Nariz

    // Dibuja las patas
    screen_draw_text(14, 12, "|_|", 0x0F);  // Pata izquierda
    screen_draw_text(14, 16, "|_|", 0x0F);  // Pata derecha
}