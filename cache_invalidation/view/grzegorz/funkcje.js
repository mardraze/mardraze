var jest_net = true;
	function ukryj(arg)
	{
		$('#'+arg).toggle();
	}
	if(jest_net){
		google.load("visualization", "1", {packages:["corechart"]});
	}
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
					var newChartId = 'chart_div'+(_this._.nextChartID);
					var newChartIdc = 'cchart_div'+(_this._.nextChartID);
					var newChartIdtr = 'trchart_div'+(_this._.nextChartID);
					var newChartIdt = 'tchart_div'+(_this._.nextChartID++);
					var parametr = "'"+newChartIdtr+"'";
					$('#chartContainer').prepend('<div id="'+newChartId+'" class="wykres"></div>');
					$('#'+newChartId).append('<div id="'+newChartIdc+'" class="wykresc"></div>');
					if(jest_net){
						var data = google.visualization.arrayToDataTable(dataArray['content']['result']['data']);
						var options = {
						  title: 'Wykres czasu od numeru zapytania',
						  hAxis: {title: 'numer zapytania',  titleTextStyle: {color: '#333'}},
						  vAxis: {title: 'czas', minValue: 0}
						};
						var chart = new google.visualization.AreaChart(document.getElementById(newChartIdc));
						chart.draw(data, options);
					}
					_this.onResponseReady();
					$('#'+newChartId).prepend('<p class="tytul">Test nr: '+_this._.nextChartID+'</p>');
					$('#'+newChartId).append('<p class="tytul">Statystyki:</p>');
					$('#'+newChartId).append('<table class="tables" id="'+newChartIdt+'">');
					$('#'+newChartIdt).append('<tr><td class="wyrs">Czas wykonania : </td><td>'+dataArray['content']['execution_time']+'</td></tr>');
					$('#'+newChartId).append('<input type="button" value="Pokaż/Ukryj logi serwera" onclick="ukryj('+parametr+');"/>');
					$('#'+newChartId).append('<div id="'+newChartIdtr+'">');
					var logs = '<table class="tables"><tr><td class="wyrs">Logi serwera : </td></tr>';
					console.log(dataArray);
					for(var log in dataArray.content.result.log){
						var r = dataArray.content.result.log[log];
						logs += '<tr><td>'+r.query.type+' | '+r.time+' | '+r.from_cache+'</td></tr>';
					}
					logs += '</table>';
					$('#'+newChartIdtr).append(logs);
					$('#'+newChartIdtr).toggle();
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
				var url = _this._.baseUrl + '?' + $('#'+_this._.requestParamsFormId).serialize();
				$.ajax({
				type: "GET",
					dataType: "json",
					url: url,
					success: function(responseData){
						_this._.drawChart(responseData);
						 $('#loading').hide();
					},
					error: function(){
						alert('error');
					},
					beforeSend: function(){
					   $('#loading').show();
					},
				});
			},
		};
		
		ChartGenerator.init('requestParamsForm','chartContainer');
		ChartGenerator.onResponseReady = function(){
			$('#chartHeader').show();
		};
