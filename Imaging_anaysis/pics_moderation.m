clear,clc
%% set the file path
% For window 10 
% file_path = fullfile('Z:','menon','projects','jinliu5','2019_ASD_MathWhiz')  
% box_path = fullfile('C:','Users','jinliu5','Box','Jin Liu','2019 ASD Learning Math Whizz')  
% For Mac 
oak_path = fullfile(filesep,'Volumes','menon','projects','jinliu5','2019_ASD_MathWhiz');
box_path = fullfile(filesep,'Users','jinjin','Box','Jin Liu','2019 ASD Learning Math Whizz');    
%  cd(oak_path)

%% plot RRB on ACC-NRP
load(fullfile(box_path,'7. data, scripts and results','analysis','Imaging','clinical analysis','moderation_RRB_ACC_NRP.mat'))
data=data_moderation_NRP;
% plot MTL
x1 = data(data(:,3)<10,5)% MTL
y1 = data(data(:,3)<10,4) % learning gains
x2 = data(data(:,3)>=10,5) % MTL 
y2 = data(data(:,3)>=10,4) % learning gains
[r1 p1]=corr(x1,y1)
[r2 p2]=corr(x2,y2)
output_name=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures',['corr_RRIBsub1_prepostRSA_LparaHipp_Acc_moderation.tiff']);
beh_corr_scatter_group_mod(x1,y1,x2,y2,'NRP',['low RRB: r = ' num2str(r1,3) ' p = ' num2str(p1,3)],['high RRB: r = ' num2str(r2,3) ' p = ' num2str(p2,3)],'Learning gain','moderation (R MTL)',output_name)

% plot IPS
x1 = data(data(:,3)<10,6) % IPS
y1 = data(data(:,3)<10,4) % learning gains
x2 = data(data(:,3)>=10,6) % IPS
y2 = data(data(:,3)>=10,4) % learning gains
[r1 p1]=corr(x1,y1)
[r2 p2]=corr(x2,y2)
output_name=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures',['corr_RRIBsub1_prepostRSA_RIPS_Acc_moderation.tiff']);
beh_corr_scatter_group_mod(x1,y1,x2,y2,'NRP',['low RRB: r = ' num2str(r1,3) ' p = ' num2str(p1,3)],['high RRB: r = ' num2str(r2,3) ' p = ' num2str(p2,3)],'Learning gain','moderation (L IPS)',output_name)
