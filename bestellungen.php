<?php
  include_once('header.php');
  include_once('function.php');
  session_start();

   //echo $_SESSION['kundennummer'];
 ?>
<body>

  <header>
<div class="collapse bg-dark" id="navbarHeader">
  <div class="container">
    <div class="row">
      <div class="col-sm-8 col-md-7 py-4">
        <h4 class="text-white">About</h4>
        <p class="text-muted">Add some information about the album below, the author, or any other background context. Make it a few sentences long so folks can pick up some informative tidbits. Then, link them off to some social networking sites or contact information.</p>
      </div>
      <div class="col-sm-4 offset-md-1 py-4">
        <h4 class="text-white">Contact</h4>
        <ul class="list-unstyled">
          <li><a href="#" class="text-white">Follow on Twitter</a></li>
          <li><a href="#" class="text-white">Like on Facebook</a></li>
          <li><a href="#" class="text-white">Email me</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>
<div class="navbar navbar-dark bg-dark shadow-sm">
  <div class="container d-flex justify-content-between">
    <a href="#" class="navbar-brand d-flex align-items-center">
      <img alt="Shoe Market" class="img-fluid" width="15%" height="15%" src="Anmerkung 2020-06-19 064822.png">
      <strong>Gestionnaire</strong>
    </a>

    <a href="https://www.facebook.com/ghali.rasoul" class="navbar-brand d-flex align-items-center">
       <img alt="Shoe Market" width="25" height="25px" s class="img-fluid" src="https://www.facebook.com/images/fb_icon_325x325.png">
    </a>
    <a href="tel:(781) 749-5411" class="navbar-brand d-flex align-items-center">
      <strong Type = "text " onclick="ga('send', 'event', { eventCategory: 'general', eventAction: 'click to call', eventLabel: 'lead', eventValue: 1});">(0049) 12345567</strong>
    </a>

    <a href="Login.php" class="navbar-brand d-flex align-items-center">
      <strong >Abmelden</strong>
    </a>

    <a href="acuont.php">  <img alt="Shoe Market" class="img-fluid" width="35" height="35" src="3.png"></a>
    <a href="warenkorb.php" ><img alt="Shoe Market" class="img-fluid" width="35" height="35" src="warenk.png">

  </div>
</div>
    <a  id="m-logo"><img alt="Shoe Market" class="img-fluid" width="1550" height="50"class="img-fluid" src="acount2.png"> </a>
    <div class="container">
      <div class="py-5 text-center">

    <h2>Ihre Bestellungen</h2>
    <p class="lead">Hier können Sie Ihre Bestellungen anzusehen.</p>
  </div>
  </div>
</header>

<main role="main">
      <table class="table">
       <thead>
         <tr>
            <th>Bestelllungsnummer</th><th>Bestellungsdatum</th><th>Lieferdatum</th><th>Bestellungsstatus</th><th>Stornosdatum</th>
        </tr>
       </thead>
       <tbody>
       <?php
        $query = getAuftrag($_SESSION['kundennummer']);
        while ($data = mysqli_fetch_array($query)){ ?>
       <tr>
        <td><?=$data['auftragsnummer']?></td>
        <td><?=$data['auftragsdatum']?></td>
        <td><?=$data['lieferdatum']?></td>
        <td><?=$data['auftragsstatus']?></td>
        <td><?=$data['stornodatum']?></td>
       </tr>
       <hr class="mb-4">
       <?php } ?>
       </tbody>
      </table>

    </br>
    <a type="text" class="btn btn-primary btn-lg btn-block"  href="acuont.php"><</a>
   </br>
  </br>
</main>



<?php
  include_once('footer.php');
 ?>
