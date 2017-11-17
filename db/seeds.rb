# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#################### USUARIOS ####################
#################### tutores ####################
Usuario.create(cuenta: "T00", nomina_matricula: "A00000000", contrasena: "1", campus: "Campus Monterrey",
                rol: "Tutor", titulo: "", nombres: "David", apellido_p: "Benitez", apellido_m: "Morales",
                correo: "A00000000@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T01", nomina_matricula: "A00000001", contrasena: "1", campus: "Campus Monterrey",
                rol: "Tutor", titulo: "", nombres: "Gonzalo", apellido_p: "Gutierrez", apellido_m: "Sanchez",
                correo: "A00000001@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T02", nomina_matricula: "A00000002", contrasena: "1", campus: "Campus Monterrey",
                rol: "Tutor", titulo: "", nombres: "Armando", apellido_p: "Galvan", apellido_m: "Sanchez",
                correo: "A00000002@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T03", nomina_matricula: "A00000003", contrasena: "1", campus: "Campus Monterrey",
                rol: "Tutor", titulo: "", nombres: "David", apellido_p: "Valles", apellido_m: "Sanchez",
                correo: "A00000003@itesm.mx", telefono: "8111111111", estatus: "")
                
#################### coordinadores de tutores ####################
Usuario.create(cuenta: "T04", nomina_matricula: "A00000004", contrasena: "1", campus: "Campus Monterrey",
                rol: "Coordinador de Tutores", titulo: "", nombres: "Ana Sofia", apellido_p: "Cantu", apellido_m: "Sanchez",
                correo: "A00000004@itesm.mx", telefono: "8111111111", estatus: "")
Usuario.create(cuenta: "T05", nomina_matricula: "A00000008", contrasena: "1", campus: "Campus Monterrey",
                rol: "Coordinador de Tutores", titulo: "", nombres: "Natalia", apellido_p: "Garcia", apellido_m: "Garcia",
                correo: "A00000008@itesm.mx", telefono: "8111111111", estatus: "")
                
#################### coordinadores de campus ####################
Usuario.create(cuenta: "T06", nomina_matricula: "L00000009", contrasena: "1", campus: "Campus Monterrey",
                rol: "Coordinador Prepanet Campus", titulo: "", nombres: "Ana Maria", apellido_p: "Loreto", apellido_m: "Zúñiga",
                correo: "A00000009@itesm.mx", telefono: "8111111111", estatus: "")
                
#################### coordinador informatica ####################
Usuario.create(cuenta: "T07", nomina_matricula: "L00000010", contrasena: "1", campus: "Campus Monterrey",
                rol: "Coordinador Informatica Prepanet", titulo: "", nombres: "Tron", apellido_p: "Loreto", apellido_m: "Zúñiga",
                correo: "A00000009@itesm.mx", telefono: "8111111111", estatus: "")
                
#################### coordinador nacional ####################
Usuario.create(cuenta: "T08", nomina_matricula: "L00000011", contrasena: "1", campus: "Campus Monterrey",
                rol: "Director Prepanet Nacional", titulo: "", nombres: "Big Boss", apellido_p: "Loreto", apellido_m: "Zúñiga",
                correo: "A00000009@itesm.mx", telefono: "8111111111", estatus: "")

#################### ALUMNOS ####################
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
                
#################### MATERIAS (NO USADA) ####################
Materia.create(clave: "M00", nombre: "Matematicas I")
Materia.create(clave: "M01", nombre: "Fisica I")
Materia.create(clave: "M02", nombre: "Ingles I")
Materia.create(clave: "M03", nombre: "Historia I")

#################### CURSOS ####################
Curso.create(materia: "Matematicas I", tutor: "T00", coordinador_tutores: "T04", grupo: "PRN.PC4018L.1773.MTY.1", campus: "Campus Monterrey", periodo: 1)
Curso.create(materia: "Matematicas II", tutor: "T00", coordinador_tutores: "T04", grupo: "PRN.PC4018L.1773.MTY.2", campus: "Campus Monterrey", periodo: 1)
Curso.create(materia: "Matematicas III", tutor: "T01", coordinador_tutores: "T04",  grupo: "PRN.PC4018L.1773.MTY.3", campus: "Campus Monterrey", periodo: 1)
Curso.create(materia: "Matematicas IV", tutor: "T02", coordinador_tutores: "T04",  grupo: "PRN.PC4018L.1773.MTY.4", campus: "Campus Monterrey", periodo: 1)

#################### RELACION ALUMNO - CURSO ####################
AlumnoTomaCurso.create(alumno: "A0000004", curso: "PRN.PC4018L.1773.MTY.1")
AlumnoTomaCurso.create(alumno: "A0000005", curso: "PRN.PC4018L.1773.MTY.1")
AlumnoTomaCurso.create(alumno: "A0000004", curso: "PRN.PC4018L.1773.MTY.2")
AlumnoTomaCurso.create(alumno: "A0000006", curso: "PRN.PC4018L.1773.MTY.2")
AlumnoTomaCurso.create(alumno: "A0000007", curso: "PRN.PC4018L.1773.MTY.2")
AlumnoTomaCurso.create(alumno: "A0000008", curso: "PRN.PC4018L.1773.MTY.3")
AlumnoTomaCurso.create(alumno: "A0000009", curso: "PRN.PC4018L.1773.MTY.4")

#################### REPORTES SEMANALES ####################
for i in 1..15
    ReporteSemanal.create(coordinador_tutores: "T04", tutor: "T00", curso: "PRN.PC4018L.1773.MTY.1", campus: "Campus Monterrey", 
                    semana: i, califica_en_plazo: 1, califica_con_rubrica: 1, da_retroalimentacion: 1,
                    responde_mensajes: 1, errores_ortografia: 1, calificacion_total: 5, comentarios: "", periodo: 1)
end