

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >        
        <title>Login - Income Tax Return</title>
        <link href="css/style.css" rel="stylesheet" type="text/css">
        <script type="text/javascript">
            function checkform(){
                var uname = document.getElementById('txtuname');
                if(uname.value.trim() == ""){
                    alert('Please enter your email id');
                    uname.focus();
                    return false;                    
                }
                var pwd = document.getElementById('txtpwd');
                if(pwd.value.trim() == ""){
                    alert('Please enter your password');
                    pwd.focus();
                    return false;                    
                }
            }
        </script>
    </head>
    <body>
        <table  cellspacing="0" cellpadding="0" align="center" border="0" class="body_content">          

             <%@include file="header.html" %>
            <tr>
                <td width="950"  height="500" valign="top" style="padding-left: 10px;padding-right: 10px;">
                    <table align="center" cellpadding="0" cellspacing="0">
                        <tr valign="middle">
                            <td width="670" height="500" style="border-right: solid 1px #232323;" valign="top">
                                <table style="padding-left: 10px;" cellpadding="5" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <h1>Login</h1>                                
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <form action="login" method="post">
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
                                                        <td width="20%">
                                                            <b>Email&nbsp;ID:</b>
                                                        </td>
                                                        <td>
                                                            <input type="text" name="txtuname" id="txtuname" class="inputbox"/>
                                                        </td>                                            
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <b>Password:</b>
                                                        </td>
                                                        <td>
                                                            <input type="password" name="txtpwd" id="txtpwd"  class="inputbox"/>
                                                        </td>                                            
                                                    </tr> 
                                                    <tr>
                                                        <td colspan="2" align="right">
                                                            <input type="submit" name="btnlogin" id="btnlogin" value="Login" onclick="return checkform();" class="button"/>                                                
                                                        </td>
                                                        <td width="42%">&nbsp;</td>
                                                    </tr>
                                                </table>
                                            </form>
                                        </td>

                                    </tr>
                                </table>
                            </td>
                            <td width="300" valign="top">

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
