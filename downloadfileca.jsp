
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<%    Connection conn = null;
    Statement st = null;
    Statement st1 = null;
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
        <title>Download Files - Secure Data Storage in Cloud</title>
        <link href="css/style.css" rel="stylesheet" type="text/css">  
        <script type="text/javascript">
			//this function will fetch the xmlHttpRequest
            function Downloadfile(fileid) {

                var xmlHttpRequest = init();

                function init()
                {
                    if (window.XMLHttpRequest) {
                        return new XMLHttpRequest();
                    }
                    else if (window.ActiveXObject) {
                        return new ActiveXObject("Microsoft.XMLHTTP");
                    }
                }

                var pwd = prompt("Enter your password here : ", "");
                if (pwd == "") {
                    return false;
                }

                xmlHttpRequest.open("POST", "decryption?fileid=" + escape(fileid) + "&pwd=" + escape(pwd), true);
                xmlHttpRequest.onreadystatechange = processRequest;
                xmlHttpRequest.send(null);

                function processRequest()
                {
                    if (xmlHttpRequest.readyState == 4)
                    {
                        if (xmlHttpRequest.status == 200)
                        {
                            processResponse();
                        }
                    }
                }
				//the function to prompt the user to upload a file.
                function processResponse()
                {
                    var xmlMessage = xmlHttpRequest.responseXML;
                    var res = xmlMessage.getElementsByTagName("sname")[0].firstChild.nodeValue;
                    // alert(res);
                    if (res != "res") {
                        var value = "uploadfiles/" + res;
                        window.open(value, "_blank");
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
                                <h1>Download Files</h1>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">



                                <div style="height: 500px; width: 100%;overflow: auto;">
                                    <table cellpadding="3" cellspacing="3" width="100%">
                                        <%
                                            String msg = null;
                                            msg = (String) session.getAttribute("MSG");
                                            if (msg != null) {
                                        %>
                                        <tr>
                                            <td colspan="5" align="center">
                                                <div style="width:100%;color: #3278A3; font-size: 12px;font-weight: bold;" align="center"><%=msg%></div>
                                            </td>
                                        </tr>
                                        <%
                                                session.removeAttribute("MSG");
                                            } else {
                                                session.setAttribute("MSG", "");

                                            }
                                        %>

                                        <tr class="heading_lable">
                                            <td align="center">S.No</td>                                            
                                            <td align="center">File Description</td>
                                            <td align="center">Adding Date</td>                                                                                
                                            <td align="center">Status</td>                                            
                                            <td align="center">User NAME</td>   
                                            <td align="center">Download</td>      
                                            <td align="center">Select Status</td>                                            
                                            <td align="center">Update Status</td>                                            

                                        </tr>
                                        <%
                                            int i = 0;
											//connection with the database and fetching the required data from the particular user.
                                            try {
                                                conn = DB.Connect.openConnection();
                                                String query = "SELECT id,filename,filepath,adding_date,status,userid FROM tblfiles WHERE fuserid='" + id + "'";
                                                st = conn.prepareStatement(query);
                                                result = st.executeQuery(query);
                                                while (result.next()) {
                                                    String fileid = result.getString(1);
                                                    String fname = result.getString(2);
                                                    String filepath = result.getString(3);
                                                    String adding_date = result.getString(4);
                                                    String status = result.getString("status");
                                                    String fuserid = result.getString("userid");
                                                    String sql = "select * from tbluser where userid='" + fuserid + "'";
                                                    st1 = conn.prepareStatement(sql);
                                                    ResultSet rs = st1.executeQuery(sql);
                                                    String caname = "";
                                                    if (rs.next()) {
                                                        caname = rs.getString("fname") + " " + rs.getString("lname");
                                                    }
                                                    i++;
                                        %>
                                        <form action="updateFile" method="get">
                                            <tr bgcolor="#f9f9f9">
                                                <td align="center"><%=i%>.</td>
                                                <td><%=fname%></td> 
                                                <td align="center"><%=adding_date%>.</td>
                                                <td align="center"><%=status%>.</td>

                                                <td align="center">
                                                    <%
                                                        out.print("<a href='useraccount.jsp?fuserid=" + fuserid + "'>" + caname + "</a>");
                                                        out.print("<br><a href='single_message.jsp?fuserid=" + fuserid + "' title='Click to chat details'>Chat</a>");

                                                    %> 

                                                </td>
                                                <td align="center">
													//this will prompt the CA to download file
                                                    <span onclick="Downloadfile('<%=fileid%>');" class="cursor">Download</span>

                                                </td>
                                            <input type="hidden" name="id" value="<%=fileid%>">
                                            <td align="center">
                                                <select name="status">
                                                    <option value="none">Select File Status</option>
                                                    <option value="Approve">Approve</option>
                                                    <option value="Complete">Complete</option>
                                                    <option value="Document Missing">Document Missing</option>
                                                </select>
                                            </td>

                                            <td align="center">
                                                <input type="submit" value="Update Status">
                                            </td>

                                            </tr>

                                        </form>
                                        <%    }

                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            } finally {
                                                conn.close();
                                            }

                                        %>
                                    </table>

                                </div>
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
