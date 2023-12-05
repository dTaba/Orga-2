#include "ej1.h"

list_t* listNew(){
  list_t* l = (list_t*) malloc(sizeof(list_t));
  l->first=NULL;
  l->last=NULL;
  return l;
}

void listAddLast(list_t* pList, pago_t* data){
    listElem_t* new_elem= (listElem_t*) malloc(sizeof(listElem_t));
    new_elem->data=data;
    new_elem->next=NULL;
    new_elem->prev=NULL;
    if(pList->first==NULL){
        pList->first=new_elem;
        pList->last=new_elem;
    } else {
        pList->last->next=new_elem;
        new_elem->prev=pList->last;
        pList->last=new_elem;
    }
}


void listDelete(list_t* pList){
    listElem_t* actual= (pList->first);
    listElem_t* next;
    while(actual != NULL){
        next=actual->next;
        free(actual);
        actual=next;
    }
    free(pList);
}


// Contar pagos aprobados de un usuario dado,
// tienen al usuario como cobrador

uint8_t contar_pagos_aprobados(list_t* pList, char* usuario){

    // Condicion del while

    uint8_t esUltimo = 0;

    // Variable contador

    uint8_t contadorPagosAprobados = 0;

    // Me guardo el puntero al ultimo elemento para saber cuando terminar

    listElem_t *ultimoPosicion = pList->last;

    // Accedo al primer elemento de la lista de elementos

    listElem_t *posicion = pList->first;

    // Recorro la lista de elementos

    while (esUltimo == 0)
    {   
        if (posicion->data->aprobado == 1)
        {   
            // Si esta aprobado y es cobrador

            if (strcmp(posicion->data->cobrador, usuario) == 0)
            {
                contadorPagosAprobados++;
            }
        }

        if (posicion == ultimoPosicion)
        {
            esUltimo = 1;
        }
        else
        {
            posicion = posicion->next;
        }
    }
    

    return contadorPagosAprobados;
    
}

// Contar pagos aprobados de un usuario dado,
// tienen al usuario como cobrador

uint8_t contar_pagos_rechazados(list_t* pList, char* usuario){
    
    // Condicion del while

    uint8_t esUltimo = 0;
    
    // Variable contador

    uint8_t contadorPagosRechazados = 0;

    // Me guardo el puntero al ultimo elemento para saber cuando terminar

    listElem_t *ultimoPosicion = pList->last;
    
    
    // Accedo al primer elemento de la lista de elementos

    listElem_t *posicion = pList->first;

    // Recorro la lista de elementos

    while (esUltimo == 0)
    {   
        if (posicion->data->aprobado == 0)
        {   
            // Si esta rechazado y es cobrador

            if (strcmp(posicion->data->cobrador, usuario) == 0)
            {
                contadorPagosRechazados++;
            }
        }


        if (posicion == ultimoPosicion)
        {
            esUltimo = 1;
        }
        else
        {
            posicion = posicion->next;
        }

    }
    

    return contadorPagosRechazados;
}

// Toma una lista enlazada de pagos y un usuario
// devuelve un puntero a pagoSplitted donde estan los pagos rechazados
// y aprobados que el usuario recibio, es decir en donde esta como
// cobrador
// Usar funciones del punto a

// lo dejo a la mitad e hice el de assembler

pagoSplitted_t* split_pagos_usuario(list_t* pList, char* usuario){
    // Primero que nada necesito saberposicion cuantos pagos rechazados y
    // aprobados necesito ya que sin eso no se cuanta memoria pedir
    // punto anterior ...

    uint8_t cantPagosAprobados = contar_pagos_aprobados(pList, usuario);
    uint8_t cantPagosRechazados = contar_pagos_rechazados(pList, usuario);

    // Ahora que ya lo se, puedo asignar la memoria necesaria

    pagoSplitted_t *pagosUsuario = malloc(sizeof(pagoSplitted_t));

    // Pido memoria para los punteros del struct
    
    pago_t **aprobados = malloc(8);
    pago_t **rechazados = malloc(8);

    pagosUsuario->aprobados = malloc(cantPagosAprobados * sizeof(pago_t));;
    pagosUsuario->rechazados = malloc(cantPagosRechazados * sizeof(pago_t));

    // Tanto la cantidad de aprobados como rechazados ya lo se,
    // lo asigno
    
    pagosUsuario->cant_aprobados = cantPagosAprobados;
    pagosUsuario->cant_rechazados = cantPagosRechazados;

    // Solo me resta agregar los pagos a la lista de aprobados
    // y rechazados

    uint8_t esUltimo = 0;

    listElem_t *ultimoPosicion = pList->last;

    listElem_t *posicion = pList->first;
    
    
    uint8_t ultimaPosicionRechazado = 0;
    uint8_t ultimaPosicionAprobado = 0;

    while (esUltimo == 0)
    {   

        // Aprobados
        if (posicion->data->aprobado == 1)
        {   

            if (strcmp(posicion->data->cobrador, usuario) == 0)
            {   
            
                pagosUsuario->aprobados[ultimaPosicionAprobado] = posicion->data;
                ultimaPosicionAprobado++;
            }
        }
        
        // Rechazados
        if (posicion->data->aprobado == 0)
        {
            if (strcmp(posicion->data->cobrador, usuario) == 1)
            {
                pagosUsuario->rechazados[ultimaPosicionRechazado] = posicion->data;
                ultimaPosicionRechazado++;
            }
        }
        


        if (posicion == ultimoPosicion)
        {
            esUltimo = 1;
        }
        else
        {
            posicion = posicion->next;
        }

    }

}