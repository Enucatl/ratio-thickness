<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Log ratio analysis</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    <!-- Select2 CSS -->
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/select2/3.4.6/select2.css">
    ##<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/select2/3.4.6/select2-bootstrap.css">

    ##mathjax
    <script type="text/javascript"
  src="https://c328740.ssl.cf1.rackcdn.com/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

    <!-- Custom styles for this template -->
    <link href="/static/css/starter-template.css" rel="stylesheet">
    <link href="/static/css/table.css" rel="stylesheet">
    <link href="/static/css/plots.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy this line! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

      
    <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="/">Analysis of the dark-field/absorption log ratio</a>
        </div>
      </div>
    </div>

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="jumbotron">
      <div class="container">
          ${self.body()}
      </div>
    </div>

    <div class="container">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-md-4">
            <h2>Dataset reconstruction</h2>
            <p>See the reconstruction for each dataset.</p>
            <p><a class="btn btn-default" href="/phase_stepping" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Single dataset</h2>
            <p>See the results for each single dataset.</p>
            <p><a class="btn btn-default" href="/single_dataset" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
            <h2>Aggregated</h2>
            <p>Compare the average log ratio for the different materials in
                one plot.</p>
            <p><a class="btn btn-default" href="/aggregated" role="button">View details &raquo;</a></p>
       </div>
      </div>

      <hr>
      <footer>
        <p>&copy; 2014</p>
      </footer>
    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>

    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

    <script src="//cdnjs.cloudflare.com/ajax/libs/select2/3.4.6/select2.min.js"></script>

    <script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>

  </body>
  <%block name="extra_js"/>
</html>
