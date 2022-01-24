<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>GCX.GCXCtrl Test Page</title>
</head>
<body>
    <!-- gcx object -->
    <object id="GCXRASCtrl" classid="clsid:1A38A198-B395-4137-A226-F2D8D0A4DFBB" width="680" height="414">
        <param name="P_PaneLayout" value="3" />
    </object>
    <br/>

    <!-- variable -->
    <script language="javascript">
        var ptz_param = {
            "step" : 0,
            "continue" : 1,
        };
    </script>

    <!-- brower callback -->
    <script type="text/javascript">
        window.onload = function () {
            GCXRASCtrl.I_Initialize();
        }
        window.onbeforeunload = function () {
            GCXRASCtrl.I_Finalize();
        }
    </script>

    <!-- methods -->
    <script type="text/javascript">

        var selected_camera = 0;
        function layout_change() {
            var layout = document.getElementById("layout").value;
            GCXRASCtrl.P_PaneLayout = layout;
        }
        function screen_format_change()
        {
            if (GCXRASCtrl.P_IsInit)
            {
                var format = document.getElementById("screen_format").value;
                var ret = GCXRASCtrl.I_SetScreenFormat(format);
            }
        }
        function screen_format_prev()
        {
            if (GCXRASCtrl.P_IsInit)
            {
                var ret = GCXRASCtrl.I_SetScreenFormatPrev();
            }
        }
        function screen_format_next()
        {
            if (GCXRASCtrl.P_IsInit)
            {
                var ret = GCXRASCtrl.I_SetScreenFormatNext();
            }
        }

        function on_btn_select_pane() {
            if (GCXRASCtrl.P_IsInit)
            {
                var pane = document.getElementById("selected_pane").value;
                var ret = GCXRASCtrl.I_SetScreenSelectedPane(pane);
            }
        }
        function on_btn_remove_camera() {
            if (GCXRASCtrl.P_IsInit)
            {
                var pane = document.getElementById("selected_pane").value;
                GCXRASCtrl.I_RemoveCamera(pane);
            }
        }
        function on_btn_remove_device() {
            if (GCXRASCtrl.P_IsInit)
            {
                var pane = document.getElementById("selected_pane").value;
                GCXRASCtrl.I_RemoveDevice(pane);
            }
        }
        function on_btn_connect_watch() {
            if (GCXRASCtrl.P_IsInit)
            {
                var pane              = document.getElementById("selected_pane").value;
                var address_type      = document.getElementById("address_type").value;
                var address           = document.getElementById("address").value;
                var port              = document.getElementById("port").value;
                var user_id           = document.getElementById("user_id").value;
                var password          = document.getElementById("password").value;

                GCXRASCtrl.I_ConnectWatch(pane, address_type, address, port, user_id, password, "");
            }
        }
        function on_btn_connect_search() {
            if (GCXRASCtrl.P_IsInit)
            {
                var pane              = document.getElementById("selected_pane").value;
                var address_type      = document.getElementById("address_type").value;
                var address           = document.getElementById("address").value;
                var port              = document.getElementById("port").value;
                var user_id           = document.getElementById("user_id").value;
                var password          = document.getElementById("password").value;
                var use_unity_port    = document.getElementById("use_unity_port").checked;
                var search_version    = 1;
                var check_device_info = document.getElementById("check_device_info").checked;
                var port_device_check = document.getElementById("port_device_check").value;

                GCXRASCtrl.I_ConnectSearch(pane, address_type, address, port, user_id, password, use_unity_port, search_version, check_device_info, port_device_check, "");
            }
        }
        function on_btn_ptz_command(command) {
            if (GCXRASCtrl.P_IsInit)
            {
                GCXRASCtrl.I_SetPtzCommand(selected_camera, command, ptz_param.step);
            }
        }
        function on_btn_ptz_menu() {
            if (GCXRASCtrl.P_IsInit)
            {
                GCXRASCtrl.I_SetPtzMenu(selected_camera);
            }
        }
        function on_btn_ptz_preset(command) {
            if (GCXRASCtrl.P_IsInit)
            {
                GCXRASCtrl.I_SetPtzPreset(selected_camera, command);
            }
        }
        function on_btn_play() {
        	alert(GCXRASCtrl.P_IsInit);
            if (GCXRASCtrl.P_IsInit)
            {
                GCXRASCtrl.I_Play(selected_camera);
            }
        }
        function on_btn_stop() {
            if (GCXRASCtrl.P_IsInit)
            {
                GCXRASCtrl.I_Stop(selected_camera);
            }
        }
        function on_btn_ff() {
            if (GCXRASCtrl.P_IsInit)
            {
                GCXRASCtrl.I_FastForward(selected_camera);
            }
        }
        function on_btn_rew() {
            if (GCXRASCtrl.P_IsInit)
            {
                GCXRASCtrl.I_Rewind(selected_camera);
            }
        }
        function on_btn_goto() {
            if (GCXRASCtrl.P_IsInit)
            {
                GCXRASCtrl.I_GotoTime(selected_camera, 2015, 7, 29, 17, 0, 0);
            }
        }
        function on_btn_export() {
            if (GCXRASCtrl.P_IsInit)
            {
                GCXRASCtrl.I_ExportClipCopy(selected_camera);
            }
        }

    </script>

    <!-- callback events -->
    <script type="text/javascript">
        function GCXRASCtrl::E_OnUserLogin() {
            alert("E_OnUserLogin");
        }
        function GCXRASCtrl::E_OnUserLoginFailed() {
            alert("E_OnUserLoginFailed");
        }
        function GCXRASCtrl::E_OnUserLogout() {
            alert("E_OnUserLogout");
        }
        function GCXRASCtrl::E_OnConnected(type) {
            var connective = "unknown";
            switch (type)
            {
                case 1: connective = "admin"; break;
                case 2: connective = "monitoring"; break;
                case 3: connective = "live"; break;
                case 4: connective = "play"; break;
                case 5: connective = "watch"; break;
                case 6: connective = "search"; break;
            }
            alert(connective + " connected!");
        }
        function GCXRASCtrl::E_OnDisconnected(type, reason, message) {
            var connective = "Unknown";
            switch (type)
            {
                case 1: connective = "Admin"; break;
                case 2: connective = "Monitoring"; break;
                case 3: connective = "Live"; break;
                case 4: connective = "Play"; break;
                case 5: connective = "watch"; break;
                case 6: connective = "search"; break;
            }
            alert(connective + " disconnected!(" + message + ")");
        }
        function GCXRASCtrl::E_OnLoginCompleted() {
            alert("login completed!");
        }
        function GCXRASCtrl::E_OnEmptyDevice() {
            alert("empty device!");
        }
        function GCXRASCtrl::E_OnChangedSelectedPane(pane) {
            selected_camera = pane;
            document.getElementById("selected_pane").value = pane;
        }
    </script>
	<input type="hidden" id="layout" value="3" />
	<input type="hidden" id="screen_format" value="0" />
	<input type="hidden" id="selected_pane" name="SelectedPane" value="0" />
	<input type="hidden" id="address_type" name="SelectedPane" value="0" />
	<input type="hidden" id="address" name="Address" value="169.254.63.13" />
	<input type="hidden" id="port" name="Port" value="80" />
	<input type="hidden" id="user_id" name="ID" value="admin" />
	<input type="hidden" id="password" name="Password" value="hktqwer12!@" />
	<input type="hidden" id="use_unity_port" name="Use Unity Port" value="3" />
	<input type="hidden" id="check_device_info" name="Check Device" value="3" />
	<input type="hidden" id="port_device_check" name="port_device_check" value="8016" />
	
	<input type="button" value="Play" onclick="on_btn_play();" style="width: 70px" />
	<input type="button" value="Stop" onclick="on_btn_stop();" style="width: 70px" />
   </body>
</html>
