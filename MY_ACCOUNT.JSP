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
        <link href="css/style.css" rel="stylesheet" type="text/css">//this page is giving refrence of style.css which is the style sheet file of the pages.
        <script type="text/javascript">
            function checkform(){
                var enrno = document.getElementById('txtfname');
                if(enrno.value.trim() == ""){
                    alert('Please enter your first name.');
                    enrno.focus();
                    return false;                    
                }
                var name = document.getElementById('txtlname');
                if(name.value.trim() == ""){
                    alert('Please enter your last name.');
                    name.focus();
                    return false;                    
                }
                
           
               
                var email = document.getElementById('txtemail');
                if(email.value.trim() == ""){
                    alert('Please enter your email id.');
                    email.focus();
                    return false;                    
                }
                var contno = document.getElementById('txtcontno');
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

            <%@include file="header.jsp" %>// including header.html file which contains home login and registration links available on each page.
            <tr>
                <td valign="top">
                    <%@include file="leftmenu.jsp" %> // including the leftmenu.jsp file which contains the links for various options which user can select like myccount,chat,myfiles etc this leftmenu.jsp will be included in every page.
                </td>
                <td valign="top" style="border-left: dotted 1px darkgreen;height: 500px;width: 750px;">
                    <table style="padding-left: 10px;" cellpadding="5" cellspacing="0" width="100%">
                        <tr>
                            <td>
                                <h1>My Account</h1>
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
                                                conn = DB.Connect.openConnection();
                                                String query = "SELECT fname,lname,mobile_no,emailid,address FROM tbluser WHERE userid='" + id + "'";
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
                                                <b>First Name:<span class="mandetory">&nbsp;*</span>:</b>
                                            </td>
                                            <td>
                                                <input type="hidden" name="hidid" id="hidid"  value="<%=id%>"/>
                                                <input type="text" name="txtfname" id="txtfname" class="inputbox" value="<%=fname%>"/>
                                            </td>
                                            <td width="20%">
                                                <b>Last Name <span class="mandetory"> *</span>:</b>
                                            </td>
                                            <td>
                                                <input type="text" name="txtlname" id="txtlname" class="inputbox"  value="<%=lname%>"/>
                                            </td>                                            
                                        </tr>
                                        <tr>
                                             <td width="20%">
                                                <b>Contact No. <span class="mandetory"> *</span>:</b>
                                            </td>
                                            <td>
                                                <input type="number" name="txtcontno" id="txtcontno" class="inputbox"  value="<%=contno%>" maxlength="10" min="7000000000" max="9999999999"/>
                                            </td>
                                         
                                                 <td width="20%">
                                                <b>Email&nbsp;ID<span class="mandetory">&nbsp;*</span>:</b>
                                            </td>
                                            <td>
                                                <input type="email" name="txtemail" id="txtemail" class="inputbox"  value="<%=email%>"/>
                                            </td>
                                        </tr>
                                        <tr>
                                           
                                          
                                            <td width="20%">
                                                <b>Location:</b>
                                            </td>
                                            <td>
                                                <input type="text" name="txtlocation" id="txtlocation" class="inputbox" value="<%=location%>"/>
                                            </td>
                                        </tr>
                                       

                                        <tr>  
                                            <td colspan="2"><span class="mandetory">*</span> Marked fields are mandatory.</td>
                                            <td colspan="2" align="right">
                                                <input type="submit" name="btnsubmit" id="btnsubmit" value="Update" onclick="return checkform();" class="button"/>
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

    