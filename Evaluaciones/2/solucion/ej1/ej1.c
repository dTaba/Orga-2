#include "ej1.h"

string_proc_list* string_proc_list_create(void){

	// Pido memoria para guardar el struct
	string_proc_list* structLista = malloc (sizeof(string_proc_list));


	// Asigno los valores de la lista
	structLista->first = NULL;
	structLista->last = NULL;

	return structLista;
}

string_proc_node* string_proc_node_create(uint8_t type, char* hash){
	
	// Creo el nodo que me pasan

	string_proc_node* newNode = malloc(sizeof(string_proc_node));

	newNode->type = type;
	newNode->hash = hash;

	return newNode;
}

void string_proc_list_add_node(string_proc_list* list, uint8_t type, char* hash){


	string_proc_node* newNode = string_proc_node_create(type, hash);
	// En el caso de que no haya primero

	if (list->first == NULL)
	{
		
		// Le asigno los campos que me restaban
		newNode->next = NULL;
		newNode->previous == NULL;
		
		// Lo agrego a la lista
		list->first = newNode;
		list->last = newNode;
	}
	else
	{
		// Como lo agrego al final su siguiente es nulo
		newNode->next = NULL;
		

		string_proc_node* ultimoNodo = list->last;
		
		newNode->previous = ultimoNodo;

		// Se lo agrego al ultimo nodo actual como siguiente
		ultimoNodo->next = newNode;
		

		// Lo establezco como ultimo nodo de la lista
		list->last = newNode;
	}
}

char* string_proc_list_concat(string_proc_list* list, uint8_t type , char* hash){
	char* concatHash = hash;

	// Me pongo a recorrer los nodos

	if(list->first == NULL) return "";

	// Recorro toda la lista enlazada

	string_proc_node* nodoActual = list->first; 

	while (nodoActual != NULL)
	{	
		

		// if (nodoActual->type == type)
		// {
		// 	hash = hash + (nodoActual->hash);
		// }
		
		nodoActual = nodoActual->next;
	}
	

}


/** AUX FUNCTIONS **/

void string_proc_list_destroy(string_proc_list* list){

	/* borro los nodos: */
	string_proc_node* current_node	= list->first;
	string_proc_node* next_node		= NULL;
	while(current_node != NULL){
		next_node = current_node->next;
		string_proc_node_destroy(current_node);
		current_node	= next_node;
	}
	/*borro la lista:*/
	list->first = NULL;
	list->last  = NULL;
	free(list);
}
void string_proc_node_destroy(string_proc_node* node){
	node->next      = NULL;
	node->previous	= NULL;
	node->hash		= NULL;
	node->type      = 0;			
	free(node);
}


char* str_concat(char* a, char* b) {
	int len1 = strlen(a);
    int len2 = strlen(b);
	int totalLength = len1 + len2;
    char *result = (char *)malloc(totalLength + 1); 
    strcpy(result, a);
    strcat(result, b);
    return result;  
}

void string_proc_list_print(string_proc_list* list, FILE* file){
        uint32_t length = 0;
        string_proc_node* current_node  = list->first;
        while(current_node != NULL){
                length++;
                current_node = current_node->next;
        }
        fprintf( file, "List length: %d\n", length );
		current_node    = list->first;
        while(current_node != NULL){
                fprintf(file, "\tnode hash: %s | type: %d\n", current_node->hash, current_node->type);
                current_node = current_node->next;
        }
}