package pl.mardraze
{
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.proxy.*;
    import org.puremvc.as3.patterns.facade.*;
	import org.puremvc.as3.patterns.observer.Notification;

    import pl.mardraze.view.*;
    import pl.mardraze.model.*;
    import pl.mardraze.controller.*;

    public class ApplicationFacade extends Facade
    {
        // Notification name constants
		// application
        public static const STARTUP:String 					= "startup";
        public static const SHUTDOWN:String 				= "shutdown";

		// command
        public static const COMMAND_STARTUP_MONITOR:String	= "StartupMonitorCommand";
		
		// view
		public static const VIEW_SPLASH_SCREEN:String		= "viewSplashScreen";
		public static const VIEW_MAIN_SCREEN:String			= "viewMainScreen";
		

        /**
         * Singleton ApplicationFacade Factory Method
         */
        public static function getInstance() : ApplicationFacade 
		{
            if ( instance == null ) instance = new ApplicationFacade( );
            return instance as ApplicationFacade;
        }

        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController( ) : void 
        {
            super.initializeController(); 
            registerCommand( STARTUP, ApplicationStartupCommand );
        }
		
		/**
		 * Start the application
		 */
		public function startup( app:Game ):void
		{
			sendNotification( STARTUP, app );
		}
		
    }
}