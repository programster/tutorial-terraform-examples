<?php
require_once(__DIR__ . '/vendor/autoload.php');
$dotenv = new Symfony\Component\Dotenv\Dotenv();
$dotenv->load('/.env');

$app = Slim\Factory\AppFactory::create();
$app->addErrorMiddleware($displayErrorDetails=true, $logErrors=true, $logErrorDetails=true);

$app->get('/', function (Psr\Http\Message\ServerRequestInterface $request, Psr\Http\Message\ResponseInterface $response) {
    if (!isset($_ENV['USER_NAME']))
    {
        throw new Exception("Missing required environment variable: USER_NAME");
    }
    
    $response->getBody()->write('Hello ' . $_ENV['USER_NAME']);
    return $response;
});

$app->run();