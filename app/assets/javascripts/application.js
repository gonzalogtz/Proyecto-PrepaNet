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
    //activa el popover de notificaciones
    $('[data-toggle="popover"]').popover();
    //activa tooltips
    $('[data-toggle="tooltip"]').tooltip(); 

    $(".tutor_header").click(function() {
        var index = $(this).attr('id');
        $(".tutor_content" + index).toggle( "fast", function() {});
    });
    
    $(".reporte_row, .boton_reporte_activado").click(function() {
        window.location = $(this).data("link")
    });
    
    function cerrar_alerta(){
        $(".alert").hide()
    };
    
    $(".alert_close").click(function() {
        cerrar_alerta()
    });
    
    $("#reporte_quincenal_alumno").change(function(){
        $(event.target).find("option[value='']").attr("disabled", true);
    });
    
    //Validacion de conglomerado
    $("#conglomerado_semanal_tutor").change(function(){
        $(event.target).find("option[value='']").attr("disabled", true);
        $("#btnSubmit").removeAttr("disabled");
        cerrar_alerta()

        $.ajax({
            type: "POST",
            url: "get_semanales_count",
            dataType: "JSON",
            data: {tutor_id: $("#conglomerado_semanal_tutor").val()},
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
        usuario = $("#userid").val()
        password = $("#password").val()
        
        if (usuario == "" && password == "") {
            $("#error_credenciales").html("Favor de proporcionar la clave de usuario y contraseña");
            $("#error_credenciales").show();
            $("#userid").addClass("error_field");
            $("#password").addClass("error_field");
        }
        else if(usuario == ""){
            $("#error_credenciales").html("Favor de proporcionar la clave de usuario");
            $("#error_credenciales").show();
            $("#userid").addClass("error_field");
        }
        else if (password == ""){
            $("#error_credenciales").html("Favor de proporcionar la contraseña");
            $("#error_credenciales").show();
            $("#password").addClass("error_field");
        }
        else{
            $.ajax({
                type: "POST",
                url: "submit_login",
                dataType: "JSON",
                data: {user: usuario,
                        password: password},
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
                        document.location.href = "/mainmenu"
                    }
                }
            })
        }
    });
    
    //Logout
    $("#cerrar_sesion").click(function(){
        $.ajax({
            type: "GET",
            url: "/logout",
            dataType: "JSON",
            success: function(result) {
                document.location.href = "/"
            }
        })
    });
    
    $("#userid, #password").focus(function(){
        $("#error_credenciales").hide();
        $("#password, #userid").removeClass("error_field");
    });
    
    //Carga notificaciones
    $("#notificaciones").focus(function(e) {
        $("#notif_icon").attr("src", "/notification_icon.png");
        document.title = "PrepaNet"
        load_notifications()
    });
    
    function load_notifications(){
        $.ajax({
            type: "GET",
            url: "/get_notificaciones",
            dataType: "JSON",
            success: function(result) {
                var content = "<table id='notif-table'>"
                if (result.length > 0){
                    jQuery.each(result, function(i, val) {
                        content += "<tr class='notificacion_row notificacion_link' data-link='" + val["liga"] + "' id='" + val["id"] + "'>"
                        if (val["leida"] == 1) content += "<td>"; else content += "<td class='no_leida'>"
                        content += "<p class='notificacion_mensaje'>" + val["mensaje"] + "</p>"
                        var parsed_date = new Date(val["created_at"])
                        content += "<p class='notificacion_fecha'>" + diferencia_fecha(parsed_date) + "</p>"
                        content += "</td>"
                        content += "</tr>"
                    });
                }
                else {
                    content += "<tr class='notificacion_row'>"
                    content += "<td>"
                    content += "<p class='notificacion_mensaje'>Aún no tienes notificaciones</p>"
                    content += "</td>"
                    content += "</tr>"
                }
                
                content += "</table>"
                content += "<div class='pop-over_footer'>Marcar todas como leídas</div>"
                $('.popover-content').html(content)
            }
        })
    }
    
    function check_num_notificaciones(){
        $.ajax({
            type: "GET",
            url: "/get_num_notificaciones",
            dataType: "JSON",
            success: function(result) {
                if (result > 0){
                    $("#notif_icon").attr("src", "/new_notification_icon.png" );
                    document.title = "(*) PrepaNet"
                }
            }
        })
    }
    
    check_num_notificaciones()
    
    function diferencia_fecha(fecha) {
        fecha_actual = new Date()
        var diff = new Date(fecha_actual - fecha)
        diff = diff/1000/60/60/24
        
        if (diff < 1)
            return "Hoy"
        else if (diff < 2)
            return "Ayer"
        else if (diff >= 2)
            return "Hace " + diff.floor() + " días"
    }
    
    $(".tutor_reportes_header").click(function(){
        var index = $(this).attr('id');
        $(".content_" + index).toggle();
    })
    
    $("#logoPrepa").click(function(){
        window.location = '/mainmenu'
    });
})

//hace el 'click' event para las notificaciones que son generadas despues del load
$(document).on("click", ".notificacion_link", function() {
    window.location = $(this).data("link")
    
    $.ajax({
        type: "POST",
        url: "/set_notificaciones_leida",
        dataType: "JSON",
        data: {id_notif: $(this).attr('id')}
    })
});

$(document).on("click", ".pop-over_footer", function() {
    $.ajax({
        type: "POST",
        url: "/set_notificaciones_leida",
        dataType: "JSON",
        data: {id_notif: -1}
    })
});