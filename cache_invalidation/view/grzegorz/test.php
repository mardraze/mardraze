<?php
 
    //$tablica = array();
    
    for($i=0; $i<100000; $i++)
    {
	}
    
    $wynik['status']=200;
    
    
    
    
    //dane do wykresu
    
    $tablicaw[0]="y";
    $tablicaw[1]="x1";
    $tablicaw[2]="x2";
    
    $tablica[0] = $tablicaw;
    
    
    $tablicaw[0]=5;
    $tablicaw[1]=10;
    $tablicaw[2]=15;
    
    $tablica[1] = $tablicaw;
    
    $tablicaw[0]=10;
    $tablicaw[1]=20;
    $tablicaw[2]=25;
    
    $tablica[2] = $tablicaw;
    
    $tablicaw[0]=20;
    $tablicaw[1]=30;
    $tablicaw[2]=35;
    
    $tablica[3] = $tablicaw;
    
    $tablicaw[0]=30;
    $tablicaw[1]=40;
    $tablicaw[2]=85;
    
    $tablica[4] = $tablicaw;
 
	//koniec danych wykresu
	
	$log[0]="jakis tekst";
	$log[1]="jakis tekst2";
	
	$result['data']=$tablica;
	$result['log']=$log;
	
	$content['result']=$result;
	
	$content['execution_time']=0.1111;
	
	$wynik['content']=$content;
 
    echo json_encode($wynik); //przekształcamy naszą tablicę na zapis typu json

?>
