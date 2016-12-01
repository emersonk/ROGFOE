<%@page import="com.sun.xml.internal.bind.v2.TODO"%>
<%@page import="dbTransactions.FetchData"%> 
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<!DOCTYPE html>
<html lang="en">

<head>
	<title>Shop</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="stylesheet.css">
		
<style>

/* for js search functionality */
.organ-list tr[visible='false'],
.no-result{
	display:none;
}
.organ-list tr[visible='true']{
	display:table-row;
}

/* main page styling */
div.row.form-group.organ-search {
	width: 25%;
	margin: 0 auto; 
 	text-align: center; 
}
div.form-group.filter-list > ul {
	width: 50%;
	margin: auto; 
 	text-align: center; 
}
input.search.form-control {
	padding-top: 6px;
    padding-right: 12px;
    padding-bottom: 0px;
    padding-left: 12px;
}
div.row.form-group.organ-search > input {
	height: 40px;
}
div.row.product-list {
	width: 60%;
	margin: 0 auto;
}

/* table styling */
tbody > tr.row.shop.list-row > td.pic > * { 
 	margin-top: 20px; 
 	margin-bottom: 30px; 
} 
td.OName {
	text-align: left;
}
td.price {
	text-align: center;
}
span.OName {
	font-size: 1.6em;
	color: #0066c0;
}
span.desc {
	font-size: 1.2em;
}
span.price {
	font-weight: bold;
	font-size: 1.1em;
	color: #b12704;
}
span.cat {
	font-weight: bold;
	color: #0066c0;
}
span.buy > a {
	color: #0066c0;
}
span.size, span.blood {
	color: #949494;
}
</style>

</head>
<body>

<%@include file="navbar.jsp" %>

<div class="shop container-fluid"><!-- wraps everything to footer -->

	<h1 style="text-align:center">Shop</h1><br />

		<!-- js search -->
		<div class="row form-group organ-search">
			<span class="col-sm-12 counter text-center"></span>
			<input type="text" class="col-sm-12 search form-control" placeholder="Search by Organ">
		</div>
		
		<br />
		
    <!-- Filters -->

    <div class="form-group filter-list">   
		<ul class="row nav nav-pills">
			<li class="col-sm-1"></li>				
			<li class="dropdown organs col-sm-2">
				<form action="shop.jsp" method="get" id="organ">
		    	<select class="form-control" onchange="this.form.submit()" name="organ" form="organ">
		    		<option value="" disabled selected>Organ</option>
				<!-- Getting list of organs for dropdown menu -->
				
<%

//Set up the db connection and ability to grab data
FetchData data = new FetchData();
data.connect();
ResultSet rst;
rst = data.listOrganNames();

				while(rst.next())
				{	
					String organ = rst.getString(1);
					out.print(				
					"<option value=\""+organ+"\">"
						+organ+
					"</option>");			
				}
%>			
  					</select>
  					</form>
  					
				</li><!-- dropdown organs -->
					
			<li class="dropdown categories col-sm-2">
				<form action="shop.jsp" method="get" id="cat">
		    	<select class="form-control" onchange="this.form.submit()" name="cat" form="cat">
		    		<option value="" disabled selected>Category</option>
				<!-- Getting list of organ categories for dropdown menu -->
<% 					rst = data.listUniqueCategories();
				while(rst.next())
				{	
					String cat = rst.getString(1);
					String Cat = cat.substring(0, 1).toUpperCase() + cat.substring(1); //make first char. upper case
					out.print(				
					"<option value=\""+Cat+"\">"
						+Cat+
					"</option>");			
				}
%>
  					</select>
  					</form>
  					
				</li><!-- dropdown categories --> 	

				<li class="dropdown blood-type col-sm-2">
				<form action="shop.jsp" method="get" id="blood">
			    <select class="form-control" onchange="this.form.submit()" name="blood" form="blood">
			    	<option value="" disabled selected>Blood Type</option>
			    	<option value="A">A</option>
					<option value="AB">AB</option>
					<option value="B">B</option>
					<option value="O">O</option>
			    </select>
			    </form>
			    
		  	</li><!-- dropdown blood-type -->

			<li class="dropdown price-ranges col-sm-2">
				<form action="shop.jsp" method="get" id="price">
				<select class="form-control" onchange="this.form.submit()" name="price" form="price">
					<option value="" disabled selected>Price Range</option>
			    	<option value="<500">Less than $500</option>
					<option value="BETWEEN 500 AND 1000">$500 - $1000</option>
					<option value="BETWEEN 1000 AND 10000">$1000 - $10,000</option>
					<option value=">10000">More than $10,000</option>
			    </select>
			    </form>
			    
			</li><!-- dropdown price-ranges -->

			<li class="dropdown sizes col-sm-2">
				<form action="shop.jsp" method="get" id="size">
				<select class="form-control" onchange="this.form.submit()" name="size" form="size">	
					<option value="" disabled selected>Size (grams)</option>												
			    	<option value="1">Under 5g</option>
					<option value="2">5g - 100g</option>
					<option value="3">100g - 1000g</option>
					<option value="4">Over 1000g</option>
				</select>
				</form>
				
			</li><!-- dropdown sizes -->
			<li class="col-sm-1"></li>
		</ul><!-- nav nav-pills -->
  	</div><!-- row -->

	<div class="row product-list">	 
