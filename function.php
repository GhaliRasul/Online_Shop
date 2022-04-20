
<?php

function getConnection() {

  $mysqlhost="localhost"; // MySQL-Host angeben
  $mysqluser="root"; // MySQL-User angeben
  $mysqlpwd="aaa(123)"; // Passwort angeben
  $mysqldb="Basel"; // Gewuenschte Datenbank angeben

  $connection=mysqli_connect($mysqlhost, $mysqluser, $mysqlpwd, $mysqldb)
    or die("DB Connection ERROR!");
  return $connection;
}

function getProdukte(){
    $con = getConnection();
    $sql = "SELECT * FROM produkte";
    $query = mysqli_query($con, $sql);
    return $query;
}


function getProdukteDamen(){
    $con = getConnection();
    $sql = "SELECT * FROM produkte WHERE Kategoriennummer = 1";
    $query = mysqli_query($con, $sql);
    return $query;
}

function getProdukteHerren(){
    $con = getConnection();
    $sql = "SELECT * FROM produkte WHERE Kategoriennummer = 3";
    $query = mysqli_query($con, $sql);
    return $query;
}

function getProdukteKinder(){
    $con = getConnection();
    $sql = "SELECT * FROM produkte WHERE Kategoriennummer = 2";
    $query = mysqli_query($con, $sql);
    return $query;
}
function getProdukteByID($produktnummer ){
    $con = getConnection();
    $sql = "SELECT * FROM produkte WHERE produktnummer = $produktnummer";
    $query = mysqli_query($con, $sql);
    $data = mysqli_fetch_array($query);
    return $data;
}

function warenkorbposition($kundennummer){
    $con = getConnection();
    $sql = "SELECT * FROM Warenkorbpositionen WHERE kundennummer = $kundennummer";
    $query = mysqli_query($con, $sql);
    return $query;
}
function auftagsposition($auftragsnummer){
    $con = getConnection();
    $sql = "SELECT * FROM Auftragspositionsdaten WHERE auftragsnummer = $auftragsnummer";
    $query = mysqli_query($con, $sql);
    return $query;
}
function warenkorbpositionanzahl($kundennummer ){
    $con = getConnection();
    $sql = "SELECT COUNT(*) FROM Warenkorbpositionen WHERE kundennummer = $kundennummer";
    $query = mysqli_query($con, $sql);
    $data = mysqli_fetch_array($query);
   return $data[0];
}

function ver_bes($produktnummer){
    $con = getConnection();
    $sql = "SELECT verfuegbarer_Lagerbestand(".$produktnummer.") from DUAL;";
    $query = mysqli_query($con, $sql);
    $data = mysqli_fetch_array($query);
   return $data[0];
}

function einfuegenInWarknKorb($produktnummer, $kundennummer){
    $con = getConnection();
    $sql = "INSERT INTO Warenkorbpositionen VALUES (NULL,$kundennummer,$produktnummer, 1);";
    $query = mysqli_query($con, $sql);
}

function positionloeschen($position_id_p){
    $con = getConnection();
    $sql = "DELETE FROM Warenkorbpositionen WHERE position_id =  $position_id_p" ;
    $query = mysqli_query($con, $sql);
}

