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
% CHECKLIC - Outputs 1 if the license is in use (or if there is an
% error such as 'lmgrd not running'), otherwise 0

result = licenseuse(toolbox);

parse = regexp(result, '[\f\n\r]', 'split');

findline = cellfun(@(x) strfind(x,'Users'),parse,'UniformOutput',false);

ind = find(~cellfun(@isempty,findline) == 1);

nums= str2double( regexp(parse{ind},'.* (\d+).* (\d+)','tokens','once') );
try
    if ~isequal(nums(1),nums(2))
        out = 1;
    else
        out = 0;
    end    
catch
disp(['WARNING: there might be an error while trying to read data ' ...
      'from license server system. Trying again...'])
out = 1;
end

end

function lt = licenseuse(toolbox)
% LICENSEUSE - Use lmutil to obtain information on the users that are currently uses a license
%   Based on licenseuse version 1.3 by M. A. Hopcroft (https://se.mathworks.com/matlabcentral/fileexchange/28981-licenseuse)
cdir=cd;


% Determine path to lmutil
if isunix % v2.11
    lmExe='lmutil';
else
    lmExe='lmutil.exe';
end

lmPath=[matlabroot filesep 'bin' filesep computer('arch') filesep]; % prior to R2010b
if ~exist([lmPath lmExe],'file')
    lmPath=[matlabroot filesep 'etc' filesep computer('arch') filesep]; % R2010b+
    if ~exist([lmPath lmExe],'file')
        fprintf(1,'ERROR: "%s" not found in bin/ or etc/ locations!\n\n',lmExe);
        return
    end
end

cd(lmPath);


% Execute license manager command
[ltstat, lt]=system(['.' filesep 'lmutil lmstat -c "' matlabroot filesep 'licenses' filesep 'network.lic" -f ' toolbox]);
cd(cdir);

if ltstat ~= 0
    fprintf(1,'ERROR: "%s"\n',strtrim(lt));
    if strfind(lt, 'No such file')
        fprintf(1,'On Linux you may need to upgrade the package "lsb"\n  (see %s)\n',...
            'https://www.mathworks.com/support/solutions/en/data/1-GLXUHV/index.html?product=ML&solution=1-GLXUHV');
    end
    error('OS returned error %d when executing lmutil',ltstat);
end
end
end