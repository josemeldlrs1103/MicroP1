# UUID GENERATOR

_El identificador único universal es un número de 128 bits generado de forma aleatoria, su repressentación estándar está conformada por dígitos hexadecimales, cuenta con 32 caracteres separados por guiones cumpliendo algunas normas._

## Enunciado del Proyecto 📋

(Parte 1)
_-Existen diferentes técnicas para generar la aleatoriedad, una de ellas está basada en la fecha y hora actual y la mac address del equipo_
_-En este caso deberá utilizar interrupciones para obtener la fecha y hora actual del equipo y generar un timespan a partir de ello y utilizarlo en la generación de un nuevo UUID._
_-Como no se tiene acceso a la mac address del equipo deberá seguir las siguientes reglas:
	-El grupo de los cuatro bits más significativos del séptimo byte deberá iniciar siempre con “1”
	-El segundo grupo de bits más significativo deberá iniciar con un número aleatorio entre 8,9,A o B en hexadecimal._
```
CCBC9B3B-8805-1979-A6E2-C554EED9F9C7
```
-La aplicación deberá contar con la opción de generar uno o varios UUIDs.

(Parte 2)
_El generador de UUIDs también deberá contar con un área de validación, la expresión regular utilizada para validar un UUID es la siguiente:_

```
^[0-9A-F]{8}-[0-9A-F]{4}-[1][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$

```
_Así que además de generar UUIDs, el usuario podrá ingresar uno y el programa deberá mostrar si es válido o no._


## Generación del programa 🔧

_Para la ejecución del programa se necesita trabajar sobre un sistema operativo windows de 32 bits._
_El primer paso a realizar es abrir la consola del sistema operativo_

```
windows+r -> en la ventana que se abre escribir "cmd" y luego presionar enter
```

_dirigirse a la ubicación en la que se encuentra el archivo ".asm" de la solución. (se requiere que los ejecutbles "TASM" y "TLINK" se encuentren en la misma ubicación._

```
cd (dirección del archivo)
```
_compilar el archivo con el ejecutable "TASM"._

```
TASM (nombre del archivo).asm
```
_Generar un ejecutable con "TLINK"_

```
TLINK (nombre del archivo).obj
```
_Ejecutar el programa_

```
(nombre del archivo).exe
```

## Uso del Programa 📦

_Ingrese el número de la opción según el menú principal_

```
1-Generación de UUID
2-Validación de UUID
3-Salir del programa
```
Si elige la opción 1 el programa imprime en pantalla la cadena UUID
```
670B9562-B30D-12D5-B827-655787665500  (Ejemplo)
```
Si elige la opción 2 el programa esperará que la ingrese uno a uno los caracteres de la cadena UUID. Si el caracater ingresado es aceptado se espera al siguiente caracter a ingresar. Si todos los caracteres ingresados son válidos el programa indica en pantalla que el identificador es válido y retorna al menú.
```
670B9562-B3
-------------------------------
Identificador UUID aceptado
```
Si el caracter  ingresado no es válido, el programa indica que la cadena no es válida y retorna al menú
```
Caracter no permitido en UUID
```
Para cerrar el programa debe elegir la opción 3.Si ingresa un número distinto a los de las opciones listadas el programa imprime el menú nuevamente.

## Construido con 🛠️
* Notepad++ - Editor de texto
* Turbo Assembler "TASM" - Ensamblador

## Autores ✒️

* **José Eduardo Meléndez De la Rosa** [josemeldlrs1103](https://github.com/josemeldlrs1103)
* **Carlo Antonio Velásquez Villegas** [CarloAVV](https://github.com/CarloAVV)