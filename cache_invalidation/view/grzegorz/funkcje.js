	google.load("visualization", "1", {packages:["corechart"]});
		
	$(function(){
		$('#loading').hide();
	});
		
		
		var ChartGenerator = {
			
			//private
			_ : {
				//output div
				chartContainerId : '',
				
				//form with request params
				requestParamsFormId : '',

				//server address
				baseUrl : 'http://localhost/mardraze/cache_invalidation/web/ksr/performanceTest',
				
				nextChartID : 0,
				drawChart : function(dataArray) {
					var data = google.visualization.arrayToDataTable(dataArray['content']['result']['data']);
					var options = {
					  title: 'KSR',
					  hAxis: {title: 'czas',  titleTextStyle: {color: '#333'}},
					  vAxis: {title: 'ilosc', minValue: 0}
					};
					var newChartId = 'chart_div'+(_this._.nextChartID++);
					var newChartIdc = 'c'+newChartId;
					var newChartIdt = 't'+newChartId;
					$('#chartContainer').prepend('<div id="'+newChartId+'" class="wykres"></div>');
					$('#'+newChartId).append('<div id="'+newChartIdc+'" class="wykresc"></div>');
					var chart = new google.visualization.AreaChart(document.getElementById(newChartIdc));
					chart.draw(data, options);
					_this.onResponseReady();
					//ciag dalszy
					$('#'+newChartId).prepend('<p class="tytul">Test nr: '+_this._.nextChartID+'</p>');
					$('#'+newChartId).append('<p class="tytul">Statystyki:</p>');
					$('#'+newChartId).append('<table class="tables" id="'+newChartIdt+'">');
					$('#'+newChartIdt).append('<tr><td class="wyrs">Czas wykonania : </td><td>'+dataArray['content']['execution_time']+'</td></tr>');
					$('#'+newChartIdt).append('<tr><td rowspan="2" class="wyrs">Logi serwera : </td><td>'+dataArray['content']['result']['log'][0]+'</td></tr>');
					$('#'+newChartIdt).append('<tr><td>'+dataArray['content']['result']['log'][1]+'</td></tr>');
					//'<tr><td class="wyrs">Czas wykonania : </td><td>'+dataArray['content']['execution_time']+'</td></tr></table>');
					//$('#'+newChartId).append('Czas wykonania :');
					//$('#'+newChartId).append('</td><td>');
					//$('#'+newChartId).append(dataArray['content']['execution_time']);
					//$('#'+newChartId).append('</td></tr></table>');

				},
			},
			
			
			
			
			init : function(requestParamsFormId, chartContainerId){
				//this object
				_this = ChartGenerator;
				_this._.chartContainerId = chartContainerId;
				_this._.requestParamsFormId = requestParamsFormId;
			},
			
			
			
			clearChart : function (){
				$('#chartContainer').empty();
			},
			

			makeChart : function (){
			
			/*
				_this._.drawChart(
					[
						[1, 2], 
						[100, 200],
						[120, 220]
					]
				);
				return;
			*/
				//TODO get data from server
				//var url = _this._.baseUrl + '?' + $(_this._.requestParamsFormId).serialize();
				var url = _this._.baseUrl + '?' + $('#'+_this._.requestParamsFormId).serialize();
				
				//var url = 'test.php';
				
				//////////////////
				/////////////////
				/////////////////
				
				$.ajax({
				　　　　type: "GET",
				　　　　dataType: "json",
				　　　　url: url,
				　　　　success: function(responseData){
						_this._.drawChart(responseData);
						 $('#loading').hide();
						},
					   beforeSend: function(){
						  // $('#chartHeader').remove();
						   $('#loading').show();
					   },
				});
			},
		};
		
		
		//success: _this._.drawChart,
		
		ChartGenerator.init('requestParamsForm','chartContainer');
		ChartGenerator.onResponseReady = function(){
			$('#chartHeader').show();
		};
