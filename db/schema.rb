# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171022223115) do
  
  create_table "usuarios", force: :cascade do |t|
    t.string   "cuenta"
    t.string   "nomina_matricula"
    t.string   "contrasena"
    t.string   "campus"
    t.string   "rol"
    t.string   "titulo"
    t.string   "nombres"
    t.string   "apellido_p"
    t.string   "apellido_m"
    t.string   "correo"
    t.string   "telefono"
    t.string   "estatus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  
  create_table "usuario_coordina_usuarios", force: :cascade do |t|
    t.string   "usuario"
    t.string   "coordinador"
  end
  
  create_table "alumnos", force: :cascade do |t|
    t.string   "matricula"
    t.string   "nombres"
    t.string   "apellido_p"
    t.string   "apellido_m"
    t.string   "telefono"
    t.string   "correo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
  
  create_table "materias", force: :cascade do |t|
    t.string   "clave"
    t.string   "nombre"
  end
  
  create_table "cursos", force: :cascade do |t|
    t.string   "materia"
    t.string   "grupo"
    t.string   "campus"
    t.integer  "estatus"
  end
  
  create_table "alumno_cursa_materias", force: :cascade do |t|
    t.string   "alumno"
    t.string   "curso"
  end
  
  create_table "tutor_tutorea_materias", force: :cascade do |t|
    t.string   "tutor"
    t.string   "curso"
  end
  
  create_table "notificaciones", force: :cascade do |t|
    t.string   "usuario"
    t.string   "mensaje"
    t.string   "liga"
    t.integer  "leida"
    t.datetime "created_at", null: false
  end

  create_table "conglomerado_semanals", force: :cascade do |t|
    t.string   "coordinador_tutores"
    t.string   "tutor"
    t.string   "curso"
    t.integer  "invitacion_asesorias"
    t.integer  "reporte_parcial"
    t.integer  "reporte_final"
    t.integer  "actividad_cierre"
    t.integer  "recomendacion_reingreso"
    t.integer  "recomendacion_coordinador"
    t.text     "comentarios"
    t.string   "calificaciones_semanales"
    t.integer  "promedio"
    t.integer  "horas_desempeno_semanal"
    t.integer  "horas_reportes"
    t.integer  "total_horas"
    t.integer  "total_horas_sugerido"
    t.integer  "alumnos_original_acabaron"
    t.integer  "alumnos_original_aprobaron"
    t.integer  "alumnos_final_concluyeron"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "reporte_quincenals", force: :cascade do |t|
    t.string   "tutor"
    t.string   "alumno"
    t.string  "curso"
    t.integer  "estatus"
    t.integer  "localizado"
    t.text     "comentarios"
    t.datetime "fecha_correspondiente"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reporte_semanals", force: :cascade do |t|
    t.string   "coordinador_tutores"
    t.string   "tutor"
    t.string   "curso"
    t.integer  "semana"
    t.integer  "califica_en_plazo"
    t.integer  "califica_con_rubrica"
    t.integer  "da_retroalimentacion"
    t.integer  "responde_mensajes"
    t.integer  "errores_ortografia"
    t.integer  "calificacion_total"
    t.text     "comentarios"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end
end