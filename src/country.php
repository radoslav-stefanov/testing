<?php

function getRealIpAddr(){
  if (!empty($_SERVER['HTTP_CLIENT_IP'])){
    $ip=$_SERVER['HTTP_CLIENT_IP'];
  }
  elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])){
    $ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
  }
  else {
    $ip=$_SERVER['REMOTE_ADDR'];
  }
  return $ip;
}

$xml = simplexml_load_file("http://www.geoplugin.net/xml.gp?ip=50.218.57.65");
$country = $xml->geoplugin_countryName ;

if ($country == Norway)
{
  echo "Hei fra Norge!";
}
elseif ($country == "United States")
{
  echo "Hello from US!";
}
else
{
  echo "Hello from $country!";
}

?>
