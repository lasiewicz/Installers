/* For creating a general action or custom action
you extend the InstallAnywhere class called
CustomCodeAction   *** */

import com.zerog.ia.api.pub.*;

import javax.swing.*;

public class MySampleAction extends CustomCodeAction
{
	
	/* this method gets invoked during install
	time and so any code you want to excecute during 
	installation you will call from here....*/
	public void install(InstallerProxy ip)
	{
	JOptionPane.showMessageDialog(null, "Install Message");

	}

	/* this method gets invoked during uninstall
	time and so any code you want to excecute during 
	uninstallation you will call from here....*/
	public void uninstall(UninstallerProxy up)
	{
	JOptionPane.showMessageDialog(null, "Uninstall Message");
	}

	public String getInstallStatusMessage()
	{
		return "Running my custom action....";
	}
	
	public String getUninstallStatusMessage()
	{
		return "Uninstalling my custom action....";
	}

}
