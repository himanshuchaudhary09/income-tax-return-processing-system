

<%@page import="Analayse.com.datumbox.opensource.classifiers.NaiveBayes"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<%    Connection conn = null;
    Statement st = null;
    ResultSet result = null;
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
    response.setHeader("Cache-Control", "no-store"); //HTTP 1.1
    String id = null;
    int positive = 0, negative = 0, neutral = 0;
    id = (String) session.getAttribute("ID");
    if (id != null) {
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >        
        <title>User List - </title>
        <link href="css/style.css" rel="stylesheet" type="text/css">   
         <script src="http://code.jquery.com/jquery-latest.js">   
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
                                <h1>Feedback Analysis</h1>
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
                                            <td align="center">User Name</td>                                           
                                            <td align="center">Feedback</td>                                          
                                            <td align="center">Dated</td>
                                            <td align="center">Analysis</td>

                                        </tr>
                                        <%                                            int i = 0;
										//This block will fetch the feedback data from the table and will further update the records in the database according to the inputs of the user.
                                            try {
                                                NaiveBayes nb = DB.NavieBayesClassifier.load();

                                                String fuserid = request.getParameter("fuserid");
                                                conn = DB.Connect.openConnection();
                                                String query = "SELECT * FROM tblfeedback WHERE  fuserid ='" + fuserid + "'";
                                                st = conn.prepareStatement(query);
                                                result = st.executeQuery(query);

                                                while (result.next()) {
                                                    String sid = result.getString("fid");
                                                    String userid = result.getString("userid");
                                                    String feedback = result.getString("feedback");
                                                    String rdate = result.getString("rdate");
                                                    String sql = "select fname,lname from tbluser where userid='" + userid + "'";
                                                    Statement st1 = conn.prepareStatement(sql);
                                                    ResultSet rs1 = st1.executeQuery(sql);
                                                    String name = "";
                                                    if (rs1.next()) {
                                                        name = rs1.getString("fname") + " " + rs1.getString("lname");
                                                    }
                                                    String preprocessed_texts = DB.NavieBayesClassifier.preProcessTexts(feedback);
                                                    String output = nb.predict(preprocessed_texts);
                                                    if (output.equals("positive")) {
                                                        positive++;
                                                    } else if (output.equals("negative")) {
                                                        negative++;

                                                    } else if (output.equals("neutral")) {
                                                        neutral++;
                                                    }

                                                    i++;
                                        %>
                                        <tr bgcolor="#f9f9f9">
                                            <td align="center"><%=i%>.</td>
                                            <td><%=name%></td>                                           

                                            <td align="center"><%=feedback%></td>
                                            <td align="center"><%=rdate%></td>
                                            <td align="center"><%=output.toUpperCase()%></td>


                                        </tr>
                                        <%    }

                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }

                                        %>
                                    </table>
                                    <%    out.println("<table><tr><td>");
                                        out.println("<script type='text/javascript' src='css/jsapi.js'>"
										//here a pie chart graph is made according to the enteries given by the user to indicate other users to select a particular user.
                                                + "</script> <script type='text/javascript'>"
                                                + "google.load('visualization', '1.0', {'packages':['corechart']});"
                                                + " google.setOnLoadCallback(drawChart); function drawChart() "
                                                + "{ var data = new google.visualization.DataTable(); data.addColumn('string', 'Topping');"
                                                + "  data.addColumn('number', 'Feedback');  data.addRows([ ['Positive'," + positive + "],['Negative', " + negative + "],['Neutral'," + neutral + "]  ]);"
                                                + "  var options = {'title':'Graph', 'width':350,'height':250,'radius':20};"
                                                + " var chart = new google.visualization.PieChart(document.getElementById('chart_div'));"
                                                + "chart.draw(data, options);}</script><div id='chart_div'></div>");
                                        out.println("</td><tr></table>");
                                    %>
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