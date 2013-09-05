function pobierzZadanieXMLHTTP()
{
	var zadanie = false;
	try{
		zadanie = new XMLHttpRequest();
	} catch (blad){
		try {
			zadanie = new ActiveXObject("Msxm2.XMLHTTP");
		} catch (blad) {
			try {
				zadanie = new ActiveXObject("Microsoft.XMLHTTP");
			}catch (blad) {
				zadanie = false;
			}
		}
	}
	
	return zadanie;
}

function odpowiedzHTTP()
{
	if(mojeZadanie.readyState == 4)
	{
		if(mojeZadanie.status == 200)
		{
			//var ciagCzasu = mojeZadanie.responseXML.getElementsByTagName("czaszapytania")[0];
			//document.getElementById('pokaz').innerHTML = ciagCzasu.childNodes[0].nodeValue;
			//sumaCzasu += parseFloat(ciagCzasu.childNodes[0].nodeValue);
			
			//zwrot++;
			
			//if(flaga == 1 && zwrot == index)
			//{
				
			//}
		}
		else
		{
			//document.getElementById('pokaz').innerHTML = '<h1>ladowanie</h1>';
		}
	}
}

function wykonajZapytanie()
{
	//var procent = document.getElementsByName("procent").value;
	//var inwalidacja = document.getElementsByName("inwalidacja").value;
	var strona = 'test.php';
	
	mojeZadanie = pobierzZadanieXMLHTTP();
	
	
	
	liczbaLosowa = parseInt(Math.random()*999999999999999);
	
	var adresURL = strona + "?losowa="+liczbaLosowa + "&procent="+procent  + "&inwalidacja="+inwalidacja;
	mojeZadanie.open("GET", adresURL, true);
	mojeZadanie.onreadystatechange = odpowiedzHTTP;
	mojeZadanie.send(null);
	
	return 0;
}

function test(value){
procent = value;
}

function test2(value){
inwalidacja=value;
}
