# Orga 2
## _2C 2023_
---

### Primera Parte:

Los tps 2 a 4 son ejercicios de assembler algunos cuyo objetivo es familiarizarse con este lenguaje y otros que resuelven problemas mas interesantes como lo es implementar un filtro de imagenes procesando los datos en paralelol (SIMD). Para correr los tests de estos ejercicios va a hacer falta tener instalado GCC, Valgrind y GDB / GDB Dashboard si se quiere debuggear.

GCC
```sh
sudo apt update 
sudo apt install build-essential
```
Valgrind
```sh
sudo apt install valgrind
```
GDB
```sh
sudo apt install gdb
wget -P ~ https://git.io/.gdbinit
pip install pygments
```
---
### Segunda Parte:

Los tps 5 a 8 cubren un desarrollo incremental en el cual se desarrolla un pequeño sistema operativo. Tp a tp se van agregando funciones básicas de un sistema operativo como el manejo de tareas, los segmentos del sistema y sus atributos, la asignación de memoria por páginas de 4kb.

Para poder ejecutar estos trabajos se necesita instalar NASM y QEMU.

QEMU ([Guia de uso])
```sh
sudo apt install qemu-system-i386
```

Instalar .deb versión 2.16.01 de [NASM]

---
Resumen de contenidos vistos en la **primera parte** de la materia:

- Programación en C y lenguaje ensamblador intel 64.
- Alineación de datos en memoria.
- Memoria dinámica (uso de stack y heap).
- Convención de llamada C
- Procesamiento en paralelo - SIMD

Resumen de contenidos vistos en la **segunda parte** de la materia:

- Lenguaje ensamblador x86 (32 bits)
- Segmentación - GDT /LDT
- Modo protegido vs modo real
- Interrupciones (Internas, PIC, Excepciones)
- Sistema de paginación (CR3, Direcciones virtuales)
- Implementación de tareas (TSS, Scheduler, TR, Context Switch)

---
### Apuntes

| Resumen | Links |
| ------ | ------ |
|Segmentación y modo protegido | [apuntes/protegidoySegmentacion.pdf][gdt] |
|  Interrupciones | [apuntes/Interrupciones.pdf][int] |
|  Paginación | [apuntes/Paginación.pdf][pag] |
|  Tareas | [apuntes/Tareas.pdf][tareas] |
|  Primera Parte | [apuntes/resumenPrimeraParte.odt][odt] |



[Guia de uso]: <https://github.com/dTaba/Orga-2/blob/main/Recursos/GuiaQemu.pdf>
[NASM]: <https://github.com/dTaba/Orga-2/blob/main/Recursos/nasm_2.16.01-1_amd64.deb>
[gdt]: <https://github.com/dTaba/Orga-2/blob/main/Apuntes/5%20-%20Modo%20Protegido%20y%20Segmentaci%C3%B3n.pdf>
[int]: <https://github.com/dTaba/Orga-2/blob/main/Apuntes/6%20-%20Interrupciones.pdf>
[pag]: <https://github.com/dTaba/Orga-2/blob/main/Apuntes/7%20-%20Paginaci%C3%B3n.pdf>
[tareas]: <https://github.com/dTaba/Orga-2/blob/main/Apuntes/8%20-%20Tareas.pdf>
[odt]: <https://github.com/dTaba/Orga-2/blob/main/Apuntes/resumenPrimeraParte.odt>
