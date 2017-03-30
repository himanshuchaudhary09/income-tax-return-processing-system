
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<%
    Connection conn = null;
    Statement st = null;
    ResultSet result = null;
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
    response.setHeader("Cache-Control", "no-store"); //HTTP 1.1
    String id = null;
    id = (String) session.getAttribute("ID");
    if (id != null) {
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >        
        <title>Change Password - Secure Data Storage in Cloud</title>
        <link href="css/style.css" rel="stylesheet" type="text/css">
       <script type="text/javascript">
	   // this java script function is used to validate the old and the new password entered by the user
            function checkform(){
                
                var opwd = document.getElementById('txtopwd');
				//this if condition is used to initially trim the input text type to null and then alert the user to input the old password 
                if(opwd.value.trim() == ""){
                    alert('Please enter your old password');
                    opwd.focus();
                    return false;                    
                }
                var pwd = document.getElementById('txtpwd');
				//this if condition is used to initially trim the input text type to null and then alert the user to input the new password
                if(pwd.value.trim() == ""){
                    alert('Please enter your new password');
                    pwd.focus();
                    return false;                    
                }
                var cpwd = document.getElementById('txtcpwd');
                if(cpwd.value.trim() == ""){
                    alert('Please enter your retype password');
                    cpwd.focus();
                    return false;                    
                }
				//this if condition is used to check if the new password re-entered by the user matches the new password
                if(pwd.value.trim() != cpwd.value.trim()){
                    alert('Your retype password does not matched with new password.');
                    cpwd.focus();
                    return false;                     
                }
            }
        </script>
        <script type="text/javascript">
            function CheckOldPwd()
            {
                //alert('called');
                var xmlHttpRequest=init();

                function init()
                {
                    if (window.XMLHttpRequest){
                        return new XMLHttpRequest();
                    }
                    else if (window.ActiveXObject){
                        return new ActiveXObject("Microsoft.XMLHTTP");
                    }
                }

                var oldpwd=document.getElementById('txtopwd').value.trim();
                if(oldpwd == ""){
                    return false;
                }
                //alert(oldpwd);

                xmlHttpRequest.open("POST", "changePwd?oldpwd="+escape(oldpwd),true);
                xmlHttpRequest.onreadystatechange=processRequest;
                xmlHttpRequest.send(null);

                function processRequest()
                {
                    if(xmlHttpRequest.readyState==4)
                    {
                        if(xmlHttpRequest.status==200)
                        {
                            processResponse();
                        }
                    }
                }
				//the process response javascript function is used to check if the old password entered by the user actually matches the previous password for his/her profile
                function processResponse()
                {
                    var xmlMessage=xmlHttpRequest.responseXML;
                    var pwd=xmlMessage.getElementsByTagName("sname")[0].firstChild.nodeValue;
                    //alert(pwd);
                    if(pwd != oldpwd)
                    {
                        alert("Old Password is Wrong. !! Please, Retry");
                        document.getElementById('txtopwd').value = "";
                        document.getElementById('txtopwd').focus();
                        return false;
                    }

                }
            }


        </script>
    </head>
    <body>
        <table  cellspacing="0" cellpadding="0" align="center" border="0" class="body_content">          

            <%@include file="header.jsp" %>
            <tr>
                <td valign="top">
                    <%@include file="leftmenu.jsp" %> 
                </td>
                <td valign="top" style="border-left: dotted 1px darkgreen;height: 500px;width: 750px;">
                   <table style="padding-left: 10px;" cellpadding="5" cellspacing="0" width="100%">
                        <tr>
                            <td>
                                <h1>Change Password</h1>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <form action="changePwd" method="post" name="change password">
                                    <table cellpadding="5" cellspacing="5" width="100%">
                                        <%
                                            String msg = null;
                                            msg = (String) session.getAttribute("MSG");
                                            if (msg != null) {
                                        %>
                                        <tr>
                                            <td colspan="2" align="center">
                                                <div style="width:100%;color: #3278A3; font-size: 12px;font-weight: bold;" align="center"><%=msg%></div>
                                            </td>
                                        </tr>
                                        <%
                                                session.removeAttribute("MSG");
                                            } else {
                                                session.setAttribute("MSG", "");

                                            }
                                        %>
                                        <tr>
                                            <td>
                                                <b>Old Password <span class="mandetory"> *</span>:</b>
                                            </td>
                                            <td>
                                                <input type="password" name="txtopwd" id="txtopwd"  class="inputbox" onblur="CheckOldPwd();"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b>New Password <span class="mandetory"> *</span>:</b>
                                            </td>
                                            <td>
                                                <input type="password" name="txtpwd" id="txtpwd"  class="inputbox"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b>Retype&nbsp;Password<span class="mandetory">&nbsp;*</span>:</b>
                                            </td>
                                            <td>
                                                <input type="password" name="txtcpwd" id="txtcpwd"  class="inputbox"/>
                                            </td> 
                                        </tr>
                                        <tr>                                            
                                            <td colspan="2" align="right">
                                                <input type="submit" name="btnsubmit" id="btnsubmit" value="Change Now" onclick="return checkform();" class="button"/>                                                
                                            </td>
                                            <td width="50%">&nbsp;</td>
                                        </tr>
                                    </table>
                                </form>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr> 
            <tr>
                <td colspan="3" width="100%" class="footer">
                    <%@include file="footer.html" %>
                </td>
            </tr>
        </table>

    </body>
</html>
<%    } else {
        session.setAttribute("MSG", "You must be login.");
        response.sendRedirect("login.jsp");
    }
%>