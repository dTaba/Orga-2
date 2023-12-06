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

uint8_t contar_pagos_aprobados(list_t* pList, char* usuario){

    uint8_t cantAprobados = 0;
    uint8_t soyUltimoNodo = 0;

    // Me paro en el primer nodo para recorrer toda la lista enlazada

    listElem_t* nodoActual = pList->first;
    listElem_t* ultimoNodo = pList->last;
    
    // Recorro la lista enlazada

    while (soyUltimoNodo == 0)
    {
        // Reviso que el cobrador sea el usuario y que este aprobado

        if ((strcmp(nodoActual->data->cobrador, usuario) == 0) && nodoActual->data->aprobado == 1)
        {
            cantAprobados++;
        }


        // Dejo de ejecutar el while

        if(nodoActual == ultimoNodo)
        {
            soyUltimoNodo = 1;
        }

        nodoActual = nodoActual->next;
    }
    
    return cantAprobados;
}

uint8_t contar_pagos_rechazados(list_t* pList, char* usuario){
    uint8_t cantRechazados = 0;
    uint8_t soyUltimoNodo = 0;

    // Me paro en el primer nodo para recorrer toda la lista enlazada

    listElem_t* nodoActual = pList->first;
    listElem_t* ultimoNodo = pList->last;
    
    // Recorro la lista enlazada

    while (soyUltimoNodo == 0)
    {
        // Reviso que el cobrador sea el usuario y que este rechazado

        if ((strcmp(nodoActual->data->cobrador, usuario) == 0) && nodoActual->data->aprobado == 0)
        {
            cantRechazados++;
        }


        // Dejo de ejecutar el while

        if(nodoActual == ultimoNodo)
        {
            soyUltimoNodo = 1;
        }

        nodoActual = nodoActual->next;
    }
    
    return cantRechazados;
    
}



pagoSplitted_t* split_pagos_usuario(list_t* pList, char* usuario){
    // En pagoSplitted_t* estan los pagos rechazados y aprobados
    // en los que el usuario esta como cobrador.

    // Tengo que saber cuantos pagos aprobados y rechazados hay,
    // para saber cuanta memoria debe pedir el malloc, punto anterior

    uint8_t cantAprobados = contar_pagos_aprobados(pList, usuario);
    uint8_t cantRechazados = contar_pagos_rechazados(pList, usuario);

    // Pido memoria

    pagoSplitted_t* pagoSplitted = malloc(sizeof(pagoSplitted_t));

    pagoSplitted->cant_aprobados = cantAprobados;
    pagoSplitted->cant_rechazados = cantRechazados;

    // Le asigno cantAprobados/Rechazados posiciones de 8 bytes (son punteros)
    pagoSplitted->aprobados = calloc(cantAprobados, 8);
    pagoSplitted->rechazados = calloc(cantRechazados, 8);

    // Me resta conseguir los punteros a esos pagos y ponerlos en esas posiciones 
    // de memoria creadas

    uint8_t soyUltimoNodo = 0;
    listElem_t* nodoActual = pList->first;
    listElem_t* ultimoNodo = pList->last;

    uint64_t indexRechazado = 0;
    uint64_t indexAprobado = 0;
    
    // Recorro la lista enlazada

    while (soyUltimoNodo == 0)
    {
        // Reviso que el cobrador sea el usuario y que este rechazado

        if ((strcmp(nodoActual->data->cobrador, usuario) == 0) && nodoActual->data->aprobado == 0)
        {
            // Es rechazado y es del usuario
            
            pagoSplitted->rechazados[indexRechazado] = nodoActual->data;
            indexRechazado++;
        }
        else
        {
            pagoSplitted->aprobados[indexAprobado] = nodoActual->data;
            indexAprobado++;
        }
        


        // Dejo de ejecutar el while

        if(nodoActual == ultimoNodo)
        {
            soyUltimoNodo = 1;
        }

        nodoActual = nodoActual->next;
    }
    
    return pagoSplitted;
}