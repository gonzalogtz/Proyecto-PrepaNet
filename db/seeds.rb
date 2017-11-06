# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Usuario.create(cuenta: "T00", nomina_matricula: "A00000000", contrasena: "1", campus: "Monterrey",
                rol: "Tutor", titulo: "", nombres: "David", apellido_p: "Benitez", apellido_m: "Morales",
                correo: "A00000000@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T01", nomina_matricula: "A00000001", contrasena: "1", campus: "Monterrey",
                rol: "Tutor", titulo: "", nombres: "Gonzalo", apellido_p: "Gutierrez", apellido_m: "Sanchez",
                correo: "A00000001@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T02", nomina_matricula: "A00000002", contrasena: "1", campus: "Monterrey",
                rol: "Tutor", titulo: "", nombres: "Armando", apellido_p: "Galvan", apellido_m: "Sanchez",
                correo: "A00000002@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T03", nomina_matricula: "A00000003", contrasena: "1", campus: "Monterrey",
                rol: "Tutor", titulo: "", nombres: "David", apellido_p: "Valles", apellido_m: "Sanchez",
                correo: "A00000003@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T04", nomina_matricula: "A00000004", contrasena: "1", campus: "Monterrey",
                rol: "Coordinador de Tutor", titulo: "", nombres: "Ana Sofia", apellido_p: "Cantu", apellido_m: "Sanchez",
                correo: "A00000004@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T05", nomina_matricula: "A00000005", contrasena: "1", campus: "Monterrey",
                rol: "Tutor", titulo: "", nombres: "José", apellido_p: "Farías", apellido_m: "Martínez",
                correo: "A00000005@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T06", nomina_matricula: "A00000006", contrasena: "1", campus: "Monterrey",
                rol: "Tutor", titulo: "", nombres: "José Abél", apellido_p: "Quezada", apellido_m: "Martinez",
                correo: "A00000006@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T07", nomina_matricula: "A00000007", contrasena: "1", campus: "Monterrey",
                rol: "Tutor", titulo: "", nombres: "Mauro", apellido_p: "Amarante", apellido_m: "Esparza",
                correo: "A00000007@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T08", nomina_matricula: "A00000008", contrasena: "1", campus: "Monterrey",
                rol: "Coordinador de Tutor", titulo: "", nombres: "Natalia", apellido_p: "Garcia", apellido_m: "Garcia",
                correo: "A00000008@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T09", nomina_matricula: "A00000009", contrasena: "1", campus: "Monterrey",
                rol: "Coordinador Prepanet", titulo: "", nombres: "Ana Maria", apellido_p: "Loreto", apellido_m: "Zúñiga",
                correo: "A00000009@itesm.mx", telefono: "8111111111", estatus: "")
                
UsuarioCoordinaUsuario.create(usuario: "T00", coordinador: "T04")
UsuarioCoordinaUsuario.create(usuario: "T01", coordinador: "T04")
UsuarioCoordinaUsuario.create(usuario: "T02", coordinador: "T04")
UsuarioCoordinaUsuario.create(usuario: "T03", coordinador: "T04")
UsuarioCoordinaUsuario.create(usuario: "T05", coordinador: "T08")
UsuarioCoordinaUsuario.create(usuario: "T06", coordinador: "T08")
UsuarioCoordinaUsuario.create(usuario: "T07", coordinador: "T08")
                
Alumno.create(matricula: "A0000004", nombres: "Paloma", apellido_p: "Martinez", apellido_m: "Osuna", 
                telefono: "8111111111", correo: "A0000004@itesm.mx")
Alumno.create(matricula: "A0000005", nombres: "Diana Maria", apellido_p: "Elizalde", apellido_m: "Vilarreal", 
                telefono: "8111111111", correo: "A0000005@itesm.mx")
Alumno.create(matricula: "A0000006", nombres: "Lizette", apellido_p: "Guajardo", apellido_m: "Elizondo", 
                telefono: "8111111111", correo: "A0000006@itesm.mx")
Alumno.create(matricula: "A0000007", nombres: "Gerardo", apellido_p: "Guajardo", apellido_m: "Elizondo", 
                telefono: "8111111111", correo: "A0000007@itesm.mx")
Alumno.create(matricula: "A0000008", nombres: "Gabriel", apellido_p: "Gomez", apellido_m: "Hoyt", 
                telefono: "8111111111", correo: "A0000008@itesm.mx")
Alumno.create(matricula: "A0000009", nombres: "Marcelo", apellido_p: "Lozano", apellido_m: "Madrigal", 
                telefono: "8111111111", correo: "A0000009@itesm.mx")
                
Materia.create(clave: "M00", nombre: "Matematicas I")
Materia.create(clave: "M01", nombre: "Fisica I")
Materia.create(clave: "M02", nombre: "Ingles I")
Materia.create(clave: "M03", nombre: "Historia I")

Curso.create(materia: "Matematicas I", grupo: "PRN.PC4018L.1773.AGS.1", campus: "Campus Aguascalientes", estatus: 1)
Curso.create(materia: "Matematicas II", grupo: "PRN.PC4018L.1773.AGS.2", campus: "Campus Aguascalientes", estatus: 1)
Curso.create(materia: "Matematicas III", grupo: "PRN.PC4018L.1773.AGS.3", campus: "Campus Aguascalientes", estatus: 1)
Curso.create(materia: "Matematicas IV", grupo: "PRN.PC4018L.1773.AGS.4", campus: "Campus Aguascalientes", estatus: 1)

AlumnoCursaMateria.create(alumno: "A0000004", curso: "PRN.PC4018L.1773.AGS.1")
AlumnoCursaMateria.create(alumno: "A0000005", curso: "PRN.PC4018L.1773.AGS.1")
AlumnoCursaMateria.create(alumno: "A0000004", curso: "PRN.PC4018L.1773.AGS.2")
AlumnoCursaMateria.create(alumno: "A0000006", curso: "PRN.PC4018L.1773.AGS.2")
AlumnoCursaMateria.create(alumno: "A0000007", curso: "PRN.PC4018L.1773.AGS.2")
AlumnoCursaMateria.create(alumno: "A0000008", curso: "PRN.PC4018L.1773.AGS.3")
AlumnoCursaMateria.create(alumno: "A0000009", curso: "PRN.PC4018L.1773.AGS.4")

TutorTutoreaMateria.create(tutor: "T00", curso: "PRN.PC4018L.1773.AGS.1")
TutorTutoreaMateria.create(tutor: "T00", curso: "PRN.PC4018L.1773.AGS.2")
TutorTutoreaMateria.create(tutor: "T01", curso: "PRN.PC4018L.1773.AGS.3")
TutorTutoreaMateria.create(tutor: "T01", curso: "PRN.PC4018L.1773.AGS.4")