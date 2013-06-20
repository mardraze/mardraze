/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package pl.mardraze.controller
{

    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
    import org.puremvc.as3.patterns.observer.*;
    
    import pl.mardraze.*;
    import pl.mardraze.model.*;
    
    public class ModelPrepCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            //facade.registerProxy(new StartupMonitorProxy());
            //facade.registerProxy(new ConfigProxy());
            //facade.registerProxy(new LocaleProxy());
        }
    }
}