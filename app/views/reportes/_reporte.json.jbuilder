json.extract! reporte, :id, :titulo, :descripcion, :created_at, :updated_at
json.url reporte_url(reporte, format: :json)
