require 'test_helper'

class ReporteSemanalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reporte_semanal = reporte_semanals(:one)
  end

  test "should get index" do
    get reporte_semanals_url
    assert_response :success
  end

  test "should get new" do
    get new_reporte_semanal_url
    assert_response :success
  end

  test "should create reporte_semanal" do
    assert_difference('ReporteSemanal.count') do
      post reporte_semanals_url, params: { reporte_semanal: { califPlazo: @reporte_semanal.califPlazo, califRubrica: @reporte_semanal.califRubrica, comentarios: @reporte_semanal.comentarios, errores: @reporte_semanal.errores, responde: @reporte_semanal.responde, retro: @reporte_semanal.retro, tutor: @reporte_semanal.tutor } }
    end

    assert_redirected_to reporte_semanal_url(ReporteSemanal.last)
  end

  test "should show reporte_semanal" do
    get reporte_semanal_url(@reporte_semanal)
    assert_response :success
  end

  test "should get edit" do
    get edit_reporte_semanal_url(@reporte_semanal)
    assert_response :success
  end

  test "should update reporte_semanal" do
    patch reporte_semanal_url(@reporte_semanal), params: { reporte_semanal: { califPlazo: @reporte_semanal.califPlazo, califRubrica: @reporte_semanal.califRubrica, comentarios: @reporte_semanal.comentarios, errores: @reporte_semanal.errores, responde: @reporte_semanal.responde, retro: @reporte_semanal.retro, tutor: @reporte_semanal.tutor } }
    assert_redirected_to reporte_semanal_url(@reporte_semanal)
  end

  test "should destroy reporte_semanal" do
    assert_difference('ReporteSemanal.count', -1) do
      delete reporte_semanal_url(@reporte_semanal)
    end

    assert_redirected_to reporte_semanals_url
  end
end
