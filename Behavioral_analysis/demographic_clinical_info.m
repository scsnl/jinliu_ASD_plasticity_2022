clear,clc
%% Basic demographic and clinical information of participants
% This script is used to calculate the basic information of demographic and
% clinical measures in ASD Whizz project
%
% Jin Liu
% 12/26/2020
%
%% setting file path and loading data
% setting project path
file_path = fullfile(filesep,'Users','jinjin','Box','Jin Liu','2019 ASD Learning Math Whizz');     

% loading data
load(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','scanbeh_sublist.mat')); % final subjectlist

% age gender IQ
[Gender, ~, ~] = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','Whiz_63subjs_FINAL.xlsx'),2,'B2:B64');
[age, ~, ~] = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','Whiz_63subjs_FINAL.xlsx'),2,'E2:E64');
[VIQ, ~, ~] = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','Whiz_63subjs_FINAL.xlsx'),2,'F2:F64');
[PIQ, ~, ~] = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','Whiz_63subjs_FINAL.xlsx'),2,'G2:G64');
[FIQ, ~, ~] = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','Whiz_63subjs_FINAL.xlsx'),2,'H2:H64');
[group, ~, ~] = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','Whiz_63subjs_FINAL.xlsx'),2,'C2:C64');

% ADI-R
load(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','all','Social_diag.mat')); 
load(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','all','verbal_diag.mat')); 
load(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','all','RRB_diag.mat')); 
load(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','all','Dev_diag.mat')); 

% ADOS
load(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','all','SAT.mat')); 
load(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','all','RRB.mat')); 
load(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','all','Severity.mat')); 
load(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','all','Total.mat')); 

% RRB subscore
PID_subscore = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','RRBI_subscores','ASD_PID_whiz_RRBScores.xlsx'),1,'A2:A40');
% insistence on sameness
[insistence, ~, ~] = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','RRBI_subscores','ASD_PID_whiz_RRBScores.xlsx'),1,'C2:C40');
% circumscribed interests
[circumscribed, ~, ~] = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','RRBI_subscores','ASD_PID_whiz_RRBScores.xlsx'),1,'D2:D40');
% repetitive motor behavior
[motor, ~, ~] = xlsread(fullfile(file_path,'7. data, scripts and results','data','neuropsych_data','RRBI','RRBI_subscores','ASD_PID_whiz_RRBScores.xlsx'),1,'E2:E40');

%% statistics for demographic measures
ASD_num=length(find(group==1));
TD_num=length(find(group==2));
ASD_male=length(find(group==1 & Gender==1));
TD_male=length(find(group==2 & Gender==1));

% group differences in gender distribution
[gendle_tbl,gender_chi2,gender_p,labels] = crosstab(group, Gender); % group by gender

% group differences in age distribution
NP_age = age;
age_ASD_m=mean(NP_age(find(group==1)));
age_TD_m=mean(NP_age(find(group==2)));
age_ASD_std=std(NP_age(find(group==1)));
age_TD_std=std(NP_age(find(group==2)));
[h,age_p,ci,age_stats]=ttest2(NP_age(find(group==1)),NP_age(find(group==2)));

% group differences in VIQ
VIQ_ASD_m=mean(VIQ(find(group==1)));
VIQ_TD_m=mean(VIQ(find(group==2)));
VIQ_ASD_std=std(VIQ(find(group==1)));
VIQ_TD_std=std(VIQ(find(group==2)));
[h,VIQ_p,ci,VIQ_stats]=ttest2(VIQ(find(group==1)),VIQ(find(group==2)));

% group differences in PIQ
PIQ_ASD_m=mean(PIQ(find(group==1)));
PIQ_TD_m=mean(PIQ(find(group==2)));
PIQ_ASD_std=std(PIQ(find(group==1)));
PIQ_TD_std=std(PIQ(find(group==2)));
[h,PIQ_p,ci,PIQ_stats]=ttest2(PIQ(find(group==1)),PIQ(find(group==2)));

% group differences in FIQ
FIQ_ASD_m=mean(FIQ(find(group==1)));
FIQ_TD_m=mean(FIQ(find(group==2)));
FIQ_ASD_std=std(FIQ(find(group==1)));
FIQ_TD_std=std(FIQ(find(group==2)));
[h,FIQ_p,ci,FIQ_stats]=ttest2(FIQ(find(group==1)),FIQ(find(group==2)));

%% description for clinical measures
% ADI-R
num_ASD_ADI = length(Social_diag(:,2));
Social_diag_m=mean(Social_diag(:,2));
Social_diag_std=std(Social_diag(:,2));
verbal_diag_m=mean(verbal_diag(:,2));
verbal_diag_std=std(verbal_diag(:,2));
RRB_diag_m=mean(RRB_diag(:,2));
RRB_diag_std=std(RRB_diag(:,2));
Dev_diag_m=mean(Dev_diag(:,2));
Dev_diag_std=std(Dev_diag(:,2));

% ADOS
num_ASD_ADOS = length(SAT(:,2));
SAT_m=mean(SAT(:,2));
SAT_std=std(SAT(:,2));
RRB_m=mean(RRB(:,2));
RRB_std=std(RRB(:,2));
Severity_m=mean(Severity(:,2));
Severity_std=std(Severity(:,2));
Total_m=mean(Total(:,2));
Total_std=std(Total(:,2));

% RRB-subscores
[~,IA,~]=intersect(PID_subscore,scanbeh_sublist(:,1));
IS_m=mean(insistence(find(~isnan(insistence)& insistence~=0)));
IS_std=std(insistence(find(~isnan(insistence)& insistence~=0)));
CI_m=mean(circumscribed(find(~isnan(circumscribed)& circumscribed~=0)));
CI_std=std(circumscribed(find(~isnan(circumscribed)& circumscribed~=0)));
motor_m=mean(motor(find(~isnan(motor)& motor~=0)));
motor_std=std(motor(find(~isnan(motor)& motor~=0)));

%% Table
disp('Table of demographic and clinical measures');
fprintf('-------------------------------------------------------------------------------\n');
disp(['  Measure         ASD(n = ' num2str(ASD_num) ')       TD(n = ' num2str(TD_num) ')      t/chi2   P-value']);
fprintf('-------------------------------------------------------------------------------\n');
fprintf('Gender(M/F)%9.0f%9.0f%9.0f%9.0f %9.2f%9.3f\n\n', gendle_tbl(1,1),gendle_tbl(1,2),gendle_tbl(2,1),gendle_tbl(2,2),gender_chi2,gender_p);
fprintf('Age(years)  %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', age_ASD_m,age_ASD_std,age_TD_m,age_TD_std,age_stats.tstat,age_p);
disp('WASI scale');
fprintf('VIQ         %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', VIQ_ASD_m,VIQ_ASD_std,VIQ_TD_m,VIQ_TD_std,VIQ_stats.tstat,VIQ_p);
fprintf('PIQ         %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', PIQ_ASD_m,PIQ_ASD_std,PIQ_TD_m,PIQ_TD_std,PIQ_stats.tstat,PIQ_p);
fprintf('FIQ         %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', FIQ_ASD_m,FIQ_ASD_std,FIQ_TD_m,FIQ_TD_std,FIQ_stats.tstat,FIQ_p);
disp(['ADI-R (n = ' num2str(num_ASD_ADI) ')']);
fprintf('Social      %9.2f%9.2f\n\n', Social_diag_m,Social_diag_std);
fprintf('Verbal      %9.2f%9.2f\n\n', verbal_diag_m,verbal_diag_std);
fprintf('RRB         %9.2f%9.2f\n\n', RRB_diag_m,RRB_diag_std);
fprintf('Development %9.2f%9.2f\n\n', Dev_diag_m,Dev_diag_std);
disp(['ADOS (n = ' num2str(num_ASD_ADOS) ')']);
fprintf('SAT         %9.2f%9.2f\n\n', SAT_m,SAT_std);
fprintf('RRB         %9.2f%9.2f\n\n', RRB_m,RRB_std);
fprintf('Severity    %9.2f%9.2f\n\n', Severity_m,Severity_std);
fprintf('Total       %9.2f%9.2f\n\n', Total_m,Total_std);
disp(['RRIB subscores']);
fprintf('Insistent on sameness     %9.2f%9.2f\n\n', IS_m,IS_std);
fprintf('Circumscribed interests   %9.2f%9.2f\n\n', CI_m,CI_std);
fprintf('Repetitive motor behavior %9.2f%9.2f\n\n', motor_m,motor_std);
fprintf('-------------------------------------------------------------------------------\n');
