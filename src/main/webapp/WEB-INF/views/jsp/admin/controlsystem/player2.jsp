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

    <!-- test controls -->
    <div>
        <div>
            Layout :
            <select id="layout" onchange="layout_change()" style="width:100px;">
                <option value="0">Screen</option>
                <option value="1">Control</option>
                <option value="3" selected>All</option>
            </select>
            / Screen Format :
            <select id="screen_format" onchange="screen_format_change()" style="width:60px;">
                <option value="0">1x1</option>
                <option value="1">2x2</option>
                <option value="2">3x3</option>
                <option value="3">4x3</option>
                <option value="4">4x4</option>
                <option value="5">5x4</option>
                <option value="6">5x5</option>
                <option value="7" selected>32P</option>
                <option value="8">6x6</option>
                <option value="9">7x7</option>
                <option value="10">8x8</option>
            </select>
            <input type="button" value="Prev" onclick="screen_format_prev();" style="width: 50px" />
            <input type="button" value="Next" onclick="screen_format_next();" style="width: 50px" />
            / Selected Pane:
            <input type="text" id="selected_pane" name="SelectedPane" value="0" size="2" readonly/>
        </div>
        <div>
            <table border="0" cellpadding="0" cellspacing="0" style="margin-top: 10px; width: 678px;">
                <tr>
                    <td valign="top" style="width: 1140px; height: 120px;">
                        &nbsp;Address Type&nbsp;&nbsp;:
                        <select id="address_type" style="width: 60px">
                         <option value="0">IPV4</option>
                         <option value="1">DVRNS</option>
                        </select><br />
                        &nbsp;Address&nbsp;&nbsp;:
                        <input type="text" id="address" name="Address" value="169.254.63.13" style="width: 70px" /><br />
                        &nbsp;Port&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
                        <input type="text" id="port" name="Port" value="80" style="width: 70px" /><br />
                        &nbsp;User ID&nbsp;&nbsp;&nbsp;&nbsp;:
                        <input type="text" id="user_id" name="ID" value="admin" style="width: 71px" /><br />
                        &nbsp;Password:
                        <input type="password" id="password" name="Password" value="hktqwer12!@" style="width: 69px" /><br />
                        &nbsp;Use Unity Port:
                        <input type="checkbox" id="use_unity_port" name="Use Unity Port" value="3" style="width: 20px" checked/>
                        &nbsp;Check Device:
                        <input type="checkbox" id="check_device_info" name="Check Device" value="3" style="width: 20px" checked/>
                        &nbsp;Port Device_Check(Watch):
                        <input type="text" id="port_device_check" name="port_device_check" value="8016" style="width: 45px" align="right"/><br />
                    </td>
                    <td valign="top" style="width: 230px; height: 120px;">

                        <input type="button" value="connect watch" onclick="on_btn_connect_watch();" style="width: 135px" />
                        <input type="button" value="connect search" onclick="on_btn_connect_search();" style="width: 135px" />
                        <input type="button" value="remove camera" onclick="on_btn_remove_camera();" style="width: 135px" />
                        <input type="button" value="remove device" onclick="on_btn_remove_device();" style="width: 135px" />
                    </td>
                    <td style="width: 174px; height: 120px;">
                        <!-- ptz move //-->
                        <table border="0" cellpadding="0" cellspacing="0" style="width: 34px; height: 49px">
                        <tr>
                            <td style="height: 24px"><input type="button" name="ptz_nw" value="↖" onclick="on_btn_ptz_command(7)" style="width:30px"></td>
                            <td style="height: 24px"><input type="button" name="ptz_n" value="↑" onclick="on_btn_ptz_command(0)" style="width:30px"></td>
                            <td style="height: 24px"><input type="button" name="ptz_ne" value="↗" onclick="on_btn_ptz_command(1)" style="width:30px"></td>
                        </tr>
                        <tr>
                            <td style="height: 24px"><input type="button" name="ptz_w" value="←" onclick="on_btn_ptz_command(6)" style="width:30px"></td>
                            <td style="height: 24px"></td>
                            <td style="height: 24px"><input type="button" name="ptz_e" value="→" onclick="on_btn_ptz_command(2)" style="width:30px"></td>
                        </tr>
                        <tr>
                            <td><input type="button" name="ptz_sw" value="↙" onclick="on_btn_ptz_command(5)" style="width:30px"></td>
                            <td><input type="button" name="ptz_s" value="↓" onclick="on_btn_ptz_command(4)" style="width:30px"></td>
                            <td><input type="button" name="ptz_se" value="↘" onclick="on_btn_ptz_command(3)" style="width:30px"></td>
                        </tr>
                        </table>
                    </td>
                    <td style="width: 196px; height: 120px;">
                        <table border="0" cellpadding="0" cellspacing="0" style="width: 34px; height: 49px">
                        <tr>
                            <td><input type="button" name="zoom_in" value="Z+" onclick="on_btn_ptz_command(9)" style="width:30px"></td>
                            <td><input type="button" name="focus_near" value="F+" onclick="on_btn_ptz_command(10)" style="width:30px"></td>
                            <td><input type="button" name="iris_open" value="I+" onclick="on_btn_ptz_command(13)" style="width:30px"></td>
                            <td><input type="button" name="ptz_preset_move" value="Pv" onclick="on_btn_ptz_preset(14)" style="width:30px"></td>
                        </tr>
                        <tr>
                            <td><input type="button" name="zoom_out" value="Z-" onclick="on_btn_ptz_command(8)" style="width:30px"></td>
                            <td><input type="button" name="focus_far" value="F-" onclick="on_btn_ptz_command(11)" style="width:30px"></td>
                            <td><input type="button" name="iris_close" value="I-" onclick="on_btn_ptz_command(12)" style="width:30px"></td>
                            <td><input type="button" name="ptz_preset_set" value="Ps" onclick="on_btn_ptz_preset(15)" style="width:30px"></td>
                        </tr>
                        <tr>
                            <td><input type="button" name="auto_focus" value="AF" onclick="on_btn_ptz_command(52)" style="width:30px"></td>
                            <td colspan="2"><input type="button" name="ptz_menu" value="menu" onclick="on_btn_ptz_menu()" style="width:60px"></td>
                        </tr>
                        </table>
                    </td>
                    <td style="width: 1101px; height: 120px;">
                        <input type="button" value="Play" onclick="on_btn_play();" style="width: 70px" />
                        <input type="button" value="Stop" onclick="on_btn_stop();" style="width: 70px" />
                        <br />
                        <input type="button" value="FF" onclick="on_btn_ff();" style="width: 70px" />
                        <input type="button" value="Rew" onclick="on_btn_rew();" style="width: 70px" />
                        <br />
                        <input type="button" value="Goto" onclick="on_btn_goto();" style="width: 70px" />
                        <input type="button" value="Export" onclick="on_btn_export();" style="width: 70px" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
