package org;
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
import static org.Register.con;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.*;

@WebServlet(name = "UploadFile", urlPatterns = {"/uploadFile"})
public class UploadFile extends HttpServlet {

    static Connection con = null;
    PreparedStatement pst = null;
    ResultSet rst = null;
    String filename = null;
    String fuserid = null;
    String file_name = null;
    String password = null;
    String fullImagepath = null;
    String count = null;
    String upload_filepath = null;
    String uploadfile = null;
    boolean flag;
    int i = 0;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        HttpSession session = request.getSession(true);//will return current session. If current session does not exist, then it will create a new session.

        try {
            con = DB.Connect.openConnection();
            String queryname = "SELECT id,filename,filepath,adding_date FROM tblfiles WHERE id='" + id + "'";
            PreparedStatement st = con.prepareStatement(queryname);
            ResultSet result = st.executeQuery(queryname);
            if (result.next()) {
                String fname = result.getString("filepath");
                ServletConfig config = getServletConfig();
                String context = config.getServletContext().getRealPath("/");
                String filePath = context + "uploadfiles" + File.separator + fname;

                File f = new File(filePath);
                f.delete();
                System.out.println("file deleted");
            }
            String query = "DELETE from tblfiles WHERE id= '" + id + "' ";
            pst = con.prepareStatement(query);
            i = pst.executeUpdate();

        } catch (Exception e) {
        }

        if (i > 0) {
            session.setAttribute("MSG", "File has been successfuly deleted !!");
            response.sendRedirect("downloadfile.jsp");
        } else {
            session.setAttribute("MSG", "File has not been deleted !!");
            response.sendRedirect("downloadfile.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        String uid = (String) session.getAttribute("ID");//storing the session id
        PrintWriter out = response.getWriter();
        response.setContentType("text/html");
        ServletConfig config = getServletConfig();
        String context = config.getServletContext().getRealPath("/");

        //connection from database
        try {
            con = DB.Connect.openConnection();
        } catch (Exception e) {
        }

        String filePath = context + "uploadfiles";

        boolean status = false;

        java.util.Date d = new java.util.Date();
        long timestamp = d.getTime();

        try {
            File projectDir = new File(filePath);
            if (!projectDir.exists()) {
                projectDir.mkdirs();

            }
        } catch (Exception e) {
            System.out.println("kslkf: " + e);
            e.printStackTrace();
        }

        boolean isMultipart = ServletFileUpload.isMultipartContent(new ServletRequestContext(request));
        if (isMultipart) {
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            try {
                List/*FileItem*/ items = upload.parseRequest(request);
                Iterator iter = items.iterator();
                while (iter.hasNext()) {
                    FileItem item = (FileItem) iter.next();
                    if (item.isFormField()) {

                        //file name
                        if (item.getFieldName().equalsIgnoreCase("txtfname")) {
                            filename = item.getString();
                        }
                        if (item.getFieldName().equalsIgnoreCase("txtpassword")) {
                            password = item.getString();
                        }
                        if (item.getFieldName().equalsIgnoreCase("fuserid")) {
                            fuserid = item.getString();
                        }

                    } else {
                        // upload first image
                        if (item.getFieldName().equalsIgnoreCase("txtfile")) {
                            String filename = item.getName();
                            if (!filename.equalsIgnoreCase("")) {

                                String enc_filpath = filePath + File.separator + filename;
                                File file3 = new File(enc_filpath);
 // file_name = DB.Connect.getFileDateTime()+filename.substring(filename.lastIndexOf("."));//full image path

                                //upload file path
                                uploadfile = "F" + timestamp + filename.substring(filename.lastIndexOf("."));;//full image path
                                upload_filepath = filePath + File.separator + uploadfile;
                                System.out.println("enc " + enc_filpath);
                                System.out.println("upload: " + uploadfile);
                                System.out.println("upload file path: " + upload_filepath);

                                try {

                                    item.write(file3);
                                    if (enc_filpath.equals("") || enc_filpath.equals("nullnull")) {
                                        flag = new MainEncryption().DBST(3, enc_filpath, password, upload_filepath);
                                    } else {
                                        flag = new MainEncryption().DBST(1, enc_filpath, password, upload_filepath);
                                    }

                                } catch (Exception e1) {
                                    status = false;
                                }
                            }
                        }

                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                status = false;
            }
        }

        if (flag) {
            try {
                String sqlquery = "INSERT INTO tblfiles(filename,filepath,adding_date,userid,fuserid,status) VALUES(?,?,NOW(),?,?,?)";
                pst = con.prepareStatement(sqlquery);
                pst.setString(1, filename);
                pst.setString(2, uploadfile);
                pst.setString(3, uid);
                pst.setString(4, fuserid);
                pst.setString(5, "Pending");

                i = pst.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
                ;
            }

            //success or failure message
            if (i > 0) {

                session.setAttribute("MSG", "File has been successfully uploaded and encrypted.");
                response.sendRedirect("uploadfile.jsp");
            } else {
                session.setAttribute("MSG", "File has not been uploaded.");
                response.sendRedirect("uploadfile.jsp");
            }
        } else {
            session.setAttribute("MSG", "File has not been uploaded.");
            response.sendRedirect("uploadfile.jsp");
        }

    }
}