<%	    
/* List Products */
/* Print out the table headers */
out.print("<br><table class=\"table table-hover organ-list\">"+
			"<thead><tr>"+
// 				"<th></th>"+ /* picture */
// // 				"<th>Organ</th>"+
// 				"<th>Description</th>"+
// 				"<th>Size (grams)</th>"+
// // 				"<th>Removal Date</th>"+
// 				"<th>Blood Type</th>"+
// // 				"<th>Doctor</th>"+
// // 				"<th>Hospital</th>"+
// 				"<th>Category</th>"+
// 				"<th>Price</th>"+
// 				"<th></th>"+ /* add to cart */
			"</tr></thead><tbody>");

// filter dropdown values
rst = data.listOrganDetails();
String def = data.getOrganTable(rst);
	       	
ArrayList<String> resp = new ArrayList<String>();
resp.add(request.getParameter("organ"));
resp.add(request.getParameter("cat"));
resp.add(request.getParameter("blood"));
resp.add(request.getParameter("price"));
resp.add(request.getParameter("size"));
resp.add(def);

// decide what to show based on the set filter values
for (int i=0; i<resp.size(); i++){
	String table;
	if (resp.get(i)!=null) {
		switch (i) {
			case 0: /* organ */
				rst = data.filterOrganName(resp.get(i));
				table = data.getOrganTable(rst);
				out.print(table);
				break;
			case 1: /* cat */
				rst = data.filterOrganCat(resp.get(i));
				table = data.getOrganTable(rst);
				out.print(table);
				break;
			case 2: /* blood */
				rst = data.filterBloodType(resp.get(i));
				table = data.getOrganTable(rst);
				out.print(table);
				break;
			case 3: /* price */
				rst = data.filterOrganName(resp.get(i));
				table = data.getOrganTable(rst);
				out.print(table);
				break;
			case 4: /* size*/
				rst = data.listSizeRange(resp.get(i));
				table = data.getOrganTable(rst);
				out.print(table);
				break;
			case 5: /* everything */
				table = resp.get(i);
				out.print(table);
			default:
				break;				
			}
	}
}
out.print("</tbody></table>");
%>
	</div><!-- row -->	
	
</div><!-- container-fluid shop -->

<script type="text/javascript" defer="defer">
// Adds search to product list w/o querying the database
// adapted from: https://codepen.io/adobewordpress/pen/gbewLV
$(document).ready(function() {
	
 	$(".search").keyup(function () {
 		
	var searchTerm = $(".search").val();
	if(searchTerm.length>0){	
		var searchSplit = searchTerm.replace(/ /g, "'):containsi('")
 		$.extend($.expr[':'], {'containsi': function(elem, i, match, array){		
        	return (elem.textContent || elem.innerText || '').toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
    	}});
    
		$(".organ-list tbody tr").attr('visible', '');
		
  		$(".organ-list tbody td.OName:containsi('" + searchSplit + "')").each(function(e){			
			$(this).parent().attr('visible','true');
  		});
  
  		$(".organ-list tbody tr[visible='']").each(function(e){
    		$(this).attr('visible','false');
  		});
  		
 		var jobCount = $('.organ-list tbody tr.list-row[visible="true"]').length;
  		$('.counter').text(jobCount + ' product(s)');

		if(jobCount == '0') {$('.no-result').show();}
		else {$('.no-result').hide();}    	
	}
	else{
		$(".organ-list tbody tr").each(function(e){
		    $(this).attr('visible','').attr('display','table-row');
		  	$('.counter').text('');
		  	$('.no-result').hide();
		});
	}
 
	});
});
</script>
<%@include file="footer.jsp" %>
</body>
</html>