
package org;

import DB.SMSSender;
import DB.SimpleEmail;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name = "Register", urlPatterns = {"/register"})
public class Register extends HttpServlet {

    static Connection con = null;
    PreparedStatement pst = null;
    ResultSet rst = null;
    String fname = null;
    String lname = null;
    String dob = null;
    String username = null;
    String email = null;
    String contno = null;
    String location = null;
    String city = null;
    String pwd = null;
    int i = 0;

     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        HttpSession session = request.getSession(true);
		//this try block contains a sql query which allows the admin to delete a particular user  
        try {
            con = DB.Connect.openConnection();
            String query = "UPDATE tbluser SET status='False' WHERE userid= '" + id + "' ";
            pst = con.prepareStatement(query);
            i = pst.executeUpdate();

        } catch (Exception e) {
        }
		//this if condition checks if the variable 'i' contains some values after deleting a particular user from the table and if the vaue comes out to be more than 1 then a message will be shown that the user has successfuly been deleted or else it will print the user is not deleted   
        if (i > 0) {
            session.setAttribute("MSG", "User has been successfuly deleted !!");
            response.sendRedirect("userlist.jsp");
        } else {
            session.setAttribute("MSG", "User has not been deleted !!");
            response.sendRedirect("userlist.jsp");
        }
    }
    
    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        PrintWriter out = response.getWriter();
        response.setContentType("text/html");
        ServletConfig config = getServletConfig();
        String context = config.getServletContext().getRealPath("/");

        //connection from database
        try {
            con = DB.Connect.openConnection();
        } catch (Exception e) {
        }


        fname = request.getParameter("txtfname");
        lname = request.getParameter("txtlname");
        username = request.getParameter("txtusername");
        dob = request.getParameter("txtdob");
        email = request.getParameter("txtemail");
        contno = request.getParameter("txtcontno");
        location = request.getParameter("txtlocation");
        city = request.getParameter("txtcity");
       Random ran = new Random();
String code= Integer.toString(100000 + ran.nextInt(999999));

System.out.println("code="+code);
		//this try block contains a query which either sends an email or a sms with login details after the admin registers the CA.
        try {
            i=DB.Connect.saveUsers(fname, lname, username, email, location, "True", "user", code, contno);
DB.SimpleEmail email1=new SimpleEmail();
   email1.setMailServerProperties();
            email1.createEmailMessage("Registration Successfull","Your password is: "+code, email);
            email1.sendEmail();               
            String value= SMSSender.SMSSender("onlinefood", "You have successfully registered in Income tax. Your Login id is: "+email+" and password is:"+code , "FOODAP",contno, "167019f3-3fcb-423c-80ef-f7b51237c644");
   System.out.println("message sent: "+value);
        } catch (Exception e) {
            e.printStackTrace();;
        }

        //success or failure message to show if the CA was successfully registered or not
        if (i > 0) {

            session.setAttribute("MSG", "Your register form has been successfully submited.Please check your mail id");
            response.sendRedirect("register.jsp");
        } else {
            session.setAttribute("MSG", "Your register form has not been submited.");
            response.sendRedirect("register.jsp");
        } 


    }
}
