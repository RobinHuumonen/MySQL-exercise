<?php 
  
/* 
 * To change this license header, choose License Headers in Project Properties. 
 * To change this template file, choose Tools | Templates 
 * and open the template in the editor. 
 */ 
  
try { 
$yhteys = new PDO("mysql:host=localhost;dbname=t8huro00", "t8huro00", 
""); 
} catch (PDOException $e) { 
die("VIRHE: " . $e->getMessage()); 
} 
// virheenkäsittely: virheet aiheuttavat poikkeuksen 
$yhteys->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
// merkistö: käytetään latin1merkistöä; 
//toinen yleinen vaihtoehto on utf8. 
$yhteys->exec("SET NAMES latin1"); 
$kysely = $yhteys->prepare("CALL LisaaElokuva (?, ?, ?, ?, ?, ?, ?, ?)"); 
$kysely->execute(array($_POST["Oetun"], $_POST["Osukun"], $_POST["Enimi"], $_POST["Kieli"], $_POST["Julk"], $_POST["Genr"], $_POST["IMDb"], $_POST["OnkoKatsottu"])); 

 