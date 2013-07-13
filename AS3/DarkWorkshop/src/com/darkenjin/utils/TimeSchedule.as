package com.darkenjin.utils
{
	import flash.utils.Dictionary;
	/**
	 * Based on Cron's predefined scheduling definitions
	 * http://linux.die.net/man/5/crontab
	 * @author Marcin Drazek
	 */
	public class TimeSchedule
	{
		
		private var debug:Boolean = false;		
		
		public static const NONE:String = '*';
		
		/**
		 * 0-7 (0 or 7 is Sun)
		 */
		public var dweek:String = NONE;
		
		/**
		 * month (1 - 12)
		 */
		public var month:String = NONE;
		
		/**
		 * day of month (1 - 31)
		 */
		public var day:String = NONE;
		
		/**
		 * hour (0 - 23)
		 */
		public var hour:String = NONE;
		
		/**
		 * min (0 - 59)
		 */
		public var min:String = NONE;
		

		private var minValues:Array;
		private var hourValues:Array;
		private var dayValues:Array;
		private var monthValues:Array;
		private var dweekValues:Array;
			
		
		private static var MAX_YEAR:int = 2015;
		private static var MIN_YEAR:int = 2011;
		public static var DEFAULT_HOUR:uint = 0;
		public static var DEFAULT_MINUTES:uint = 0;
		public static var DEFAULT_DAY:uint = 1;

		public function TimeSchedule() 
		{
		}
		
		
		/**
		 * - timestamp w milisekundach
		 * - zwraca liczbę milisekund do następnego, najbliższego punktu schedulera 
		 * - wartość +XXXX gdy timestamp jest przed najbliższym punktem lub -XXXX gdy jest po tym punkcie, XXXX to wartość różnicy czasu od punktu do timestamp
		 * 
		 * @param	timestamp
		 * @return
		 */
		public function getDiff(timestamp:Number):Number
		{
			if(!parse()) return -1;

			var before:Number = getDiffDirection(timestamp, false);
			var after:Number = getDiffDirection(timestamp, true);

			if ((timestamp - before) < (after - timestamp)) {
				return before-timestamp;
			} else {
				return after-timestamp;
			}
		}
		
		private function getDiffDirection(timestamp:Number, direction:Boolean):Number {
			var dayCount:int;
			var date:Date = new Date();
			date.setTime(timestamp);
			date.setSeconds(0);
			date.setMilliseconds(0);

			//set minutes if not in array
			if (minValues.indexOf(date.getMinutes()) == -1) {
				date.setTime(findMinutes(date, direction));
			}

			//set hour if not in array
			if (hourValues.indexOf(date.getHours()) == -1) {
				date.setTime(findHours(date, direction));
			}
			
			var next:int;
			
			if (direction) {
				dayValues.sort(Array.NUMERIC);
				next = 1;
			}else {
				dayValues.sort(Array.NUMERIC | Array.DESCENDING);
				next = -1;
			}
			
			//change year
			for (var y:Number = date.getFullYear(); y <= MAX_YEAR && y >= MIN_YEAR; y += next) {
				//change month
				for (var m:int = date.getMonth(); m < 12 && m >= 0; ) {

					if (monthValues.length == 0 || monthValues.indexOf(date.getMonth() + 1)  >= 0) {
						dayCount = getDayCount(date.getFullYear(), date.getMonth());
						var day:Number = DEFAULT_DAY;
						//change day
						if (dweekValues.length == 0) {
							if (dayValues.indexOf(date.getDate()) >= 0) { //today
								return date.getTime();
							}else {
								if (dayValues.length == 0) {
									return date.getTime();
								} else {
									for each(var _day:Number in dayValues) {
										if (direction) {
											if (greater1(_day, date.getDate(), direction)) {
												date.setDate(_day);
												return date.getTime();
											}
										}else {
											if (greater1(date.getDate(), _day, direction)) {
												date.setDate(_day);
												return date.getTime();
											}
										}
									}
								}
							}
						}else {
							for (var d:int = date.getDate(); d > 0 && d <= dayCount; ) {
								date.setDate(d);
								
								if (dweekValues.indexOf(date.getDay()) >= 0) {
									if (dayValues.length == 0 || dayValues.indexOf(date.getDate()) >= 0) {
										return date.getTime();
									}
									
									if (dayValues.length == 0) d+=next; 
									else d += 7*next; 
								} else {
									d+=next;
								}
							}
						}
					}
					m += next;
					if (m >= 0 && m < 12 ) {
						if (direction) {
							date.setMonth(m, 1);
						}else {
							date.setMonth(m, getDayCount(date.getFullYear(), m));
						}
					}

				}
				if (direction) {
					date.setFullYear(y+next, 0, 1);
				}else {
					date.setFullYear(y+next, 11, getDayCount(y+next, 11));
				}
			}
			return 0;
		}
		
		
		private function findMinutes(date:Date, direction:Boolean):Number {
			if (minValues.length > 0) {
				var minutes:uint;
				
				var nextHour:int = 3600*1000;
				if (direction) {
					minValues.sort(Array.NUMERIC);
				}else {
					minValues.sort(Array.NUMERIC | Array.DESCENDING);
					nextHour = -nextHour;
				}
				
				if (greater1(date.getMinutes(), minValues[minValues.length - 1], direction)) {
					minutes = minValues[0];
					date.setTime(date.getTime()+nextHour); 
				}else {
					for each(var m:Number in minValues) {
						if (greater1(m, date.getMinutes(), direction)) {
							minutes = m;
							break;
						}
					}
				}
				
				date.setMinutes(minutes);
			}else if (monthValues.length > 0 || dayValues.length > 0 || dweekValues.length > 0) {
				date.setMinutes(DEFAULT_MINUTES);
			}

			return date.getTime();
		}

		private function greater1(a:int, b:int, direction:Boolean):Boolean {
			if (direction) {
				return a > b;
			}else {
				return a < b;
			}
		}
		
		
		private function findHours(date:Date, direction:Boolean):Number {

			if (hourValues.length > 0) {
				var hour:uint;
				var nextDay:int = 24*3600*1000;
				if (direction) {
					hourValues.sort(Array.NUMERIC);
				}else {
					hourValues.sort(Array.NUMERIC | Array.DESCENDING);
					nextDay = -nextDay;
				}
				
				if (hourValues[hourValues.length - 1] < date.getHours()) {
					hour = hourValues[0];
					
					date.setTime(date.getTime()+nextDay);
				}else {
					for each(var h:Number in hourValues) {
						if (h > date.getHours()) {
							hour = h;
							break;
						}
					}
				}
				date.setHours(hour);
			}else if (monthValues.length > 0 || dayValues.length > 0 || dweekValues.length > 0) {
				date.setHours(DEFAULT_HOUR);
			}

			
			return date.getTime();
		}
		
		private function getDayCount(year:int, month:int):int{
			 var d:Date=new Date(year, month, 0);
			 return d.getDate();
		}

		
	    private function parse():Boolean
		{
			try {
				minValues = parseCronNumbers(min, 0, 59);
				hourValues = parseCronNumbers(hour, 0,23);
				dayValues = parseCronNumbers(day, 1, 31);
				monthValues = parseCronNumbers(month,1,12);
				dweekValues = parseCronNumbers(dweek, 0, 6);
				return true;
			}
			catch(error:Error){
			}
			return false;
		}


		/**
		* get a single cron style notation and parse it into numeric value
		*
		* @param string $s cron string element
		* @param int $min minimum possible value
		* @param int $max maximum possible value
		* @return int parsed number
		*/
			
		private function parseCronNumbers(s:String,min:Number,max:Number):Array
		{
			if (s == NONE) {
				return new Array();
			}
			
			var result:Array = new Array();			
			
			var number:Number = parseInt(s);

			if (number + "" == s) {
				result.push(number);
				return result;
			}
			
			var v:Array = s.split(',');

			for each(var vv:String in v) {
				var vvv:Array = vv.split('/');
				var step:Number = 1;
				//if (vvv[1]) step = 1; else step = vvv[1];
				var vvvv:Array = vvv[0].split('-');
				
				var _min:Number = vvvv.length==2 ? vvvv[0] : (vvv[0]==NONE ? min : parseInt(vvv[0]));
				var _max:Number = vvvv.length==2 ? vvvv[1] : (vvv[0]==NONE ? max : parseInt(vvv[0]));

				if (_min > _max) {
					throw new Error('min > max');
				}
				
				
				for (var i:Number = _min; i <= _max; i += step) {
					if (!result.indexOf(i)) result.push(i);
				}
			}
			
			return result;
		}
		
	}

}