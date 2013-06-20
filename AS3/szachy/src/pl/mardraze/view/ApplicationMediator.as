package pl.mardraze.view
{
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
	 
    import pl.mardraze.*;
    import pl.mardraze.model.*;
    import pl.mardraze.view.components.*;
    
    public class ApplicationMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "ApplicationMediator";
        
		public static const SPLASH_SCREEN : Number 	=	1;
		public static const MAIN_SCREEN : Number 	=	2;
        
        public function ApplicationMediator( viewComponent:Game ) 
        {
            super( NAME, viewComponent );
		}

        override public function onRegister():void
        {
			facade.registerMediator( new BoardScreenMediator( viewComponent.boardScreen ) );
			facade.registerMediator( new MainScreenMediator( viewComponent.mainScreen ) );
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
						ApplicationFacade.VIEW_SPLASH_SCREEN,
						ApplicationFacade.VIEW_MAIN_SCREEN
					];
        }

        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.VIEW_SPLASH_SCREEN:
					app.session.selectedIndex = SPLASH_SCREEN;
					break;

				case ApplicationFacade.VIEW_MAIN_SCREEN:
					app.session.selectedIndex = MAIN_SCREEN;
					break;
            }
        }

        protected function get app():Game
		{
            return viewComponent as Game
        }
    }
}