function savekunden($order){
    $name = $order['nachname'];
    $vorname = $order['vorname'];
    $geschlecht = $order['geschlecht'];
    $adresse = $order['adresse'];
    $plz = $order['plz'];
    $wohnort = $order['wohnort'];
    $e_mail = $order['email'];
    $bankkonto = $order['bankkonto'];
    $kennwort = $order['kennwort'];
    $con = getConnection();
    $sql = "INSERT INTO Kunden VALUES (NULL,'".$geschlecht."','". $name."','".$vorname."','".$adresse."',$plz, '".$wohnort."', NULL, '".$e_mail."', '".$bankkonto."', '".$kennwort."'); ";
    $query = mysqli_query($con, $sql);
 }
 function anderenkunden($kundennummer,  $name ,  $vorname,  $geschlecht,  $adresse,  $plz,  $wohnort,  $e_mail,  $bankkonto,  $kennwort){
   $con = getConnection();
   $sql = "DELETE FROM Kunden WHERE kundennummer =$kundennummer; ";
   $query = mysqli_query($con, $sql);
    kundeneinf($kundennummer,  $name ,  $vorname,  $geschlecht,  $adresse,  $plz,  $wohnort,  $e_mail,  $bankkonto,  $kennwort);
 }
 function kundeneinf($kundennummer,  $name ,  $vorname,  $geschlecht,  $adresse,  $plz,  $wohnort,  $e_mail,  $bankkonto,  $kennwort){
    $con = getConnection();
    $sql = "INSERT INTO Kunden VALUES ($kundennummer,'".$geschlecht."','". $name."','".$vorname."','".$adresse."',$plz, '".$wohnort."', NULL, '".$e_mail."', '".$bankkonto."', '".$kennwort."'); ";
    $query = mysqli_query($con, $sql);
 }

 function checkdaten($email, $kennwort){
     $con = getConnection();
     $sql = "SELECT kundennummer FROM kunden WHERE e_mail  = '".$email."' AND kennwort = '".$kennwort."';";
     $query = mysqli_query($con, $sql);
     while($data = mysqli_fetch_array($query)){
      return $data['kundennummer'];
    }
  }
  function getkunden($kundennummer){
        $con = getConnection();
        $sql = "SELECT * FROM kunden WHERE kundennummer = $kundennummer;";
        $query = mysqli_query($con, $sql);
        $data = mysqli_fetch_array($query);
         return $data;
  }
  function getAuftrag($kundennummer){
        $con = getConnection();
        $sql = "SELECT * FROM auftrag WHERE kundennummer = $kundennummer;";
        $query = mysqli_query($con, $sql);
        return $query;
  }


  function lastauftrag(){
      $con = getConnection();
      $sql = "SELECT count(*) FROM Auftrag ";
      $query = mysqli_query($con, $sql);
      while ($data3=mysqli_fetch_array($query)) {
       return $data3[0] ;}

  }


   function kaufen($kundennummer){
       $con = getConnection();

       $sql = "INSERT INTO Auftrag VALUES (NULL,default , NULL, now() + interval 10 day, 'in Bearbeitung','". $kundennummer."');";
       $query = mysqli_query($con, $sql);
       $auftragnummer =lastauftrag();

       $query2 = warenkorbposition($kundennummer);

       while ($data = mysqli_fetch_array( $query2)) {
         $produktnummer = $data['produktnummer'];
         $menge = $data['menge'];
         $sq2 = "INSERT INTO Auftragspositionsdaten VALUES (NULL,'".$produktnummer."' ,'".$auftragnummer."' ,'". $menge."');";
         $query3 = mysqli_query($con, $sq2);
       }
       emailsenden($kundennummer, $auftragnummer);
       $sq3 = "DELETE FROM Warenkorbpositionen WHERE kundennummer = $kundennummer ";
       $query3 = mysqli_query($con, $sq3);

    }



    // mehrere Empfänger
    function emailsenden($kundennummer, $auftragnummer){
        // Betreff
        $betreff = 'Ihre Gestionnaire Bestellung mit der Nummer:'.$auftragnummer;

        $con = getConnection();
        $dat1 = getkunden($kundennummer);
        $dat1['vorname'];


        $summe = 0;
        $positionen = auftagsposition($auftragnummer);
        while ($data = mysqli_fetch_array($positionen)){
            $produktnummer = getProdukteByID($data['produktnummer']);
            $summe +=  $data['menge'] * $produktnummer['verkaufspreis'];
          }
        $lieferdatum1 = date('Y-m-d');
        $lieferdatum2 = date('Y-m-d'. strtotime($lieferdatum1.'+5 day'));
        // Nachricht
        $nachricht = '
        <html>
        <head>
          <title>Ihre Gestionnaire Bestellung mit der Nummer:'.$auftragnummer.'</title>
        </head>
        <body>
          <p>Guten Tag '.$dat1['vorname'].',</p>
          <p class="lead">vielen Dank fuer Ihre Bestellung bei Gestionnaire.</p>
          <p class="lead">Das voraussichtliche Lieferdatum ist am '.$lieferdatum2.'.</p>
          <p class="lead">Um Ihre Bestellung anzusehen, besuchen Sie Meine Bestellungen auf unserer  Website oder hier direkt unter </p>
          <a type="Text" class="btn btn-sm btn-outline-secondary" href="http://localhost/online_shop/Login.php?">meiner Bestellung</a>

          <h2>Rechnungsuebersicht</h2>
          <hr class="mb-4">
          <p>  Rechnungsbetrag: '.$summe.'</p>
          <p>  MWST-Betrag: '.$summe * 0.19.'</p>
          <p>  MWST-Betrag: '. ($summe - ($summe * 0.19)).'</p>
          <hr class="mb-4">
            <p class="lead">Wir freuen uns auf Ihren nächsten Besuch! </p>
        </body>
        </html>
        ';

        // für HTML-E-Mails muss der 'Content-type'-Header gesetzt werden
        $header[] = 'MIME-Version: 1.0';
        $header[] = 'Content-type: text/html; charset=iso-8859-1';

        $header[] = 'From: Gestionnaire <Husseinbasel14@gmail.com>';


        // verschicke die E-Mail
        mail( $dat1['e_mail'], $betreff, $nachricht, implode("\r\n", $header));
        }

?>
