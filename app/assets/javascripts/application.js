// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
    $(".tutor_header").click(function() {
        var index = $(this).attr('id');
        console.log(index)
        $(".tutor_content" + index).toggle( "fast", function() {});
    });
    
    $(".reporte_row").click(function() {
        window.location = $(this).data("link")
    });
    
    function cerrar_alerta(){
        $(".alert").hide()
    };
    
    $(".alert_close").click(function() {
        cerrar_alerta()
    });
    
    //Validacion de conglomerado
    $("#conglomerado_quincenal_tutor").change(function(){
        $(event.target).find("option[value='']").attr("disabled", true);
        $("#btnSubmit").removeAttr("disabled");
        cerrar_alerta()

        $.ajax({
            type: "POST",
            url: "get_semanales_count",
            dataType: "JSON",
            data: {tutor_id: $("#conglomerado_quincenal_tutor").val()},
            success: function(result) {
                if (result["tipo_error"] == 1) {
                    $("#alert_text").html("Este tutor no tiene 15 semanales")
                    $("#btnSubmit").attr("disabled", true);
                    $(".alert").show()
                }
                else if (result["tipo_error"] == 2){
                    $("#alert_text").html("Este tutor ya tiene reporte")
                    $("#btnSubmit").attr("disabled", true);
                    $(".alert").show()
                }
            }
        })
    });
    
    //validacion de reporte semanal
    $("#reporte_semanal_semana, #reporte_semanal_tutor").change(function(event){
        $(event.target).find("option[value='']").attr("disabled", true);
        $("#btnSubmit").removeAttr("disabled");
        cerrar_alerta()

        tutor = $("#reporte_semanal_tutor").val();
        semana = $("#reporte_semanal_semana").val();
        
        //Solo se llama el servidor si hay un tutor Y semana seleccionado
        if (tutor != "" && semana != ""){
            $.ajax({
                type: "POST",
                url: "valida_tutor_semana",
                dataType: "JSON",
                data: {tutor_id: tutor,
                        semana: semana},
                success: function(result) {
                    if (result["semanal_count"] > 0){
                        $("#btnSubmit").attr("disabled", true);
                        $(".alert").show()
                    }
                }
            })
        }
    });
    
    //Validacion de login
    $("#login_button").click(function(){
        $.ajax({
            type: "POST",
            url: "submit_login",
            dataType: "JSON",
            data: {user: $("#userid").val(),
                    password: $("#password").val()},
            success: function(result) {
                //contraseña incorrecta
                if (result["tipo_error"] == 1) {
                    $("#error_credenciales").html("Contraseña incorrecta");
                    $("#error_credenciales").show();
                    $("#password").addClass("error_field");
                }
                //usuario incorrecto
                else if (result["tipo_error"] == 2) {
                    $("#error_credenciales").html("Usuario inexistente");
                    $("#error_credenciales").show();
                    $("#userid").addClass("error_field");
                }
                //credenciales correctas
                else {
                    document.location.href = "/conglomerado_quincenals"
                }
            }
        })
    });
    
    $("#userid, #password").focus(function(){
        $("#error_credenciales").hide();
        $("#password, #userid").removeClass("error_field");
    });
})