require 'test_helper'

class ConglomeradoQuincenalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conglomerado_quincenal = conglomerado_quincenals(:one)
  end

  test "should get index" do
    get conglomerado_quincenals_url
    assert_response :success
  end

  test "should get new" do
    get new_conglomerado_quincenal_url
    assert_response :success
  end

  test "should create conglomerado_quincenal" do
    assert_difference('ConglomeradoQuincenal.count') do
      post conglomerado_quincenals_url, params: { conglomerado_quincenal: { cierre: @conglomerado_quincenal.cierre, invito: @conglomerado_quincenal.invito, materia: @conglomerado_quincenal.materia, recomendacion: @conglomerado_quincenal.recomendacion, reingresar: @conglomerado_quincenal.reingresar, resumen: @conglomerado_quincenal.resumen, rfinal: @conglomerado_quincenal.rfinal, rparcial: @conglomerado_quincenal.rparcial, tutor: @conglomerado_quincenal.tutor } }
    end

    assert_redirected_to conglomerado_quincenal_url(ConglomeradoQuincenal.last)
  end

  test "should show conglomerado_quincenal" do
    get conglomerado_quincenal_url(@conglomerado_quincenal)
    assert_response :success
  end

  test "should get edit" do
    get edit_conglomerado_quincenal_url(@conglomerado_quincenal)
    assert_response :success
  end

  test "should update conglomerado_quincenal" do
    patch conglomerado_quincenal_url(@conglomerado_quincenal), params: { conglomerado_quincenal: { cierre: @conglomerado_quincenal.cierre, invito: @conglomerado_quincenal.invito, materia: @conglomerado_quincenal.materia, recomendacion: @conglomerado_quincenal.recomendacion, reingresar: @conglomerado_quincenal.reingresar, resumen: @conglomerado_quincenal.resumen, rfinal: @conglomerado_quincenal.rfinal, rparcial: @conglomerado_quincenal.rparcial, tutor: @conglomerado_quincenal.tutor } }
    assert_redirected_to conglomerado_quincenal_url(@conglomerado_quincenal)
  end

  test "should destroy conglomerado_quincenal" do
    assert_difference('ConglomeradoQuincenal.count', -1) do
      delete conglomerado_quincenal_url(@conglomerado_quincenal)
    end

    assert_redirected_to conglomerado_quincenals_url
  end
end
