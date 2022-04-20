
<?php
  include_once('header.php');
  include_once('function.php');
   session_start();

 if (isset($_GET['produktnummer'])){
   einfuegenInWarknKorb( $_GET['produktnummer'], $_SESSION['kundennummer']);
   }



if (isset($_GET['kaufen'])){
   kaufen($_SESSION['kundennummer']);
   header("location: nachEinkauf.php");
}

if (isset($_GET['position_id_wa'])){
   positionloeschen($_GET['position_id_wa']);
}
 //echo $_SESSION['kundennummer'];
 //echo $_SESSION['menge'];
 if (isset($_GET['menge'])) {
   $_SESSION['menge'] = 1;
  }
//echo $_SESSION['menge'];


 ?>


 <body class="bg-light">
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
     <a href="to_index.php" class="navbar-brand d-flex align-items-center">
       <img alt="Shoe Market" class="img-fluid" width="15%" height="15%" src="Anmerkung 2020-06-19 064822.png">
       <strong>Gestionnaire</strong>
     </a>

     <a href="https://www.facebook.com/ghali.rasoul" class="navbar-brand d-flex align-items-center">
        <img alt="Shoe Market" width="25" height="25px" s class="img-fluid" src="https://www.facebook.com/images/fb_icon_325x325.png">
     </a>
     <a href="tel:(781) 749-5411" class="navbar-brand d-flex align-items-center">
       <strong Type = "text " onclick="ga('send', 'event', { eventCategory: 'general', eventAction: 'click to call', eventLabel: 'lead', eventValue: 1});">(0049) 12345567</strong>
     </a>

     <a href="index.php" class="navbar-brand d-flex align-items-center">
       <strong >Abmelden</strong>
     </a>

     <a href="acuont.php">  <img alt="Shoe Market" class="img-fluid" width="35" height="35" src="3.png"></a>
     <a href="warenkorb.php" ><img alt="Shoe Market" class="img-fluid" width="35" height="35" src="warenk.png">

   </div>
</div>
</header>



  <div class="container">
   <div class="py-5 text-center">
     <div class="container">
       <a  id="m-logo"><img alt="Shoe Market" class="img-fluid" src="https://static1.mysiteserver.net/images/theshoemarket/site/template/shoe-market-logo.png"> </a>
     </div>
     <img class="d-block mx-auto mb-4" src="/docs/4.5/assets/brand/bootstrap-solid.svg" alt="" width="100%" height="100%">
     <h2>Ihr Warenkorb</h2>
     <p class="lead">Hiervon können Sie direkt diese Artikel bestellen oder weitere Artikel kaufen.</p>
   </div>

   <div class="row">
     <div class="col-md-8 order-md-8">
       <h4 class="d-flex justify-content-between align-items-center mb-6">
         <span class="text-muted">Ihr Warenkorb</span>
         <span class="badge badge-secondary badge-pill">
           <?php echo warenkorbpositionanzahl($_SESSION['kundennummer']); // kunden ändern?></span>
       </h4>
       <ul class="list-group mb-6">

           <form class="needs-validation" novalidate action="warenkorb.php?" method="get">
         <?php
           $summe = 0;
           $query = warenkorbposition($_SESSION['kundennummer']);// kunden ändern
           while ($data = mysqli_fetch_array($query)) {
             $produktnummer = getProdukteByID( $data['produktnummer'] );
          ?>
         <li class="list-group-item d-flex justify-content-between lh-condensed">
           <div>
             <h6 class="my-0"><?php echo $produktnummer['produktname'];?></h6>
           </div>
           <input type="number" name="menge"  placeholder=""
           value="1" min="1" max="<?php echo ver_bes($data['produktnummer']);?>">

          <input type="hidden" name="position_id_wa" value="<?php echo $data['position_id']; ?>">
          <a type = "button" name= "Entfernen" class="btn btn-sm btn-outline-secondary" href = "to_warenkorb.php?position_id_wa=<?php echo $data['position_id']; ?>">Entfernen</a>
           Farbe
           <select name="farbe">
           <option value="schwarz">schwarz</option>
           <option value="weiss">weiß</option>
           <option value="brauen">braun</option>
           </select>
           <span class="text-muted"><?php echo $produktnummer['verkaufspreis']; ?> €</span>
           <?php $summe += $produktnummer['verkaufspreis']; ?>
         </li>
       <?php } ?>
       </from>
         <li class="list-group-item d-flex justify-content-between">
           <span>Gesamtpreis  €</span>
           <strong><?php echo $summe ?> €</strong>
         </li>
       </ul>
     </div>
 </div>
 <div class="col-md-8 order-md-1">
   <hr class="mb-4">
    <button class="btn btn-primary btn-lg btn-block"  name="kaufen" type ="submit" >Kaufen</button>
      <a type="button" class="btn btn-primary btn-lg btn-block"  href="to_index.php">Weiterkaufen</a>
   </div>
  </div>
<?php
  include_once('footer.php');
 ?>
