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

  create_table "alumnos", force: :cascade do |t|
    t.string   "tutor"
    t.string   "nombre"
    t.string   "matricula"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conglomerado_quincenals", force: :cascade do |t|
    t.string   "materia"
    t.string   "tutor"
    t.string   "invito"
    t.string   "rparcial"
    t.string   "rfinal"
    t.text     "resumen"
    t.string   "cierre"
    t.string   "reingresar"
    t.string   "recomendacion"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "calificaciones"
    t.integer  "promedio"
    t.integer  "horas_desemp"
    t.integer  "alumnos_acabaron"
    t.integer  "horas_reportes"
    t.integer  "total_horas"
    t.integer  "total_horas_sugerido"
    t.integer  "coordinador_tutores"
    t.integer  "alumnos_aprobaron"
    t.integer  "alumnos_final_concluyeron"
  end

  create_table "reporte_quincenals", force: :cascade do |t|
    t.string   "estatus"
    t.string   "localizado"
    t.string   "comentarios"
    t.string   "tutor"
    t.string   "alumno"
    t.datetime "fecha"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "reporte_semanals", force: :cascade do |t|
    t.string   "tutor"
    t.integer  "califPlazo"
    t.integer  "califRubrica"
    t.integer  "retro"
    t.integer  "responde"
    t.integer  "errores"
    t.text     "comentarios"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "total"
    t.integer  "semana"
    t.string   "coordinador_tutores"
  end

  create_table "users", force: :cascade do |t|
    t.string   "userid"
    t.string   "password"
    t.string   "campus"
    t.string   "role"
    t.string   "names"
    t.string   "flname"
    t.string   "slname"
    t.string   "email"
    t.string   "phone"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
