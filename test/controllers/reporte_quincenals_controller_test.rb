require 'test_helper'

class ReporteQuincenalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reporte_quincenal = reporte_quincenals(:one)
  end

  test "should get index" do
    get reporte_quincenals_url
    assert_response :success
  end

  test "should get new" do
    get new_reporte_quincenal_url
    assert_response :success
  end

  test "should create reporte_quincenal" do
    assert_difference('ReporteQuincenal.count') do
      post reporte_quincenals_url, params: { reporte_quincenal: { alumno: @reporte_quincenal.alumno, comentarios: @reporte_quincenal.comentarios, estatus: @reporte_quincenal.estatus, fecha: @reporte_quincenal.fecha, localizado: @reporte_quincenal.localizado, tutor: @reporte_quincenal.tutor } }
    end

    assert_redirected_to reporte_quincenal_url(ReporteQuincenal.last)
  end

  test "should show reporte_quincenal" do
    get reporte_quincenal_url(@reporte_quincenal)
    assert_response :success
  end

  test "should get edit" do
    get edit_reporte_quincenal_url(@reporte_quincenal)
    assert_response :success
  end

  test "should update reporte_quincenal" do
    patch reporte_quincenal_url(@reporte_quincenal), params: { reporte_quincenal: { alumno: @reporte_quincenal.alumno, comentarios: @reporte_quincenal.comentarios, estatus: @reporte_quincenal.estatus, fecha: @reporte_quincenal.fecha, localizado: @reporte_quincenal.localizado, tutor: @reporte_quincenal.tutor } }
    assert_redirected_to reporte_quincenal_url(@reporte_quincenal)
  end

  test "should destroy reporte_quincenal" do
    assert_difference('ReporteQuincenal.count', -1) do
      delete reporte_quincenal_url(@reporte_quincenal)
    end

    assert_redirected_to reporte_quincenals_url
  end
end
