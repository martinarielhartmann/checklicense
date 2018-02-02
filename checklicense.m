function out = checklicense(toolbox,email)
% CHECKLICENSE - Check if the license of a MATLAB toolbox is free
% and receive an e-mail whenever you can use the toolbox
%
% CHECKLICENSE(TOOLBOX) outputs 1 if there is at least one free
% license for TOOLBOX and 0 if all licenses are in use. 
%
% Example: checklicense('Image_Toolbox')
%
% CHECKLICENSE(TOOLBOX,EMAIL) sends an e-mail to EMAIL whenever the
% license for TOOLBOX is available. CHECKLICENSE checks if the
% license is available every 60 seconds. If the license is inmediately
% available upon the function call, no e-mail will be
% sent. 
%
% Example: checklicense('Image_Toolbox','myemail@gmail.com')
%
% TOOLBOX can, for example, be any of the following:
%  
% 'Audio_System_Toolbox'
% 'Communication_Toolbox'
% 'Control_Toolbox'
% 'Curve_Fitting_Toolbox'
% 'Signal_Blocks'
% 'Database_Toolbox'
% 'Econometrics_Toolbox'
% 'Financial_Toolbox'
% 'Fuzzy_Toolbox'
% 'GADS_Toolbox'
% 'Image_Toolbox'
% 'MATLAB_Builder_for_Java'
% 'Compiler'
% 'Neural_Network_Toolbox'
% 'Optimization_Toolbox'
% 'Optimization_Toolbox'
% 'Distrib_Computing_Toolbox'
% 'PDE_Toolbox'
% 'RF_Blockset'
% 'RF_Toolbox'
% 'Signal_Toolbox'
% 'Power_System_Blocks'
% 'Simscape'
% 'Simulink_Control_Design'
% 'Statistics_Toolbox'
% 'Symbolic_Toolbox'
% 'Identification_Toolbox'
% 'Wavelet_Toolbox'


if nargin == 2

    subject = strcat('You are finally able to use',{' '},toolbox,{' '},['in ' ...
                        'MATLAB!']);

if checklic(toolbox) == 1
disp(strcat('Toolbox is available now! You will not receive any e-mail.'))

else
notyet = strcat({' - '},toolbox,[' is not available ' ...
                            'yet, so please wait. You will receive ' ...
                    'an e-mail whenever there is a free license.']);
    while checklic(toolbox) == 0
        disp(strcat(datestr(datetime),notyet{1}))
        pause(60) % wait for 60 seconds and try again
    end
    disp('The toolbox is available! Sending e-mail...')
    sendmail(email,subject{1})
end
end


out = checklic(toolbox);

function out = checklic(toolbox)
% CHECKLIC - Outputs 1 if the license is in use, otherwise 0

a = strcat(matlabroot,'/etc/maci64/lmutil lmstat -c',{' '},matlabroot,'/licenses/network.lic -a licence.snapshot -f'); 
b = toolbox;

command = strcat(a{1},{' '},b);

[status,result] = system(command{1});

parse = regexp(result, '[\f\n\r]', 'split');

findline = cellfun(@(x) strfind(x,'Users'),parse,'UniformOutput',false);

ind = find(~cellfun(@isempty,findline) == 1);

nums= str2double( regexp(parse{ind},'.* (\d+).* (\d+)','tokens','once') );

if ~isequal(nums(1),nums(2))
    out = 1;
else
    out = 0;
end    
