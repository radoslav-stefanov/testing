<?php

/*
***********************************************
* Simple PHP Router		              
***********************************************
*/

        //--Switcher upper for detecting directory
        $curdir = dirname($_SERVER['REQUEST_URI'])."/";
        $baseUri = str_replace($curdir, '/', $curdir);
switch ($baseUri) {
    case '/country' :
        require __DIR__ . '/country.php';
        break;
    case '/helloworld' :
        require __DIR__ . '/helloworld.php';
        break;
    default:
        http_response_code(404);
        require __DIR__ . '/404.php';
        break;
}

