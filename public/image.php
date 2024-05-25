<?php
require_once __DIR__ . '/../vendor/autoload.php';
use Chess\FenToBoardFactory;
use Chess\Media\BoardToPng;
use Chess\Variant\Classical\Board;

class PngOutput extends BoardToPng
{
    public function outputStream()
    {
        $this->chessboard('')->save('php://output');
    }
}

ob_start();

$fen = $_GET['fen'] ?? null;
try {
    $board = $fen ? FenToBoardFactory::create($fen) : new Board();
} catch (Exception $ex) {
    $board = new Board();
}

$png = new PngOutput($board);
$png->outputStream();
header('Content-type: image/png');
header('Content-length: ' . ob_get_length());
ob_end_flush();
