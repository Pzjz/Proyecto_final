from conecxion import *
from tabulate import *

connection = connect("localhost","root","","biblioteca")
cursor = connection.cursor()

crearAlmacenadoLibro = """CREATE PROCEDURE almacena_libro (id INT,nombreLibro VARCHAR (50),autor VARCHAR (50),cantidad INT)
INSERT INTO libros (id,nombreLibro,autor,cantidad) VALUES (id,nombreLibro,autor,cantidad)"""

crearAlmacenadoUsuario = """CREATE PROCEDURE almacena_usuario (cedula INT,nombre VARCHAR (50),apellido VARCHAR (50),libro INT)
INSERT INTO usuarios (cedula,nombre,apellido,libro) VALUES (cedula,nombre,apellido,libro)"""

borrarALmacenadoUsuario = """CREATE PROCEDURE borrar_usuario (IN cedulaIngresa INT)
DELETE FROM usuarios WHERE cedula = cedulaIngresa"""

print("==============================")
print("==============================")
print("------------ADMIN-------------")
print("==============================")
print("")
cont = False

while cont != True:
    print("")
    print("1. Ingresa libro")
    print("2. Prestar libro")
    print("3. Devolver libro")
    print("4. Vista de los libros")
    print("5. Vista usuarios")
    print("0. Salir")
    print("")
    eleccion = int(input(""))
    
    if eleccion == 1:
        id = int(input("Ingrese ID: "))
        nombreLibro = input("Ingresa nombre del libro: ")
        autor = input("Ingrese el autor: ")
        cantidad = int(input("Ingrese cantidad de libros: "))
        run_AlmacenadoLIbro = "CALL almacena_libro(%s,%s,%s,%s)"
        values = (id,nombreLibro,autor,cantidad)
        cursor.execute(run_AlmacenadoLIbro,values)

    if eleccion == 2:
        cedula = int(input("Ingrese cedula: "))
        nombre = input("Ingresa nombre: ")
        apellido = input("Ingrese apellido: ")
        libro = int(input("Ingrese ID de libro: "))
        run_AlmacenadoUsuario = "CALL almacena_usuario(%s,%s,%s,%s)"
        valuesUsuario = (cedula,nombre,apellido,libro)
        cursor.execute(run_AlmacenadoUsuario,valuesUsuario)

    if eleccion == 3:
        cedulaElimina = int(input("Ingresar cedula: "))
        cursor.callproc('borrar_usuario',(cedulaElimina,))

    if eleccion == 4:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM libros")

            data = cursor.fetchall()

            print(tabulate(data,headers=["ID del libro","Nombre del libro","Autor","Cantidad de libros"],tablefmt="grid"))
        print("")
        cont = True

    if eleccion == 5:
        with connection.cursor() as cursor:
            cursor.execute("SELECT cedula,nombre,apellido,nombreLibro,autor FROM usuarios INNER JOIN libros ON usuarios.libro = libros.id")

            data = cursor.fetchall()

            print(tabulate(data,headers=["Cedula","Nombre","Apellido","Nombre del libro","Autor"],tablefmt="grid"))
        print("")
        cont = True

    if eleccion == 0:
        cont = True

connection.commit()
connection.close()
cursor.close()
cursor.close()