package tests
{
	import com.darkenjin.utils.TimeSchedule;
	import flexunit.framework.Test;
	import org.flexunit.asserts.assertEquals;
	/**
	 * Based on Cron's predefined scheduling definitions
	 * http://linux.die.net/man/5/crontab
	 * @author Marcin Drazek
	 */
	public class TimeScheduleTest
	{
		
		private static var NEXT_MINUTE:Number = 1000 * 60;
		
		private static var NEXT_HOUR:Number = NEXT_MINUTE * 60;
		
		private static var NEXT_DAY:Number = NEXT_HOUR * 24;
		
		private static var NEXT_WEEK:Number = NEXT_DAY * 7;
		
		private var debug:Boolean = true;
		
		public function TimeScheduleTest() 
		{
		}
		
		[Test]
		public function getDiffDirectionTrue_CheckMinutes_SameHour_Before():void {

			var dateTS:Date = new Date(2013, 6, 23, 8, 30);
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(14);
			
			var ts:TimeSchedule = initTimeShedule(dateTS, false, false, false, false, true);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		[Test]
		public function getDiffDirectionTrue_CheckMinutes_SameHour_Equal():void {

			var dateTS:Date = new Date(2013, 6, 23, 8, 30);
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			var ts:TimeSchedule = initTimeShedule(dateTS, false, false, false, false, true);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}

		[Test]
		public function getDiffDirectionTrue_CheckMinutes_SameHour_After():void {

			var dateTS:Date = new Date(2013, 6, 23, 8, 30);
			var ts:TimeSchedule = initTimeShedule(dateTS, false, false, false, false, true);

			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);
			
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		
		[Test]
		public function getDiffDirectionTrue_MinutesAfter_HourAfter():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 23, 8, 30);

			var ts:TimeSchedule = initTimeShedule(dateTS, false, false, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);
			
			date.setHours(9);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime() + NEXT_DAY); //result: next day
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		
		[Test]
		public function getDiffDirectionTrue_MinutesAfter_HourBefore():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 23, 8, 30);

			var ts:TimeSchedule = initTimeShedule(dateTS, false, false, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);
			
			date.setHours(7);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime()); 
			
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		[Test]
		public function getDiffDirectionFalse_MinutesAfter_HourEqual():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 23, 8, 30);

			var ts:TimeSchedule = initTimeShedule(dateTS, false, false, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		[Test]
		public function getDiffDirectionFalse_Day_After_MinutesAfter_HourAfter():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30);

			var ts:TimeSchedule = initTimeShedule(dateTS, false, false, true, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(9);

			date.setDate(20);

			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		[Test]
		public function getDiffDirectionTrue_Day_Before_MinutesAfter_HourBefore():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30);

			var ts:TimeSchedule = initTimeShedule(dateTS, false, false, true, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(7);

			date.setDate(14);

			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());

			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		
		[Test]
		public function getDiffDirectionTrue_DWeek_Before_MinutesAfter_HourBefore():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY

			var ts:TimeSchedule = initTimeShedule(dateTS, false, true, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(7);

			date.setDate(3);

			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			resCorrect.setDate(4);

			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		
		[Test]
		public function getDiffDirectionFalse_DWeekAfter_MinutesAfter_HourBefore():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY

			var ts:TimeSchedule = initTimeShedule(dateTS, false, true, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(7);

			date.setDate(5); 

			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			resCorrect.setDate(4);

			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		[Test]
		public function getDiffDirectionTrue_DWeek_Same_MinutesAfter_HourBefore():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY

			var ts:TimeSchedule = initTimeShedule(dateTS, false, true, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(7);

			date.setDate(4);

			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			resCorrect.setDate(4); //today
			
			
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		[Test]
		public function getDiffDirectionTrue_Month_Before_DWeekAfter_MinutesAfter_HourBefore():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY
			
			var ts:TimeSchedule = initTimeShedule(dateTS, true, true, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(7);

			date.setDate(5);
			
			date.setMonth(5);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			resCorrect.setDate(4);
			
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}
		
		[Test]
		public function getDiffDirectionTrue_MonthAfter_DWeekAfter_MinutesAfter_HourBefore():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY
			
			var ts:TimeSchedule = initTimeShedule(dateTS, true, true, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(7);

			date.setDate(5); 
			
			date.setMonth(7);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			resCorrect.setDate(25);
			if (debug) {
				log(ts, date, dateTS, resCorrect);
			}else {
				assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
			}
		}
		
		[Test]
		public function getDiffDirectionFalse_Month_Same_DWeekAfter_MinutesAfter_HourBefore():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY
			
			var ts:TimeSchedule = initTimeShedule(dateTS, true, true, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(7);

			date.setDate(5); 
			
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			resCorrect.setDate(4);
			
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}

		[Test]
		public function getDiffDirectionTrue_MonthAfter_DWeekAfter_MinutesAfter_HourAfter():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY
			
			var ts:TimeSchedule = initTimeShedule(dateTS, true, true, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(9);

			date.setDate(9); 
			
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			resCorrect.setDate(11);
			
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}		
		
		[Test]
		public function getDiffDirectionFalse_MonthAfter_DWeekAfter_MinutesAfter_HourAfter():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY
			
			var ts:TimeSchedule = initTimeShedule(dateTS, true, true, false, true, true);

			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(9);

			date.setDate(5); 
			
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());
			
			resCorrect.setDate(4);
			
			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}		
		
		[Test]
		public function getDiffDirectionFalse_DayAfter_DWeekAfter_MinutesAfter_HourAfter():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY
			
			var ts:TimeSchedule = initTimeShedule(dateTS, false, true, true, true, true);
			
			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(9);

			date.setDate(5); 
			
			date.setMonth(7);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());

			assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
		}		
		

		[Test]
		public function getDiffDirectionFalse_DayAfter_DWeekAfter_MinutesAfter():void {

			
			
			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY
			
			var ts:TimeSchedule = initTimeShedule(dateTS, false, true, true, false, true);
			
			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(9);

			date.setDate(5); 
			
			date.setMonth(7);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());

			resCorrect.setHours(TimeSchedule.DEFAULT_HOUR);

			if (debug) {
				log(ts, date, dateTS, resCorrect);
			}else {
				assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
			}
		}
		
		[Test]
		public function getDiffDirectionFalse_DayAfter_DWeekAfter():void {

			//SET OBJECT
			var dateTS:Date = new Date(2013, 6, 18, 8, 30); //THURSDAY
			
			var ts:TimeSchedule = initTimeShedule(dateTS, false, true, true, false, false);
			
			//SET INPUT
			var date:Date = new Date();
			
			date.setTime(dateTS.getTime());
			
			date.setMinutes(35);

			date.setHours(9);

			date.setDate(5); 
			
			date.setMonth(7);
			
			//SET RESULT
			var resCorrect:Date = new Date();
			resCorrect.setTime(dateTS.getTime());

			resCorrect.setHours(TimeSchedule.DEFAULT_HOUR);
			
			resCorrect.setMinutes(TimeSchedule.DEFAULT_MINUTES);

			if (debug) {
				log(ts, date, dateTS, resCorrect);
			}else {
				assertEquals(resCorrect.getTime()-date.getTime(), ts.getDiff(date.getTime()));
			}
		}
		
		///////////////////////////// PRIVATE ///////////////////////////////////
		
		//log(ts, date, dateTS, resCorrect);
		private function log(ts:TimeSchedule, dateInput:Date, dateObject:Date, dateResultCorrect:Date):void {
			
			trace('object: ' + dateObject.toString());
			trace('input: ' + dateInput.toString());

			var dateResult:Date = new Date();
			dateResult.setTime(dateInput.getTime() + ts.getDiff(dateInput.getTime()));
			
			trace('result: ' + dateResult.toString());
			trace('result correct: ' + dateResultCorrect.toString());
		}
		
		
		private function initTimeShedule(date:Date, setMonth:Boolean = false, setDWeek:Boolean = false, setDay:Boolean = false, setHour:Boolean = false, setMinutes:Boolean = false):TimeSchedule {
			var ts:TimeSchedule = new TimeSchedule();
			
			if (setMonth) {
				ts.month = (date.getMonth()+1) + "";
			}
			if (setDWeek) {
				ts.dweek = date.getDay() + "";
			}
			if (setDay) {
				ts.day = date.getDate() + "";
			}
			if (setHour) {
				ts.hour = date.getHours() + "";
			}
			if (setMinutes) {
				ts.min = date.getMinutes() + "";
			}
			
			return ts;
		}
		
		
	}

}