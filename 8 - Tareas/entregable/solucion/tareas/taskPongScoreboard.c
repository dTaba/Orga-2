#include "task_lib.h"

#define WIDTH TASK_VIEWPORT_WIDTH
#define HEIGHT TASK_VIEWPORT_HEIGHT

#define SHARED_SCORE_BASE_VADDR (PAGE_ON_DEMAND_BASE_VADDR + 0xF00)
#define CANT_PONGS 3


void task(void) {
	screen pantalla;
	// ¿Una tarea debe terminar en nuestro sistema?
	while (true) {
	// Completar:
	// - Pueden definir funciones auxiliares para imprimir en pantalla
	// - Pueden usar `task_print`, `task_print_dec`, etc. 
		for(uint8_t task_id = 0; task_id < CANT_PONGS; task_id++) {
			uint32_t* current_task_record = (uint32_t*) SHARED_SCORE_BASE_VADDR + ((uint32_t) task_id * sizeof(uint32_t)*2);
			
			uint8_t renglon = task_id*4 + 5;

			task_print_dec(pantalla, task_id, 4, 5, renglon, C_FG_WHITE);
			
			task_print(pantalla, "Jugador 1:", 5, renglon + 1, C_FG_WHITE);
			task_print_dec(pantalla, current_task_record[0], 5, 20, renglon + 1, C_FG_WHITE);

			task_print(pantalla, "Jugador 2:", 5, renglon + 2, C_FG_WHITE);
			task_print_dec(pantalla, current_task_record[1], 5, 20, renglon + 2, C_FG_WHITE);
		}

		syscall_draw(pantalla);
	}
}
