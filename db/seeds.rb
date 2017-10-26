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
                
Alumno.create(matricula: "A0000004", nombres: "Paloma", apellido_p: "Martinez", apellido_m: "Osuna", 
                telefono: "8111111111", correo: "A0000004@itesm.mx")
Alumno.create(matricula: "A0000005", nombres: "Diana", apellido_p: "Elizalde", apellido_m: "Martinez", 
                telefono: "8111111111", correo: "A0000005@itesm.mx")
Alumno.create(matricula: "A0000006", nombres: "Lizette", apellido_p: "Guajardo", apellido_m: "Elizondo", 
                telefono: "8111111111", correo: "A0000006@itesm.mx")
Alumno.create(matricula: "A0000007", nombres: "Gerardo", apellido_p: "Guajardo", apellido_m: "Elizondo", 
                telefono: "8111111111", correo: "A0000007@itesm.mx")
                
Materia.create(clave: "M00", nombre: "Matematicas I")
Materia.create(clave: "M01", nombre: "Fisica I")
Materia.create(clave: "M02", nombre: "Ingles I")
Materia.create(clave: "M03", nombre: "Historia I")

Curso.create(clave_materia: "M00", grupo: 1)
Curso.create(clave_materia: "M01", grupo: 1)
Curso.create(clave_materia: "M02", grupo: 1)
Curso.create(clave_materia: "M03", grupo: 1)

AlumnoCursaMateria.create(tutor: "T00", alumno: "A0000004", curso: "M00")
AlumnoCursaMateria.create(tutor: "T00", alumno: "A0000005", curso: "M00")
AlumnoCursaMateria.create(tutor: "T00", alumno: "A0000006", curso: "M00")
AlumnoCursaMateria.create(tutor: "T00", alumno: "A0000007", curso: "M00")