# checklicense
MATLAB License Checker

MATLAB's network-based "floating license" requires users to be connected to the FLEXlm license server to run MATLAB. This model is used to limit the total number of MATLAB users and users of specific toolboxes. It can sometimes occur that a specific toolbox is not available to the user because the total number of users for that toolbox has been reached.
CHECKLICENSE uses the license manager utilities to inform about the availability of a license, and can be used to send an e-mail whenever the license is available. 

For example, to receive an e-mail whenever the Image Processing Toolbox is available, the following command can be used:

```
checklicense('Image_Toolbox', 'myemail@gmail.com')
```

This command checks every 60 seconds if the license is available. Since it may run for a long time, users can open another instance of MATLAB and work in the meantime on projects that do not require that specific toolbox.
