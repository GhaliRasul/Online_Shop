
  <?php
    include_once('header.php');
    include_once('function.php');
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
      <section class="jumbotron text-center">
        <div class="container">
          <a  id="m-logo"><img alt="Shoe Market" class="img-fluid" src="https://static1.mysiteserver.net/images/theshoemarket/site/template/shoe-market-logo.png"> </a>
        </br>
        </br>
            <div class="container d-flex justify-content-between">
            <a href="to_index.php" class="navbar-brand d-flex align-items-center">
              <strong >Hauptseite</strong>
            </a>
            <a href="to_damen.php" class="navbar-brand d-flex align-items-center">
              <strong >Damen</strong>
            </a>
            <a href="#" class="navbar-brand d-flex align-items-center">
              <strong >Herren</strong>
            </a>
            <a href="to_kinder.php" class="navbar-brand d-flex align-items-center">
              <strong >Kinder</strong>
            </a>
        </div>
      </div>
      </section>
    </header>

<main role="main">
  <div class="album py-5 bg-light">
    <div class="container">

      <div class="row">
       <?php
         $query = getProdukteHerren();
         while ($data = mysqli_fetch_array($query)) {
        ?>
        <div class="col-md-4">
          <div class="card mb-4 shadow-sm">
            <img width="100%" height="225" src= "<?php echo $data['bild']; ?>" />
            <div class="card-body">
              <p class="card-text"> <?php echo $data['produktbeschreibung']; ?></p>
              <div class="d-flex justify-content-between align-items-center">
                <div class="btn-group">
                  <a type = "button" name= "warenkorb" class="btn btn-sm btn-outline-secondary" href= "warenkorb.php?produktnummer=<?php echo $data['produktnummer']; ?>">Kaufen</a>
                  </div>
                <small class="text-muted"><?php echo $data['verkaufspreis']; ?> €</small>
              </div>
            </div>
          </div>
        </div>
      <?php } ?>
      </div>
    </div>
  </div>

</main>

<?php
  include_once('footer.php');
 ?>
