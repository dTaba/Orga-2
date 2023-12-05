#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "checkpoints.h"

int main (void){
	/* Acá pueden realizar sus propias pruebas */

	char* ab = "Omega 4";
	char* ac = strClone(ab);
	char O = ac[0];
	char m = ac[1];
	char e = ac[2];
	char g = ac[3];
	char a = ac[4];
	char vacio = ac[5];
	char cuatro = ac[6];
	char cero = ac[7];

	printf("%s", ac);

	// cantidad_total_de_elementos(lista_t* lista);

	return 0;    
}


/* double result = 0;
product_9_f(&result, 537, 856.84, 756, 355.15, 312, 673.83, 136, 775.78, 846, 569.28, 956, 380.50, 853, 878.93, 547, 848.49, 905, 505.46);
assert(result == 76411573841209480161781729743207479513861486280704.00); */

// Nos anoto Nico