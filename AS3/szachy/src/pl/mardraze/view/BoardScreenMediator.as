package pl.mardraze.view
{
	import flash.events.Event;
	
	import pl.mardraze.ApplicationFacade;
	import pl.mardraze.model.*;
	import pl.mardraze.view.components.*;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

    public class BoardScreenMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "SplashScreenMediator";
        
        public function BoardScreenMediator( viewComponent:BoardScreen ) 
        {
            super( NAME, viewComponent );
			
			boardScreen.addEventListener(BoardScreen.EFFECT_END, this.endEffect);
        }

        /**
         * List all notifications this Mediator is interested in.
         * <P>
         * Automatically called by the framework when the mediator
         * is registered with the view.</P>
         * 
         * @return Array the list of Nofitication names
         */
        override public function listNotificationInterests():Array 
        {
            return [ 
					StartupMonitorProxy.LOADING_STEP,
					StartupMonitorProxy.LOADING_COMPLETE,
					ConfigProxy.LOAD_FAILED,
					LocaleProxy.LOAD_FAILED
					];
        }

        /**
         * Handle all notifications this Mediator is interested in.
         * <P>
         * Called by the framework when a notification is sent that
         * this mediator expressed an interest in when registered
         * (see <code>listNotificationInterests</code>.</P>
         * 
         * @param INotification a notification 
         */
        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case StartupMonitorProxy.LOADING_STEP:
					//this.boardScreen.pb.setProgress( note.getBody() as int, 100);
					break;
					
				case StartupMonitorProxy.LOADING_COMPLETE:
					this.sendNotification( ApplicationFacade.VIEW_MAIN_SCREEN );
					break;
					
				case ConfigProxy.LOAD_FAILED:
				case LocaleProxy.LOAD_FAILED:
					//this.boardScreen.errorText.text = note.getBody() as String;
					//this.boardScreen.errorBox.visible = true;
					break;
            }
        }

        /**
         * Cast the viewComponent to its actual type.
         * 
         * <P>
         * This is a useful idiom for mediators. The
         * PureMVC Mediator class defines a viewComponent
         * property of type Object. </P>
         * 
         * <P>
         * Here, we cast the generic viewComponent to 
         * its actual type in a protected mode. This 
         * retains encapsulation, while allowing the instance
         * (and subclassed instance) access to a 
         * strongly typed reference with a meaningful
         * name.</P>
         * 
         * @return SplashScreen the viewComponent cast to pl.mardraze.view.components.SplashScreen
         */
		 
        protected function get boardScreen():BoardScreen
		{
            return viewComponent as BoardScreen;
        }
		
		/**
         * End effect event
         */
		private function endEffect(event:Event=null):void
		{
			// start to load the resources
			var startupMonitorProxy:StartupMonitorProxy = facade.retrieveProxy( StartupMonitorProxy.NAME ) as StartupMonitorProxy;
			startupMonitorProxy.loadResources();
		}
		
    }
}
