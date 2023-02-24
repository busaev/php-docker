<?php

try {
    $dsn = "pgsql:host=db;port=5432;dbname=symfony;";
    $pdo = new PDO($dsn, 'symfony_user', 'symfony_pass', [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
} catch (PDOException $e) {
    die($e->getMessage());
}

echo 'бд на связи<br />';

$redis = new Redis();
try {
    $redis->connect('redis', 6379);
} catch (\Exception $e) {
    die($e->getMessage());
}
echo 'редис на связи<br />';
