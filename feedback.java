
package org;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.http.HttpSession;

@WebServlet(name = "Feedback", urlPatterns = {"/feedback"})
public class Feedback extends HttpServlet {

    String fuserid = null;
    String userid = null;
    String feedback = null;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		//fetching the session using a session id and the userids and feedback from the users,
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(true);
        userid = session.getAttribute("ID").toString();
        fuserid = request.getParameter("fuserid");
        feedback = request.getParameter("feedback");
        try {
		//used to fetch the deedback and upload on the database and check if it was sent or not.
            int i = DB.Connect.saveFeedback(feedback, fuserid, userid);
            if (i > 0) {
                session.setAttribute("MSG", "Feedback sent successfully");
                response.sendRedirect("giveFeedback.jsp");
            } else {
                session.setAttribute("MSG", "Failed to send Feedback");
                response.sendRedirect("giveFeedback.jsp");
            }

        } catch (Exception e) {
            session.setAttribute("MSG", "Failed to send Feedback");
            response.sendRedirect("giveFeedback.jsp");
        }
    }
}
