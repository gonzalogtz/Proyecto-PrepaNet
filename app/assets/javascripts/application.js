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
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

$(document).on('turbolinks:load', function () {
    //activa el popover de notificaciones
    $('[data-toggle="popover"]').popover();
    //activa picker de calendarios
    $('.datetimepicker1').datetimepicker({format: 'YYYY-MM-DD'});
    
    $(".tutor_header").click(function () {
        var index = $(this).attr('id');
        $(".tutor_content" + index).toggle("fast", function () { });
    });
    
    $(".materia_tab").click(function (){
        $(".empty_desemp").hide();
    })

    $(".boton_carousel_reporte_activado").click(function () {
        $(this).closest(".tab-pane").find(".empty_semana").hide();
        id_reporte = $(this).data("link")
        $("#reporte_" + id_reporte).show().siblings().hide();
    });

    function cerrar_alerta() {
        $(".alert").hide()
    };

    $(".alert_close").click(function () {
        cerrar_alerta()
    });

    $("#reporte_quincenal_alumno").change(function () {
        $(event.target).find("option[value='']").attr("disabled", true);
    });

    //Validacion de conglomerado
    $("#conglomerado_semanal_tutor, #conglomerado_semanal_curso").change(function () {
        valida_conglomerado(event)
    });
    
    function valida_conglomerado(event) {
        $(event.target).find("option[value='']").attr("disabled", true);
        $("#btnSubmit").removeAttr("disabled");
        cerrar_alerta()
        
        tutor = $("#conglomerado_semanal_tutor").val();
        curso = $("#conglomerado_semanal_curso").val();
        
        console.log(curso)

        //Solo se llama el servidor si hay un tutor curso seleccionado
        if (tutor && curso) {
            $.ajax({
                type: "POST",
                url: "get_semanales_count",
                dataType: "JSON",
                data: { tutor_id: tutor,
                        curso_id: curso },
                success: function (result) {
                    if (result["tipo_error"] == 1) {
                        $("#alert_text").html("Este tutor aún no tiene los 15 reportes semanales de ese curso. Estos son necesarios para hacer el cálculo de promedio y horas.")
                        $("#btnSubmit").attr("disabled", true);
                        $(".alert").show()
                    }
                    else if (result["tipo_error"] == 2) {
                        $("#alert_text").html("Este tutor ya tiene su conglomerado de reportes semanales para ese curso. Si deseas hacer cambios, puedes entrar a editarlo.")
                        $("#btnSubmit").attr("disabled", true);
                        $(".alert").show()
                    }
                }
            })
        }
    }

    //validacion de reporte semanal
    $("#reporte_semanal_semana, #reporte_semanal_tutor, #reporte_semanal_curso").change(function (event) {
        $(event.target).find("option[value='']").attr("disabled", true);
        $("#btnSubmit").removeAttr("disabled");
        cerrar_alerta()

        tutor = $("#reporte_semanal_tutor").val();
        curso = $("#reporte_semanal_curso").val();
        semana = $("#reporte_semanal_semana").val();

        //Solo se llama el servidor si hay un tutor, curso y semana seleccionado
        if (tutor && semana && curso) {
            $.ajax({
                type: "POST",
                url: "valida_reporte_tutor_curso_semana",
                dataType: "JSON",
                data: {
                    tutor_id: tutor,
                    curso_id: curso,
                    semana: semana
                },
                success: function (result) {
                    if (result["semanal_count"] > 0) {
                        $("#btnSubmit").attr("disabled", true);
                        $(".alert").show()
                    }
                }
            })
        }
    });

    //carga los alumnos por grupo en la forma para reportes quincenales
    $("#reporte_quincenal_curso").change(function (event) {
        $(event.target).find("option[value='']").attr("disabled", true);

        curso = $(this).val();
        $.ajax({
            type: "GET",
            url: "/get_alumnos_by_curso",
            dataType: "JSON",
            data: { curso_id: curso },
            success: function (result) {
                var options = "";

                for (var i = 0; i < result.length; i++) {
                    options += "<option value='" + result[i][0] + "'>" + result[i][1] + "</option>";
                }

                $('#reporte_quincenal_alumno').html(options);
            }
        })
    });
    
    $(".periodo_select").change(function () {
        periodo = $(this).val()
        prefix = $(this).attr('id') //contiene parte del path de la ruta
        $("#periodo_content").load(prefix + "/get_reportes_by_periodo", {periodo_id: periodo}, function(){
            bind_header_clicks() //es necesario hacer este bind para que las acciones de expandir/colapsar funcionen
            bind_boton_reporte_clicks() //para que los botones/popover de los reportes funcionen
            bind_modal_row() //para que sigan abriendo los modales
            reset_filtros_tarjetas_alumnos()
        })
    });

    //carga los cursos por tutor en la forma para reportes semanales
    $("#reporte_semanal_tutor, #conglomerado_semanal_tutor").change(function (event) {
        $(event.target).find("option[value='']").attr("disabled", true);
        
        tutor = $(this).val();
        $.ajax({
            type: "GET",
            url: "/get_cursos_by_tutor",
            dataType: "JSON",
            data: { tutor_id: tutor },
            success: function (result) {
                var options = "";
                
                for (var i = 0; i < result.length; i++) {
                    options += "<option value='" + result[i][0] + "'>" + result[i][1] + "</option>";
                }
                
                if (event.target.id == "reporte_semanal_tutor")
                    $('#reporte_semanal_curso').html(options);
                else {
                    $('#conglomerado_semanal_curso').html(options);
                    valida_conglomerado(event)
                }
            }
        })
    });

    //Validacion de login
    $("#login_button").click(function () {
        usuario = $("#userid").val()
        password = $("#password").val()

        if (usuario == "" && password == "") {
            $("#error_credenciales").html("Favor de proporcionar la clave de usuario y contraseña");
            $("#error_credenciales").show();
            $("#userid").addClass("error_field");
            $("#password").addClass("error_field");
        }
        else if (usuario == "") {
            $("#error_credenciales").html("Favor de proporcionar la clave de usuario");
            $("#error_credenciales").show();
            $("#userid").addClass("error_field");
        }
        else if (password == "") {
            $("#error_credenciales").html("Favor de proporcionar la contraseña");
            $("#error_credenciales").show();
            $("#password").addClass("error_field");
        }
        else {
            $.ajax({
                type: "POST",
                url: "submit_login",
                dataType: "JSON",
                data: {
                    user: usuario,
                    password: password
                },
                success: function (result) {
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
                    else if (result["tipo_error"] == 3) {
                        $("#error_credenciales").html("Este usuario ya no es valido");
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
    $("#cerrar_sesion").click(function () {
        $.ajax({
            type: "GET",
            url: "/logout",
            dataType: "JSON",
            success: function (result) {
                document.location.href = "/"
            }
        })
    });
    
    $("#usuario_cuenta").change(function() {
        $.ajax({
            type: "GET",
            url: "valida_cuenta_disponible",
            dataType: "JSON",
            data: { cuenta: $("#usuario_cuenta").val() },
            success: function (result) {
                if (result["disponible"] == 0) {
                    $(".btnSubmit").attr("disabled", true);
                    $("#cuenta_ocupada").show()
                }
                else if (result["disponible"] == 1){
                    $(".btnSubmit").removeAttr("disabled");
                    $("#cuenta_ocupada").hide()
                }
            }
        })
    });

    $("#userid, #password").focus(function () {
        $("#error_credenciales").hide();
        $("#password, #userid").removeClass("error_field");
    });

    //Carga notificaciones
    $("#notificaciones").focus(function (e) {
        $("#notif_icon").attr("src", "/notification_icon.png");
        document.title = "PrepaNet"
        load_notifications()
    });

    function load_notifications() {
        $.ajax({
            type: "GET",
            url: "/get_notificaciones",
            dataType: "JSON",
            success: function (result) {
                var content = "<table id='notif-table'>"
                if (result.length > 0) {
                    jQuery.each(result, function (i, val) {
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
                    content += "<tr class='empty_notif'>"
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

    function check_num_notificaciones() {
        $.ajax({
            type: "GET",
            url: "/get_num_notificaciones",
            dataType: "JSON",
            success: function (result) {
                if (result > 0) {
                    $("#notif_icon").attr("src", "/new_notification_icon.png");
                    document.title = "(*) PrepaNet"
                }
            }
        })
    } //check_num_notificaciones()

    function diferencia_fecha(fecha) {
        fecha_actual = new Date()

        date1 = Date.UTC(fecha_actual.getFullYear(), fecha_actual.getMonth(), fecha_actual.getDate());
        date2 = Date.UTC(fecha.getFullYear(), fecha.getMonth(), fecha.getDate());
        var ms = Math.abs(date1 - date2);
        diff = Math.floor(ms / 1000 / 60 / 60 / 24);

        if (diff < 1)
            return "Hoy"
        else if (diff < 2)
            return "Ayer"
        else if (diff >= 2)
            return "Hace " + Math.floor(diff) + " días"
    }

    $("#logoPrepa").click(function () {
        window.location = '/mainmenu'
    });
    
    function toggle_arrow_icon(reference_tag) {
        if (reference_tag.find(".arrow_icon").attr("src") == "collapse_arrow.png") {
            reference_tag.find(".arrow_icon").attr("src", "expand_arrow.png");
        }
        else if (reference_tag.find(".arrow_icon").attr("src") == "expand_arrow.png") {
            reference_tag.find(".arrow_icon").attr("src", "collapse_arrow.png");
        }
    }
    
    function bind_header_clicks() {
        $(".reportes_header").click(function () {
            toggle_arrow_icon($(this))
            $(this).siblings(".reportes_content").toggle();
        })
    } bind_header_clicks()
    
    function bind_boton_reporte_clicks() {
        $(".reporte_row, .boton_reporte_activado, .usuario_row").click(function () {
            window.location = $(this).data("link")
        });
        
        //activa tooltips
        $('[data-toggle="tooltip"]').tooltip();
    } bind_boton_reporte_clicks()
    
    function bind_modal_row() {
        $(".periodo_row").click(function () {
            persona = $(this).find('.persona_id_td').data('personaid')
            curso = $(this).find('.curso_td').data('curso')
            prefix = $(this).data('reporte') //contiene parte del path de la ruta
            $(".modal-body").load(prefix + "/get_tarjeta_modal", {persona_id: persona, curso: curso}, function(){
                bind_boton_reporte_clicks()
            })
            $("#modal_tarjeta").modal("show")
        })
    } bind_modal_row()
    
    $("#btnAgregarUsuario").click(function(){
        $("#modal_agregar").modal("show")
    })
    
    $("#toggle_expand_tutor").click(function() {
        toggle_expand_button("Colapsar tutores", "Expandir tutores", ".reportes_tutor_content", $(this))
    });
    
    $("#toggle_expand_grupo").click(function() {
        toggle_expand_button("Colapsar grupos", "Expandir grupos", ".reportes_curso_content", $(this))
    });
    
    $("#toggle_expand_campus").click(function() {
        toggle_expand_button("Colapsar campus", "Expandir campus", ".reportes_campus_content", $(this))
    });
    
    function toggle_expand_button(colapsar_texto, expandir_texto, content_tag, button_tag) {
        if (button_tag.html() == colapsar_texto){
            var nuevo_texto = expandir_texto
            $(content_tag).hide();
            $(content_tag).siblings(".reportes_header").find(".arrow_icon").attr("src", "expand_arrow.png");
        }
        else {
            var nuevo_texto = colapsar_texto
            $(content_tag).show();
            $(content_tag).siblings(".reportes_header").find(".arrow_icon").attr("src", "collapse_arrow.png");
        }
        
        button_tag.html(nuevo_texto)
    }
    
    //filtro en reportes quincenales
    $('#filtro_estatus :checkbox, #filtro_localizado :checkbox').change(function() {
        filtrar_tarjetas_alumnos()
    });
    
    $("#search_bar").on('input', function() {
        filtrar_tarjetas_alumnos()
    });
    
    function reset_filtros_tarjetas_alumnos() {
        $('#filtro_estatus :checkbox').each(function(){
            $(this).prop('checked', true);
        })
        
        $('#filtro_localizado :checkbox').each(function(){
            $(this).prop('checked', true);
        })
        
        $("#search_bar").val("")
    }
    
    function filtrar_tarjetas_alumnos() {
        search_bar = $("#search_bar")
        use_filters = false
        if (search_bar.val())
            var texto = $("#search_bar").val()
        else
            var texto = "*"
        
        if (search_bar.hasClass("quincenal_page")) {
            use_filters = true
        }
        
        if (use_filters) {
            var filtro_estatus = {"-1": 0, "0": 0, "1": 0, "2": 0}
            $('#filtro_estatus :checkbox').each(function(){
                if ($(this).is(":checked"))
                    filtro_estatus[$(this).val()] = 1
            })
            
            filtro_localizado = {"-1": 0, "0": 0, "1": 0}
            $('#filtro_localizado :checkbox').each(function(){
                if ($(this).is(":checked"))
                    filtro_localizado[$(this).val()] = 1
            })
        }
        
        //esconde todas, despues muestra las que tengan la palomita
        $(".tarjeta_col").hide();
        
        //para cada tarjeta...
        $('.tarjeta_col').each(function() {
            if (use_filters) {
                tarjeta_estatus = $(this).find('.estatus').data('estatus')
                tarjeta_localizado = $(this).find('.localizado').data('localizado')
            }
            
            //checa las banderas de los filtros y solo muestra los que tengan ambas prendidas
            if (use_filters && (filtro_estatus[tarjeta_estatus] == 1 && filtro_localizado[tarjeta_localizado] == 1)) {
                //si hay busqueda de texto, tambien tomarlo en cuenta
                if (texto != "*" && $(this).find(".datos_busqueda:caseInsensitiveContains(" + texto + ")").length > 0)
                    $(this).closest(".tarjeta_col").show()
                else if (texto == "*")
                    $(this).closest(".tarjeta_col").show()
            }
            else if(!use_filters) {
                //si hay busqueda de texto, tambien tomarlo en cuenta
                if (texto != "*" && $(this).find(".datos_busqueda:caseInsensitiveContains(" + texto + ")").length > 0)
                    $(this).closest(".tarjeta_col").show()
                else if (texto == "*")
                    $(this).closest(".tarjeta_col").show()
            }
        })
    }
})

//hace el 'click' event para las notificaciones que son generadas despues del load
$(document).on("click", ".notificacion_link", function () {
    window.location = $(this).data("link")

    $.ajax({
        type: "POST",
        url: "/set_notificaciones_leida",
        dataType: "JSON",
        data: { id_notif: $(this).attr('id') }
    })
});

$(document).on("click", ".pop-over_footer", function () {
    $.ajax({
        type: "POST",
        url: "/set_notificaciones_leida",
        dataType: "JSON",
        data: { id_notif: -1 }
    })
});

//agrega la funcion :caseInsensitiveContains
$.extend($.expr[":"], {
    "caseInsensitiveContains": function(elem, i, match, array) {
        return (elem.textContent || elem.innerText || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
    }
});