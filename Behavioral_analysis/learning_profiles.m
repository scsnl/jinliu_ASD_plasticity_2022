clear,clc
%% Learning profiles
% This script is used to calculate and plot the learning rate by fitting a linear
% regression model for each participant on efficiency(accuracy/response time) performances 
% in computerized training task (pirate game) during five days training in ASD Whizz project
%
% Jin Liu
% 12/25/2020
%
%% setting file path and loading data
% setting project path
file_path = fullfile(filesep,'Users','jinjin','Box','Jin Liu','2019 ASD Learning Math Whizz');
addpath(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','stat_code','mixed_between_within_anova')); % two-way repeated measures anova.m
addpath(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','stat_code','RMAOV1')); % one-way repeated measures anova.m

% setting behavioral data path
load(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','info_sub63.mat')); % subjectlist of the project

% loading behavioral data
PID = xlsread(fullfile(file_path,'7. data, scripts and results','data','tutoring_data','PirateGame_All_Data_Jul312020.xlsx'),1,'A2:A14281'); % PID
day = xlsread(fullfile(file_path,'7. data, scripts and results','data','tutoring_data','PirateGame_All_Data_Jul312020.xlsx'),1,'F2:F14281'); % training day 
accuracy_whole = xlsread(fullfile(file_path,'7. data, scripts and results','data','tutoring_data','PirateGame_All_Data_Jul312020.xlsx'),1,'P2:P14281'); % accuracy
correct_responseT = xlsread(fullfile(file_path,'7. data, scripts and results','data','tutoring_data','PirateGame_All_Data_Jul312020.xlsx'),1,'N2:N14281'); % RT for correct trials

% exclude subjects with missing data or errors
exclude_list = [7309 7477 7626 7659 7690 7715 7832 7849];
% ASD:7309 7477 7626 7715 had missing data more than 1 day
% TD: 7690 7782 7839 ASD: 7849 had missing data of 1 day
% TD: 7659 had the computer problem/errors when collecting the data
% ASD: 7832 is an outlier/fail to fit learning curve (visual inspection on
% raw data: no response for >30% trials)

[tutoring_sublist, ~]=setdiff(Sub_info63(:,1),exclude_list); % subjectlist for current analysis
[~, ind]=setdiff(Sub_info63(:,1),tutoring_sublist);
Sub_info63(ind,:)=[];

% report number of participant for each group
num_ASD=length(find(Sub_info63(:,5)==1));
num_TD=length(find(Sub_info63(:,5)==2));

fprintf(['Number of participants for analysis: ASD = ' num2str(num_ASD) ' TD = ' num2str(num_TD) '\n\n']);

%% calculating ES
% Accuracy
ACC_tutoring = zeros(length(Sub_info63),6); % Accuracy from Day1 to Day5 for each participant
ACC_tutoring(:,1)=Sub_info63(:,1);
for i=1:length(Sub_info63)
    for j=1:5
        temp = accuracy_whole(find(PID==tutoring_sublist(i) & day == j));
        ACC_tutoring(i,j+1) = sum(temp)/length(temp); % (%)
    end
end

% Response time (only correct trials)
RT_tutoring = zeros(length(Sub_info63),6); % Mean RT from Day1 to Day5 for each participant
RT_tutoring(:,1)=Sub_info63(:,1);
for i=1:length(Sub_info63)
    for j=1:5
        temp = correct_responseT(find(PID == tutoring_sublist(i) & day == j & accuracy_whole == 1));
        RT_tutoring(i,j+1) = sum(temp)*0.001/length(temp); % (s)
    end
end

% Efficiency (ACC/RT)
EF_tutoring = zeros(length(Sub_info63),6);
EF_tutoring(:,1)=Sub_info63(:,1);
EF_tutoring(:,2:6) = ACC_tutoring(:,2:6)./(RT_tutoring(:,2:6));

%% Two-way (session/day by group) repeated measures ANOVA
% ES
fprintf('Two-way repeated measures ANOVA results for ES');
data_for_anova = [EF_tutoring(:,2);EF_tutoring(:,3);EF_tutoring(:,4);EF_tutoring(:,5);EF_tutoring(:,6)];
group = [Sub_info63(:,5);Sub_info63(:,5);Sub_info63(:,5);Sub_info63(:,5);Sub_info63(:,5)];
session_day = [ones(size(EF_tutoring,1),1);ones(size(EF_tutoring,1),1)*2;ones(size(EF_tutoring,1),1)*3;ones(size(EF_tutoring,1),1)*4;ones(size(EF_tutoring,1),1)*5];
sub_ind = [(1:length(EF_tutoring))';(1:length(EF_tutoring))';(1:length(EF_tutoring))';(1:length(EF_tutoring))';(1:length(EF_tutoring))'];
X = [data_for_anova group session_day sub_ind];
[SSQs, DFs, MSQs, Fs, Ps]=mixed_between_within_anova(X,0);
% effect size 
partial_eta_square = SSQs{3}/(SSQs{3}+SSQs{5})
partial_eta_square = SSQs{1}/(SSQs{1}+SSQs{2})
partial_eta_square = SSQs{4}/(SSQs{4}+SSQs{5})

% ACC for SI
fprintf('Two-way repeated measures ANOVA results for ACC');
data_for_anova = [ACC_tutoring(:,2);ACC_tutoring(:,3);ACC_tutoring(:,4);ACC_tutoring(:,5);ACC_tutoring(:,6)];
group = [Sub_info63(:,5);Sub_info63(:,5);Sub_info63(:,5);Sub_info63(:,5);Sub_info63(:,5)];
session_day = [ones(size(ACC_tutoring,1),1);ones(size(ACC_tutoring,1),1)*2;ones(size(ACC_tutoring,1),1)*3;ones(size(ACC_tutoring,1),1)*4;ones(size(ACC_tutoring,1),1)*5];
sub_ind = [(1:length(ACC_tutoring))';(1:length(ACC_tutoring))';(1:length(ACC_tutoring))';(1:length(ACC_tutoring))';(1:length(ACC_tutoring))'];
X = [data_for_anova group session_day sub_ind];
[SSQs, DFs, MSQs, Fs, Ps]=mixed_between_within_anova(X,0);
% effect size 
partial_eta_square = SSQs{3}/(SSQs{3}+SSQs{5})
partial_eta_square = SSQs{1}/(SSQs{1}+SSQs{2})
partial_eta_square = SSQs{4}/(SSQs{4}+SSQs{5})

% RT for SI
fprintf('Two-way repeated measures ANOVA results for RT');
data_for_anova = [RT_tutoring(:,2);RT_tutoring(:,3);RT_tutoring(:,4);RT_tutoring(:,5);RT_tutoring(:,6)];
group = [Sub_info63(:,5);Sub_info63(:,5);Sub_info63(:,5);Sub_info63(:,5);Sub_info63(:,5)];
session_day = [ones(size(RT_tutoring,1),1);ones(size(RT_tutoring,1),1)*2;ones(size(RT_tutoring,1),1)*3;ones(size(RT_tutoring,1),1)*4;ones(size(RT_tutoring,1),1)*5];
sub_ind = [(1:length(RT_tutoring))';(1:length(RT_tutoring))';(1:length(RT_tutoring))';(1:length(RT_tutoring))';(1:length(RT_tutoring))'];
X = [data_for_anova group session_day sub_ind];
[SSQs, DFs, MSQs, Fs, Ps]=mixed_between_within_anova(X,0);
% effect size 
partial_eta_square = SSQs{3}/(SSQs{3}+SSQs{5})
partial_eta_square = SSQs{1}/(SSQs{1}+SSQs{2})
partial_eta_square = SSQs{4}/(SSQs{4}+SSQs{5})

%% posthoc one-way repeated measures ANOVA
% ASD
fprintf('---------------------------------------------------------------------------\n');
fprintf('One-way repeated measures ANOVA results for ES in ASD\n\n');
depen_var = [EF_tutoring(find(Sub_info63(:,5)==1),2);EF_tutoring(find(Sub_info63(:,5)==1),3);EF_tutoring(find(Sub_info63(:,5)==1),4);EF_tutoring(find(Sub_info63(:,5)==1),5);EF_tutoring(find(Sub_info63(:,5)==1),6)];
indep_var = [ones(size(find(Sub_info63(:,5)==1),1),1);ones(size(find(Sub_info63(:,5)==1),1),1)*2;ones(size(find(Sub_info63(:,5)==1),1),1)*3;ones(size(find(Sub_info63(:,5)==1),1),1)*4;ones(size(find(Sub_info63(:,5)==1),1),1)*5];
sub_ind = [(1:length(find(Sub_info63(:,5)==1)))';(1:length(find(Sub_info63(:,5)==1)))';(1:length(find(Sub_info63(:,5)==1)))';(1:length(find(Sub_info63(:,5)==1)))';(1:length(find(Sub_info63(:,5)==1)))'];
X =[depen_var,indep_var,sub_ind];
[eta2]=RMAOV1(X,0.05); 
% effect size
partial_eta_square = eta2

% TD
fprintf('One-way repeated measures ANOVA results for ES in TD\n');
depen_var = [EF_tutoring(find(Sub_info63(:,5)==2),2);EF_tutoring(find(Sub_info63(:,5)==2),3);EF_tutoring(find(Sub_info63(:,5)==2),4);EF_tutoring(find(Sub_info63(:,5)==2),5);EF_tutoring(find(Sub_info63(:,5)==2),6)];
indep_var = [ones(size(find(Sub_info63(:,5)==2),1),1);ones(size(find(Sub_info63(:,5)==2),1),1)*2;ones(size(find(Sub_info63(:,5)==2),1),1)*3;ones(size(find(Sub_info63(:,5)==2),1),1)*4;ones(size(find(Sub_info63(:,5)==2),1),1)*5];
sub_ind = [(1:length(find(Sub_info63(:,5)==2)))';(1:length(find(Sub_info63(:,5)==2)))';(1:length(find(Sub_info63(:,5)==2)))';(1:length(find(Sub_info63(:,5)==2)))';(1:length(find(Sub_info63(:,5)==2)))'];
X =[depen_var,indep_var,sub_ind];
[eta2]=RMAOV1(X,0.05); 
% effect size
partial_eta_square = eta2

%% posthoc two-sample t-test
[h,p,ci,stats] = ttest2(EF_tutoring(find(Sub_info63(:,5)==1),2),EF_tutoring(find(Sub_info63(:,5)==2),2)); % day 1
t_session(1)=stats.tstat;p_session(1)=p; df_session(1)=stats.df; 
[h,p,ci,stats] = ttest2(EF_tutoring(find(Sub_info63(:,5)==1),3),EF_tutoring(find(Sub_info63(:,5)==2),3)); % day 2
t_session(2)=stats.tstat;p_session(2)=p; df_session(2)=stats.df;
[h,p,ci,stats] = ttest2(EF_tutoring(find(Sub_info63(:,5)==1),4),EF_tutoring(find(Sub_info63(:,5)==2),4)); % day 3
t_session(3)=stats.tstat;p_session(3)=p; df_session(3)=stats.df;
[h,p,ci,stats] = ttest2(EF_tutoring(find(Sub_info63(:,5)==1),5),EF_tutoring(find(Sub_info63(:,5)==2),5)); % day 4
t_session(4)=stats.tstat;p_session(4)=p; df_session(4)=stats.df;
[h,p,ci,stats] = ttest2(EF_tutoring(find(Sub_info63(:,5)==1),6),EF_tutoring(find(Sub_info63(:,5)==2),6)); % day 5
t_session(5)=stats.tstat;p_session(5)=p; df_session(5)=stats.df;
mean_sd = [mean(EF_tutoring(find(Sub_info63(:,5)==1),2:6))',std(EF_tutoring(find(Sub_info63(:,5)==1),2:6))',mean(EF_tutoring(find(Sub_info63(:,5)==2),2:6))',std(EF_tutoring(find(Sub_info63(:,5)==2),2:6))'];

d(1) = computeCohen_d(EF_tutoring(find(Sub_info63(:,5)==1),2),EF_tutoring(find(Sub_info63(:,5)==2),2));
d(2) = computeCohen_d(EF_tutoring(find(Sub_info63(:,5)==1),3),EF_tutoring(find(Sub_info63(:,5)==2),3));
d(3) = computeCohen_d(EF_tutoring(find(Sub_info63(:,5)==1),4),EF_tutoring(find(Sub_info63(:,5)==2),4));
d(4) = computeCohen_d(EF_tutoring(find(Sub_info63(:,5)==1),5),EF_tutoring(find(Sub_info63(:,5)==2),5));
d(5) = computeCohen_d(EF_tutoring(find(Sub_info63(:,5)==1),6),EF_tutoring(find(Sub_info63(:,5)==2),6));

disp('Two-sample Ttest Analysis Table for ES in each day')
fprintf('-------------------------------------------------------------------------------\n');
disp('        ASD(mean) ASD(sd) TD(mean)  TD(sd)     t       df    Cohen''s d    P')
fprintf('-------------------------------------------------------------------------------\n');
fprintf('Day1 %9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f\n\n', mean_sd(1,1),mean_sd(1,2),mean_sd(1,3),mean_sd(1,4),t_session(1),df_session(1),d(1),p_session(1));
fprintf('Day2 %9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f\n\n', mean_sd(2,1),mean_sd(2,2),mean_sd(2,3),mean_sd(2,4),t_session(2),df_session(2),d(2),p_session(2));
fprintf('Day3 %9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f\n\n', mean_sd(3,1),mean_sd(3,2),mean_sd(3,3),mean_sd(3,4),t_session(3),df_session(3),d(3),p_session(3));
fprintf('Day4 %9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f\n\n', mean_sd(4,1),mean_sd(4,2),mean_sd(4,3),mean_sd(4,4),t_session(4),df_session(4),d(4),p_session(4));
fprintf('Day5 %9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f%9.2f\n\n', mean_sd(5,1),mean_sd(5,2),mean_sd(5,3),mean_sd(5,4),t_session(5),df_session(5),d(5),p_session(5));
fprintf('-------------------------------------------------------------------------------\n');

%% save ES measures
EF_tutoring_title={'PID','D1','D2','D3','D4','D5'};
save(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','tutoring performance','EF_tutoring.mat'),'EF_tutoring','EF_tutoring_title');

%% plot group-average learning curve across day
output_path =fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','ASD_TD_training_day1_5.tiff');
line_averge_twogroup(EF_tutoring(find(Sub_info63(:,5)==1),2:6),EF_tutoring(find(Sub_info63(:,5)==2),2:6),[255/255 166/255 158/255],[157/255,211/255,250/255], [0.1 0.35], {'Day1','Day2','Day3','Day4','Day5'}, 'Training task','Efficiency score', output_path);

%% learning rate analysis
% calculating learning rate
% fitting with linear regression model for each participant
for i = 1:length(Sub_info63)
  [p] = polyfit([1:5]',EF_tutoring(i,2:6)',1);
  lr(i,1)=p(1);
end
x = lr(Sub_info63(:,5)==1);% ASD learning rate
y = lr(Sub_info63(:,5)==2);% TD learning rate

% statistics for group differences in learning rate
[h,p,ci,stats] = ttest2(x,y);
clear d
d = computeCohen_d(x,y);

disp('Two-sample Ttest Analysis Table for learning rate')
fprintf('------------------------------------------------------------------------------\n');
disp('      ASD(mean) ASD(sd) TD(mean) TD(sd)     t       df        d       P')
fprintf('------------------------------------------------------------------------------\n');
fprintf('  %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean(x),std(x),mean(y),std(y),stats.tstat,stats.df,d,p);
fprintf('------------------------------------------------------------------------------\n');
    
% plot learning rate 
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','ASD_TD_trainingrate.tiff');
bar_group(x,y,[-0.06 0.13],[-0.05:0.05:0.1],[-0.05:0.05:0.1], {'ASD','TD'}, 'Learning rate', output_path);

% save learning rate measures 
learning_rate_ES(:,1)=Sub_info63(:,1);
learning_rate_ES(:,2)=Sub_info63(:,5);
learning_rate_ES(:,3)=lr;

learning_rate_ES_title={'PID','ASD/TD','learning rate (ES)'};
save(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','tutoring performance','learning_rate_ES.mat'),'learning_rate_ES','learning_rate_ES_title');
