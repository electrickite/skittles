<?php require_once __DIR__ . '/../config.php'; ?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="light dark">
    <meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)">
    <meta name="theme-color" content="#212121" media="(prefers-color-scheme: dark)">

    <title>Skittles</title>

    <meta property="og:title" content="New move">
    <meta property="og:site_name" content="Skittles">
    <meta property="og:url" content="<?= $base_url; ?>/">
    <meta property="og:image" content="<?= $base_url . '/image.php?' . http_build_query(['fen' => $_GET['fen'] ?? '']); ?>">
    <meta property="og:image:type" content="image/png">
    <meta property="og:type" content="website">
    <meta property="og:description" content="New chess move">
    <meta property="og:locale" content="en_US">

    <link rel="icon" type="image/png" href="<?= $base_url; ?>/img/chess-icon.png">
    <link rel="apple-touch-icon" type="image/png" sizes="180x180" href="<?= $base_url; ?>/img/chess-icon.png">
    <link rel="stylesheet" href="css/simple.min.css">
    <link rel="stylesheet" href="css/chessboard-1.0.0.min.css">
    <link rel="stylesheet" href="css/style.css?v=4">
  </head>
  <body>
    <main>
      <div class="center">
        <div id="chessboard" class="chessboard"></div>
        <div>
          <button id="copy">Copy</button>
          <button id="reset">Reset</button>
        </div>
      </div>
      <dl class="notice">
        <dt>Status:</dt>
        <dd id="status"></dd>
        <dt>Last move:</dt>
        <dd id="move"></dd>
      </dl>
      <details>
        <summary>Options</summary>
        <label for="promote">Promote to:</label>
        <select id="promote">
          <option value="q">Queen</option>
          <option value="r">Rook</option>
          <option value="n">Knight</option>
          <option value="b">Bishop</option>
        </select>
      </details>
    </main>

    <script src="js/jquery-3.7.1.min.js" charset="utf-8"></script>
    <script src="js/chessboard-1.0.0.min.js" charset="utf-8"></script>
    <script src="js/main.js?v=4" type="module" charset="utf-8"></script>
  </body>
</html>
