<?php
$host = 'localhost';
$dbname = 't8huro00';
$username = 't8huro00';
$password = '';
$con = mysqli_connect($host, $username, $password, $dbname);
if (mysqli_connect_errno()) {
 echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
$LNetun = mysqli_real_escape_string($con,filter_input(INPUT_POST,'Netun',FILTER_SANITIZE_STRING));
$LNsukun = mysqli_real_escape_string($con,filter_input(INPUT_POST,'Nsukun',FILTER_SANITIZE_STRING));
$tulos = mysqli_query($con,"CALL TulostaNayttelijanXElokuvat('$LNetun', '$LNsukun')"); 
echo "<table border='1'> 
<tr> 
<th>Etunimi</th> 
<th>Sukunimi</th>
<th>Roolinimi</th> 
<th>Elokuvan nimi</th>

</tr>"; 
while($row = mysqli_fetch_array($tulos)) { 
echo "<tr>"; 
echo "<td>" . $row['etunimi'] . "</td>"; 
echo "<td>" . $row['sukunimi'] . "</td>"; 
echo "<td>" . $row['Roolinimi'] . "</td>"; 
echo "<td>" . $row['Elokuvan nimi'] . "</td>";
echo "</tr>"; 
} 
echo "</table>";
mysqli_close($con); 