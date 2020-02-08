<?php
$host = 'localhost';
$dbname = 't8huro00';
$username = 't8huro00';
$password = '';
$con = mysqli_connect($host, $username, $password, $dbname);
if (mysqli_connect_errno()) {
 echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
$LKatsottu = mysqli_real_escape_string($con,filter_input(INPUT_POST,'OnkoKatsottu',FILTER_SANITIZE_STRING));
$LIMDb = mysqli_real_escape_string($con,filter_input(INPUT_POST,'IMDb',FILTER_SANITIZE_STRING));
$tulos = mysqli_query($con,"CALL HaeElokuvia('$LKatsottu', '$LIMDb')"); 
echo "<table border='1'> 
<tr> 
<th>Nimi</th> 
<th>Kieli</th>
<th>Julkaistu</th> 
<th>Genre</th>
<th>IMDb</th>
</tr>"; 
while($row = mysqli_fetch_array($tulos)) { 
echo "<tr>"; 
echo "<td>" . $row['Nimi'] . "</td>"; 
echo "<td>" . $row['Puhuttu_kieli'] . "</td>"; 
echo "<td>" . $row['Julkaistu'] . "</td>"; 
echo "<td>" . $row['Genre'] . "</td>";
echo "<td>" . $row['IMDb_arvio'] . "</td>"; 
echo "</tr>"; 
} 
echo "</table>";
mysqli_close($con); 