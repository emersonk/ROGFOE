<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">

<head>
	<title>Edit profile Success</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="stylesheet.css">
</head>

<body style="font-family: 'Lucida Sans Unicode', 'Lucida Grande', sans-serif;">
<%@include file="navbar.jsp" %>
<%@include file="auth.jsp" %>
<h1>Profile Updated</h1>
<h3>Click <a href="profilehome.jsp">here</a> to go back.</h3>

<%

			//Gather User information from request
			int UID = (int)session.getAttribute("uid");
			
			String fname = request.getParameter("fname");
			String mname = request.getParameter("mname");
			String lname = request.getParameter("lname");
			String street = request.getParameter("street");
			String city = request.getParameter("city");
			String country = request.getParameter("country");
			String state = request.getParameter("state");
			String postal = request.getParameter("postal");
			String homephone = request.getParameter("hphone");
			String wphone = request.getParameter("wphone");
			String cphone = request.getParameter("cphone");
			String email = request.getParameter("email");
			String pw = request.getParameter("pw");
			
			FetchData data = new FetchData();
			//Try to connect to db
			try (Connection con = data.connect();){
				
				//Prepared statements to insert into User table
				String insertUserSQL = ("UPDATE User SET fName = ?, mName = ?, lName = ?, UphoneH = ?, UphoneC = ?, UphoneW = ?, Uemail = ?, Password = ? WHERE User.UID = ?");
				PreparedStatement pst = con.prepareStatement(insertUserSQL, Statement.RETURN_GENERATED_KEYS);
				pst.setString(1, fname);
				pst.setString(2, mname);
				pst.setString(3, lname);
				pst.setString(4, homephone);
				pst.setString(5, cphone);
				pst.setString(6, wphone);
				pst.setString(7, email);
				pst.setString(8, pw);
				pst.setInt(9, UID);
			
				//Execute Query
				pst.executeUpdate();
				
				//Get UID of user that was just inserted to be used in Address insert
	/* 				ResultSet keys = pst.getGeneratedKeys();
					keys.next();
					int createdUID = keys.getInt(1);
					 */
				//Prepared statements to insert into Address table
				String insertAddressSQL = ("UPDATE Address SET Street =?, City=?, State=?, Country=?, PostalCode =? WHERE UID = ?");
				PreparedStatement psta = con.prepareStatement(insertAddressSQL);
				psta.setString(1, street);
				psta.setString(2, city);
				psta.setString(3, state);
				psta.setString(4, country);
				psta.setString(5, postal);
				psta.setInt(6, UID);
				
				//Execute
				psta.executeUpdate();
				
				
				con.close();

			} catch (SQLException ex){
				System.out.println(ex);
			}

			%>
	
	
<%@include file="footer.jsp" %>

</body>

</html>