

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
        <title>My Account </title>
        <link href="css/style.css" rel="stylesheet" type="text/css">
        <script type="text/javascript">
		//this javascript function is used to validate all the input values entered by the user
            function checkform(){
                var enrno = document.getElementById('txtfname');
				//this if condition is used to validate if the firstname is entered by the user or not
                if(enrno.value.trim() == ""){
                    alert('Please enter your first name.');
                    enrno.focus();
                    return false;                    
                }
                var name = document.getElementById('txtlname');
				//this if condition is used to validate if the lastname is entered by the user or not
                if(name.value.trim() == ""){
                    alert('Please enter your last name.');
                    name.focus();
                    return false;                    
                }
                
                var dob = document.getElementById('txtdob');
				//this if condition is used to validate if the date of birth is entered by the user or not
                if(dob.value.trim() == ""){
                    alert('Please enter your date of birth.');
                    dob.focus();
                    return false;                    
                }
                var gender = document.getElementById('cmbgender');
				//this if condition is used to validate if the gender is entered by the user or not
                if(gender.value.trim() == "na"){
                    alert('Please select your gender.');
                    gender.focus();
                    return false;                    
                }
                var email = document.getElementById('txtemail');
				//this if condition is used to validate if the email address is entered by the user or not
                if(email.value.trim() == ""){
                    alert('Please enter your email id.');
                    email.focus();
                    return false;                    
                }
                var contno = document.getElementById('txtcontno');
				//this if condition is used to validate if the contact number is entered by the user or not
                if(contno.value.trim() == ""){
                    alert('Please select your contact no.');
                    contno.focus();
                    return false;                    
                }
                
            }
        </script>
        <script type="text/javascript" src="js/scw.js"></script>
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
                                <h1>User Account</h1>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <form action="myAccount" method="post">
                                    <table cellpadding="5" cellspacing="5" width="100%">
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
                                        <%

                                            int i = 0;
                                            try {
                                                String userid=request.getParameter("fuserid");
                                                conn = DB.Connect.openConnection();
                                                String query = "SELECT fname,lname,mobile_no,emailid,address FROM tbluser WHERE userid='" + userid + "'";
                                                st = conn.prepareStatement(query);
                                                result = st.executeQuery(query);
                                                if (result.next()) {

                                                    String fname = result.getString(1);
                                                    String lname = result.getString(2);
                                                  
                                                    String contno = result.getString(3);
                                                    String email = result.getString(4);
                                                   
                                                    String location = result.getString(5);
                                                 

                                                    i++;
                                        %>
                                        <tr>
                                            <td width="20%">
                                                <b>First Name:<span class="mandetory">&nbsp;</span>:</b>
                                            </td>
                                            <td>
                                           
                                              <%=fname%>
                                            </td>
                                            <td width="20%">
                                                <b>Last Name <span class="mandetory"> </span>:</b>
                                            </td>
                                            <td>
                                              <%=lname%>
                                            </td>                                            
                                        </tr>
                                        <tr>
                                             <td width="20%">
                                                <b>Contact No. <span class="mandetory"> </span>:</b>
                                            </td>
                                            <td>
                                             <%=contno%>
                                            </td>
                                         
                                                 <td width="20%">
                                                <b>Email&nbsp;ID<span class="mandetory">&nbsp;</span>:</b>
                                            </td>
                                            <td>
                                              <%=email%>
                                            </td>
                                        </tr>
                                        <tr>
                                           
                                          
                                            <td width="20%">
                                                <b>Location:</b>
                                            </td>
                                            <td>
                                              <%=location%>
                                            </td>
                                        </tr>
                                       

                                        <%    }

                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
 finally{
                                            conn.close();
                                            }

                                        %>
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

    