package pl.mardraze.controller
{
    import pl.mardraze.*;
    import pl.mardraze.model.*;
    import pl.mardraze.view.ApplicationMediator;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
    import org.puremvc.as3.patterns.observer.*;
    
    public class ViewPrepCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            facade.registerMediator( new ApplicationMediator( note.getBody() as Game ) );
			
			sendNotification( ApplicationFacade.VIEW_SPLASH_SCREEN );
        }
    }
}
