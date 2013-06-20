package pl.mardraze.controller
{
	import pl.mardraze.controller.SetDefaultConfigValuesCommand;
	
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class ApplicationStartupCommand extends MacroCommand
    {
        override protected function initializeMacroCommand() :void
        {
            addSubCommand( ModelPrepCommand );
            addSubCommand( ViewPrepCommand );
			addSubCommand( SetDefaultConfigValuesCommand );
        }
    }
}
