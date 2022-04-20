
<?php
  include_once('header.php');
  include_once('function.php');

  if (isset($_POST['go'])){
      session_start();
      $ergebnis = checkdaten($_POST['email'], $_POST['Passwort']);
      if($ergebnis != 0){
        header("location: to_index.php?");
        $_SESSION['kundennummer'] = $ergebnis;
        $_SESSION['menge'] = 20;
      }
   }
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
     <a href="Registierung.php" class="navbar-brand d-flex align-items-center">
       <strong>Registrieren</strong>
     </a>
     <a href="#" class="navbar-brand d-flex align-items-center">
       <strong >Anmelden</strong>
     </a>
   </div>
 </div>
</header>
     <div class="container">
       <div class="py-5 text-center">
         <div class="container">
           <a href="index.php" id="m-logo"><img alt="Shoe Market" class="img-fluid" src="https://static1.mysiteserver.net/images/theshoemarket/site/template/shoe-market-logo.png"> </a>
         </div>
         <img class="d-block mx-auto mb-4" src="/docs/4.5/assets/brand/bootstrap-solid.svg" alt="" width="100%" height="100%">
     <h2>Anmelden</h2>
     <p class="lead">Vielen Dank für Ihren Besuch auf unserer Webseite. Hiermit können Sie sich anmelden.</p>
   </div>

   <div class="row">

     <div class="col-md-8 order-md-1">
       <h6 class="mb-1">Melden Sie sich bitte mit Ihrer E-Mail-Adresse und Ihrem Passwort.</h6>
       <form class="needs-validation" novalidate action="Login.php" method="post">
         <hr class="mb-4">
         <div class="mb-3">
           <label for="email">E-Mail-Adresse*<span class="text-muted">(Optional)</span></label>
           <input type="email" name ="email" class="form-control" id="email" placeholder="you@example.com">
           <div class="invalid-feedback">
             Bitte geben Sie Ihren E-Mail-Adresse ein.
           </div>
         </div>
         <div class="mb-3">
           <label for="email">Passwort* <span class="text-muted">(Optional)</span></label>
           <input type="email" name ="Passwort" class="form-control" id="Passwort" placeholder="z.B. 123asd">
           <div class="invalid-feedback">
             Bitte geben Sie Ihren Passwort ein.
           </div>
         </div>

         <hr class="mb-4">

         <button class="btn btn-primary btn-lg btn-block"  name="go" type ="submit">Anmelden</button>
          </br>
         <h6 class="mb-1">Ich habe kein Konto
           <a type="Text"href="Registierung.php">registrieren</a>
         </h6>
         </br>
         </br>
       </form>
     </div>
   </div>
   <footer class="text-muted">
     <div class="container">
       <p class="float-right">
         <a href="#">Back to top</a>
       </p>
     </br> </br>
       <p>Danke für Ihren Besuch auf unsere Webseite und für Ihren Kauf</p>
       </div>
   </footer>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
      <script>window.jQuery || document.write('<script src="../assets/js/vendor/jquery.slim.min.js"><\/script>')</script><script src="../assets/dist/js/bootstrap.bundle.js"></script></body>
</html>
