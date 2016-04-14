

import java.awt.GridBagLayout;
import com.zerog.ia.api.pub.*;

import javax.swing.JButton;
import java.awt.GridBagConstraints;
import java.io.File;
import java.util.Vector;

import javax.swing.JLabel;
import javax.swing.JComboBox;
import javax.swing.JPanel;

import java.awt.Insets;
import java.awt.Color;
import java.awt.Font;

public class ChooseInstallDrivePanel extends CustomCodePanel {

	private boolean isSetup = false;

	public String getTitle() {
		return "Choose Install Drive";
	}

	public boolean setupUI(CustomCodePanelProxy arg0) {
        if(isSetup )
	    {
            removeAll();
        }				
		ccpp = arg0;
		initialize();		
        isSetup = true;        
		return true;
	}

	public boolean okToContinue() {
		ccpp.setVariable("$USER_INSTALL_DRIVE$", (String)getInstallDriveComboxBox().getSelectedItem());
		return true;
	}

	private CustomCodePanelProxy ccpp;  //  @jve:decl-index=0:
	private static final long serialVersionUID = 1L;
	private JButton installDriveRestoreButton = null;
	private JLabel installDriveLabel = null;
	private JComboBox installDriveComboxBox = null;

	/**
	 * This is the default constructor
	 */
	public ChooseInstallDrivePanel() {
		super();
	}



	/**
	 * This method initializes this
	 * 
	 * @return void
	 */
	private void initialize() {
		GridBagConstraints gridBagConstraints11 = new GridBagConstraints();
		gridBagConstraints11.gridx = 1;
		gridBagConstraints11.gridy = 1;
		gridBagConstraints11.gridwidth = GridBagConstraints.REMAINDER;
		gridBagConstraints11.gridheight = 1;
		gridBagConstraints11.fill = GridBagConstraints.HORIZONTAL;
		gridBagConstraints11.insets = new Insets(0, 0, 0, 0);
		gridBagConstraints11.anchor=GridBagConstraints.NORTH;
		gridBagConstraints11.weightx=1;
		gridBagConstraints11.weighty=0;
		
		GridBagConstraints gridBagConstraints2 = new GridBagConstraints();
		gridBagConstraints2.gridx = 0;
		gridBagConstraints2.gridy = 0;
		gridBagConstraints2.gridwidth = GridBagConstraints.REMAINDER;
		gridBagConstraints2.gridheight = 1;
		gridBagConstraints2.fill = GridBagConstraints.HORIZONTAL;
		gridBagConstraints2.insets = new Insets(0, 0, 3, 0);
		gridBagConstraints2.anchor=GridBagConstraints.WEST;
		gridBagConstraints2.weightx=1;
		gridBagConstraints2.weighty=0;
		
		installDriveLabel = new JLabel();
		installDriveLabel.setText("Where Would You Like to Install?");
		installDriveLabel.setFont(new Font("SansSerif", Font.BOLD, 12));
		GridBagConstraints gridBagConstraints1 = new GridBagConstraints();
		gridBagConstraints1.gridx = 1;
		gridBagConstraints1.gridy = 2;
		gridBagConstraints1.gridwidth = 1;
		gridBagConstraints1.gridheight = 1;
		gridBagConstraints1.fill = GridBagConstraints.NONE;
		gridBagConstraints1.insets = new Insets(5, 0, 0, 0);
		gridBagConstraints1.anchor=GridBagConstraints.NORTHEAST;
		gridBagConstraints1.weightx=1;
		gridBagConstraints1.weighty=1;

		
		this.setSize(426, 310);
		this.setLayout(new GridBagLayout());
		this.setForeground(Color.white);
		this.add(getInstallDriveRestoreButton(), gridBagConstraints1);
		this.add(installDriveLabel, gridBagConstraints2);
		this.add(getInstallDriveComboxBox(), gridBagConstraints11);
	}

	/**
	 * This method initializes installDriveRestoreButton	
	 * 	
	 * @return javax.swing.JButton	
	 */
	private JButton getInstallDriveRestoreButton() {
		if (installDriveRestoreButton == null) {
			installDriveRestoreButton = new JButton();
			installDriveRestoreButton.setText("Restore Default Location");
			installDriveRestoreButton.setFont(new Font("SansSerif", Font.BOLD, 12));
			installDriveRestoreButton
					.addActionListener(new java.awt.event.ActionListener() {
						public void actionPerformed(java.awt.event.ActionEvent e) {
							getInstallDriveComboxBox().setSelectedIndex(0);
						}
					});
		}
		return installDriveRestoreButton;
	}

	/**
	 * This method initializes installDriveComboxBox	
	 * 	
	 * @return javax.swing.JComboBox	
	 */
	private JComboBox getInstallDriveComboxBox() {
		if (installDriveComboxBox == null) {
			installDriveComboxBox = new JComboBox(getDrives());
		}
		return installDriveComboxBox;
	}

	 private String[] getDrives() 
	 {
		 // Get all the root drives
		 System.out.println("Before Getting Roots");
		File[] roots =File.listRoots();  
		 System.out.println("After Getting Roots");		
		Vector rootDrivesVector =  new Vector();
		
		// Go through the list
		for (int i=0;i < roots.length;i++)
		{
				//  Only add writeable locations to the list of valid drives.
				System.out.println("Drive: \""+ roots[i].getAbsolutePath()+"\"");
				if(!roots[i].getAbsolutePath().trim().equalsIgnoreCase("A:\\"))
				{
					if(roots[i].canWrite())
					{
						//rootDrives[driveIndex]=roots[i].getAbsolutePath();
						rootDrivesVector.add(roots[i].getAbsolutePath());
					}
				}
		}

		String[] rootDrives = new String[rootDrivesVector.size()];
		rootDrivesVector.copyInto(rootDrives);
		return rootDrives;
	 }
}
