# Skittles

A small web app that helps play a game of chess over SMS/email/messaging.
Players visit the web site, use the interactive chessboard to make their
move, and then share the URL of the page with their opponent using
whatever method they would like. The other player opens the link to see the
new move, and repeats the process. Dynamic images of the current board
position are generated for messaging apps that support image previews.

## Requirements

  * PHP 8.1+
  * PHP GD extension
  * Composer

## Installation

Install dependencies with:

    $ composer install

Copy the example configuration file and set the base URL (no trailing slash):

    $ cp config.example.php config.php
    $ vi config.php

## Run

To test locally, run the PHP built-in web server:

    $ php -S localhost:8080 -t public

and then open [http://localhost:8080](http://localhost:8080). To run publicly,
ensure your web server is configured to run PHP scripts and set the document
root to the `/public` directory in the project root.

## Acknowledgements

  * [Chess.js](https://github.com/jhlywa/chess.js/) by Jeff Hlywa
  * [Chessboard.js](https://www.chessboardjs.com/) by Chris Oakman
  * [php-chess](https://github.com/chesslablab/php-chess) by ChesslaBlab contributors

## License and Copyright

Copyright (c) 2024 Corey Hinshaw  
Released under the terms of the MIT License. See the LICENSE file for details.
