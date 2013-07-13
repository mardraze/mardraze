/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package pl.mardraze.view
{
	import pl.mardraze.model.enum.ConfigKeyEnum;
	import pl.mardraze.model.enum.LocaleKeyEnum;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	import pl.mardraze.*;
	import pl.mardraze.model.*;
	import pl.mardraze.view.components.*;

    /**
     * A Mediator for interacting with the MainScreen component.
     */
    public class MainScreenMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "MainScreenMediator";
        
		private var configProxy:ConfigProxy;
		private var localeProxy:LocaleProxy;
		
        /**
         * Constructor. 
         */
        public function MainScreenMediator( viewComponent:MainScreen ) 
        {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super( NAME, viewComponent );
		}
			
        override public function onRegister():void
        {
			// retrieve the proxies
			configProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
			localeProxy = facade.retrieveProxy( LocaleProxy.NAME ) as LocaleProxy;
			
			mainScreen.addEventListener( MainScreen.START, handleCreationComplete );
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
         * @return MainScreen the viewComponent cast to pl.mardraze.view.components.MainScreen
         */
		 
        protected function get mainScreen():MainScreen
		{
            return viewComponent as MainScreen;
        }
		
		/*********************************/
		/* events handler 				 */
		/*********************************/
		
		private function handleCreationComplete( evt:Event ):void
		{
			sendNotification(ApplicationFacade.VIEW_SPLASH_SCREEN);
		}
		
		override public function handleNotification( notification:INotification ):void {
			super.handleNotification(notification);
		}
		
    }
}