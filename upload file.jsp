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
        <title>Upload File </title>
        <link href="css/style.css" rel="stylesheet" type="text/css">
        <script type="text/javascript">// THE FUNCTION BELOW IS USED TO VALIDATE THE FORM AT THE TIME OF SUBMIT THIS FUNCTION IS CALLED
            function checkform(){
                
                var password = document.getElementById('txtpassword');
                if(password.value.trim() == ""){
                    alert('Please enter your file password.');
                    password.focus();
                    return false;                    
                }
                
                var filename = document.getElementById('txtfname');
                if(filename.value.trim() == ""){
                    alert('Please enter your file name.');
                    filename.focus();
                    return false;                    
                }
                var path = document.getElementById('txtfile');
                if(path.value.trim() == ""){
                    alert('Please select your file.');
                    path.focus();
                    return false;                    
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
                                <h1>Upload File</h1>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <form action="uploadFile" method="post" enctype="multipart/form-data">
                                    <table cellpadding="5" cellspacing="5">
                                        <%
                                            String msg = null;
                                            msg = (String) session.getAttribute("MSG");
                                            if (msg != null) {
                                        %>
                                        <tr>
                                            <td colspan="4" align="center">
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
                                                Select CA
                                            </td>
                                            <td>
                                                <select name="fuserid">
                                                    <option value="none">Select CA</option>
                                               
                                                <%
                                             conn = DB.Connect.openConnection();
                                                  String query = "SELECT userid,fname,lname FROM tbluser WHERE  usertype IN ('ca') and status='True'";
                                                st = conn.prepareStatement(query);
                                                result = st.executeQuery(query);
                                                while (result.next()) {
                                                out.println("<option value='"+result.getString("userid")+"'>"+result.getString("fname")+" "+result.getString("lname")+"</option>");
                                                }conn.close();
                                                
                                                %>
                                                 </select>
                                            </td>
                                        </tr>
                                        <tr>                                            
                                            <td>
                                                <b>File Password:</b>
                                            </td>
                                            <td>
                                                <input type="password" name="txtpassword" id="txtpassword" class="inputbox"/>
                                            </td> 
                                        </tr> 
                                        <tr>                                            
                                            <td>
                                                <b>File Name:</b>
                                            </td>
                                            <td>
                                                <input type="text" name="txtfname" id="txtfname" class="inputbox"/>
                                            </td> 
                                        </tr>                                        
                                        <tr>                                            
                                            <td>
                                                <b>Upload File:</b>
                                            </td>
                                            <td>
                                                <input type="file" name="txtfile" id="txtfile" size="20" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td  align="center" colspan="2">
                                                <input type="submit" name="btnsubmit" id="btnsubmit" value="Submit" onclick="return checkform();" class="button"/>
                                                <input type="reset" name="btnreset" id="btnreset" value="Reset" class="button"/>
                                            </td>
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
