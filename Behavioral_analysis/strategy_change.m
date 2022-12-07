clear,clc
%% strategy changes
% This script is used to calculate and plot the accuracy performance on math varification task 
% before and after training in ASD Whizz project
%
% Jin Liu
% 12/26/2020
%% setting file path and loading data
% setting project path
box_path = fullfile(filesep,'Users','jinjin','Box','Jin Liu','2019 ASD Learning Math Whizz');
oak_path = fullfile(filesep,'Volumes','menon','projects','jinliu5','2019_ASD_MathWhiz');

% load the data
load(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','scan task performance','PID_train_group.mat')); % train group A/B
load(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','scan task performance','scanbeh_sublist.mat'));% final subjectlist
PID = xlsread(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'B2:B4124'); % PID
[~,~,pre_post] = xlsread(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'A2:A4124'); % pre post
[~,~,traingroup] = xlsread(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'V2:V4124'); % problem's training group index
triallable = xlsread(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'P2:P4124'); % formal trials index
accuracy_first = xlsread(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'I2:I4124'); % acc
strategy = xlsread(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'X2:X4124'); % strategy report
equationRT = xlsread(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'O2:O4124'); % RT
[spoilRT,~,~] = xlsread(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'W2:W4124'); % error RT index

% fill the Nan values to make all variable with same rows
strategy_fix(1:3,1) = NaN;
strategy_fix(4:4123,1) = strategy;
accuracy_first_fix(1:3,1) = NaN;
accuracy_first_fix(4:4123,1) = accuracy_first;
equationRT_fix(1:3,1) = NaN;
equationRT_fix(4:4123,1) = equationRT;
triallable_fix(1:3,1) = NaN;
triallable_fix(4:4123,1)=triallable;
spoilRT_fix(1:61,1) = NaN;
spoilRT_fix(62:4044,1)=spoilRT;
spoilRT_fix(4045:4123,1) = NaN;
clear strategy accuracy_first equationRT triallable

% subjectlist for strategy
strategy_sublist=unique(PID);
final_scanbeh_sublist=intersect(strategy_sublist(:,1),scanbeh_sublist(:,1));

new_PID_train_group(:,1)=final_scanbeh_sublist;
 for i=1:length(final_scanbeh_sublist)
    new_PID_train_group(i,2)=PID_train_group(find(PID_train_group==final_scanbeh_sublist(i)),2);
 end
clear PID_train_group

 for i=1:length(final_scanbeh_sublist)
    final_scanbeh_sublist(i,2:13)=scanbeh_sublist(find(scanbeh_sublist(:,1)==final_scanbeh_sublist(i,1)),2:13);
 end

% problems training set index (A/B)
 for j=1:28
       if strcmp(traingroup(j+3),'A')
           item_traingroup(j,1) = 1;
       elseif strcmp(traingroup(j+3),'B')
           item_traingroup(j,1) = 2;
       end
 end
% subjectlist for each training group (A/B)
SetA_sublist=final_scanbeh_sublist(find(new_PID_train_group(:,2)==1),1:5); 
SetB_sublist=final_scanbeh_sublist(find(new_PID_train_group(:,2)==2),1:5);
% list of problems for each training set
SetA_item=find(item_traingroup==1);
SetB_item=find(item_traingroup==2);

%% estimating strategy perferece
% reorganize the data according to traning set and training problems
% pre 
% Trained (A) at pre
item_str_pre_SetA_trained = zeros(length(find(new_PID_train_group(:,2)==1)),14);
for i=1:length(SetA_sublist)
    for j=1:14
        if ~isempty(strategy_fix(find(PID==SetA_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & triallable_fix == SetA_item(j) & accuracy_first_fix ==1)))
            item_str_pre_SetA_trained(i,j)=strategy_fix(find(PID==SetA_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & triallable_fix == SetA_item(j) & accuracy_first_fix ==1));
        end
    end
end

% Trained (B) at pre
item_str_pre_SetB_trained = zeros(length(find(new_PID_train_group(:,2)==2)),14);
for i=1:length(SetB_sublist)
    for j=1:14
        if ~isempty(strategy_fix(find(PID==SetB_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & triallable_fix == SetB_item(j) & accuracy_first_fix ==1)))
            item_str_pre_SetB_trained(i,j)=strategy_fix(find(PID==SetB_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & triallable_fix == SetB_item(j) & accuracy_first_fix ==1));
        end
    end
end

% Untrained (A) at pre
 item_str_pre_SetA_untrained = zeros(length(find(new_PID_train_group(:,2)==1)),14);
 for i=1:length(SetA_sublist)
    for j=1:14
        if ~isempty(strategy_fix(find(PID==SetA_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & triallable_fix == SetB_item(j) & accuracy_first_fix ==1)));
        item_str_pre_SetA_untrained(i,j)=strategy_fix(find(PID==SetA_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & triallable_fix == SetB_item(j) & accuracy_first_fix ==1));
        end
    end
 end

% Untrained (B) at pre
item_str_pre_SetB_untrained = zeros(length(find(new_PID_train_group(:,2)==2)),14);
 for i=1:length(SetB_sublist)
    for j=1:14
        if ~isempty(strategy_fix(find(PID==SetB_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & triallable_fix == SetA_item(j) & accuracy_first_fix ==1)));
        item_str_pre_SetB_untrained(i,j)=strategy_fix(find(PID==SetB_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & triallable_fix == SetA_item(j) & accuracy_first_fix ==1));
        end
    end
 end
 
% post
% Trained (A) at post
item_str_post_SetA_trained = zeros(length(find(new_PID_train_group(:,2)==1)),14);
 for i=1:length(SetA_sublist)
    for j=1:14
        if ~isempty(strategy_fix(find(PID==SetA_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan') & triallable_fix == SetA_item(j) & accuracy_first_fix ==1)));
        item_str_post_SetA_trained(i,j)=strategy_fix(find(PID==SetA_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan') & triallable_fix == SetA_item(j) & accuracy_first_fix ==1));
        end
    end
 end

% Trained (B) at post
item_str_post_SetB_trained = zeros(length(find(new_PID_train_group(:,2)==2)),14);
for i=1:length(SetB_sublist)
    for j=1:14
        if ~isempty(strategy_fix(find(PID==SetB_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan') & triallable_fix == SetB_item(j) & accuracy_first_fix ==1)));
            item_str_post_SetB_trained(i,j)=strategy_fix(find(PID==SetB_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan') & triallable_fix == SetB_item(j) & accuracy_first_fix ==1));
        end
    end
end
 
% Untrained (A) at post
item_str_post_SetA_untrained = zeros(length(find(new_PID_train_group(:,2)==1)),14);
for i=1:length(SetA_sublist)
    for j=1:14
        if ~isempty(strategy_fix(find(PID==SetA_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan') & triallable_fix == SetB_item(j) & accuracy_first_fix ==1)));
            item_str_post_SetA_untrained(i,j)=strategy_fix(find(PID==SetA_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan') & triallable_fix == SetB_item(j) & accuracy_first_fix ==1));
        end
    end
end

% Untrained (B) at post
item_str_post_SetB_untrained = zeros(length(find(new_PID_train_group(:,2)==2)),14);
for i=1:length(SetB_sublist)
    for j=1:14
        if ~isempty(strategy_fix(find(PID==SetB_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan') & triallable_fix == SetA_item(j) & accuracy_first_fix ==1)));
            item_str_post_SetB_untrained(i,j)=strategy_fix(find(PID==SetB_sublist(i,1) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan') & triallable_fix == SetA_item(j) & accuracy_first_fix ==1));
        end
    end
end


% combined Set A and Set B
 % Set A (1:32)
sub_preference(:,1)=SetA_sublist(:,1);
sub_preference(:,2)=SetA_sublist(:,3);% age
sub_preference(:,3)=SetA_sublist(:,4);% gender
sub_preference(:,4)=SetA_sublist(:,5);% group
% trained
[M,F,~]=mode(item_str_pre_SetA_trained');
sub_preference(:,5)=M';% preference at pre
sub_preference(:,6)=F'./14;% preference rate at pre
[M,F,~]=mode(item_str_post_SetA_trained');
sub_preference(:,7)=M';% preference at post
sub_preference(:,8)=F'./14;% preference rate at post
% untrained
[M,F,~]=mode(item_str_pre_SetA_untrained');
sub_preference(:,9)=M';% preference at pre
sub_preference(:,10)=F'./14;% preference rate at pre
[M,F,~]=mode(item_str_post_SetA_untrained');
sub_preference(:,11)=M';% preference at post
sub_preference(:,12)=F'./14;% preference rate at post

% Set B
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),1)=SetB_sublist(:,1);
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),2)=SetB_sublist(:,3);% age
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),3)=SetB_sublist(:,4);% gender
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),4)=SetB_sublist(:,5);% group
% trained
[M,F,~]=mode(item_str_pre_SetB_trained');
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),5)=M';% preference at pre
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),6)=F'./14;% preference rate at pre
[M,F,~]=mode(item_str_post_SetB_trained');
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),7)=M';% preference at post
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),8)=F'./14;% preference rate at post
% untrained
[M,F,~]=mode(item_str_pre_SetB_untrained');
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),9)=M';% preference at pre
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),10)=F'./14;% preference rate at pre
[M,F,~]=mode(item_str_post_SetB_untrained');
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),11)=M';% preference at post
sub_preference(length(SetA_sublist)+1:(length(SetA_sublist)+length(SetB_sublist)),12)=F'./14;% preference rate at post

% data quality control
[C,ind,~] = intersect(sub_preference(:,1),[7648 7849]);
% notes showing 7648 and 7849 did not cooperate in the strategy assessment
sub_preference(ind,:)=[];

num_ASD = length(find(sub_preference(:,4)==1));
num_TD = length(find(sub_preference(:,4)==2));
fprintf(['Number of participants for analysis: ASD = ' num2str(num_ASD) ' TD = ' num2str(num_TD) '\n\n']);

% save strategy preference data
sub_preference_title={'PID';'age';'gender';'group';'preference at pre trained';'preference rate at pre trained';'preference at post trained';'preference rate at post trained';'preference at pre untrained';'preference rate at pre untrained';'preference at post untrained';'preference rate at post untrained'};
save(fullfile(box_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','sub_preference.mat'),'sub_preference','sub_preference_title');

%% strategy perference selection (trained)
% trained strategy pre 
for i=1:length(sub_preference)
    if  sub_preference(i,5)==40 % using retrieval 
        sub_preference(i,13)=1;
    else
        sub_preference(i,13)=2; % not using retrieval 
    end
end
data_for_ttest=sub_preference(:,13);
group = [sub_preference(:,4)];
[tbl,chi2,p,labels] = crosstab(group, data_for_ttest);
phi = sqrt(chi2/sum(sum(tbl,2)));

df = 1;
disp('Chi-square Ttest Analysis Table for group vs. strategy (trained) at pre')
fprintf('---------------------------------------------------------------------------\n');
disp('        Memory  Procedure  Chi2      df      phi       P')
fprintf('---------------------------------------------------------------------------\n');
fprintf('ASD %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', tbl(1,1),tbl(1,2),chi2(1),df,phi,p(1));
fprintf('TD  %9.2f%9.2f\n\n', tbl(2,1),tbl(2,2));
fprintf('---------------------------------------------------------------------------\n\n');

% pics
output_path=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures','ASD_TD_strategy_preferecne_train_pre.tiff');
bar_mean_group_strategy(tbl,[0 35],[0:10:30],[0:10:30], {'ASD';'TD'}, 'Participants (N)','Pre', output_path);

% trained strategy post 
for i=1:length(sub_preference)
    if  sub_preference(i,7)==40 % using retrieval after training
        sub_preference(i,14)=1;
    else
        sub_preference(i,14)=2; % not using retrieval after training
    end
end
data_for_ttest=sub_preference(:,14);
group = [sub_preference(:,4)];
[tbl,chi2,p,labels] = crosstab(group, data_for_ttest);
phi = sqrt(chi2/sum(sum(tbl,2)));

df = 1;
disp('Chi-square Ttest Analysis Table for group vs. strategy (trained) at post')
fprintf('---------------------------------------------------------------------------\n');
disp('        Memory  Procedure  Chi2      df      phi      P')
fprintf('---------------------------------------------------------------------------\n');
fprintf('ASD %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', tbl(1,1),tbl(1,2),chi2(1),df,phi,p(1));
fprintf('TD  %9.2f%9.2f\n\n', tbl(2,1),tbl(2,2));
fprintf('---------------------------------------------------------------------------\n\n');

% pics
output_path=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures','ASD_TD_strategy_preferecne_train_post.tiff');
bar_mean_group_strategy(tbl,[0 35],[0:10:30],[0:10:30], {'ASD';'TD'}, 'Participants (N)','Post', output_path);


%% strategy perference selection (untrained)
% untrained strategy pre
for i=1:length(sub_preference)
   if sub_preference(i,9)==40 % using retrieval 
       sub_preference(i,15)=1;
   else 
       sub_preference(i,15)=2; % not using retrieval 
   end
end
data_for_ttest=sub_preference(:,15);
group = [sub_preference(:,4)];
[tbl,chi2,p,labels] = crosstab(group, data_for_ttest);
phi = sqrt(chi2/sum(sum(tbl,2)));

df = 1;
disp('Chi-square Ttest Analysis Table for group vs. strategy (untrained) at pre')
fprintf('---------------------------------------------------------------------------\n');
disp('        Memory  Procedure  Chi2      df      phi    P')
fprintf('---------------------------------------------------------------------------\n');
fprintf('ASD %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', tbl(1,1),tbl(1,2),chi2(1),df,phi,p(1));
fprintf('TD  %9.2f%9.2f\n\n', tbl(2,1),tbl(2,2));
fprintf('---------------------------------------------------------------------------\n\n');

% pics
output_path=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures','supplementary','ASD_TD_strategy_preferecne_untrain_pre.tiff');
bar_mean_group_strategy(tbl,[0 30],[0:10:30],[0:10:30], {'ASD';'TD'}, 'Participants (N)','Pre', output_path);


% untrained strategy post
for i=1:length(sub_preference)
   if sub_preference(i,11)==40 % using retrieval 
       sub_preference(i,16)=1;
   else 
       sub_preference(i,16)=2; % not using retrieval 
   end
end
data_for_ttest=sub_preference(:,16);
group = [sub_preference(:,4)];
[tbl,chi2,p,labels] = crosstab(group, data_for_ttest);
phi = sqrt(chi2/sum(sum(tbl,2)));

df = 1;
disp('Chi-square Ttest Analysis Table for group vs. strategy (untrained) at post')
fprintf('---------------------------------------------------------------------------\n');
disp('        Memory  Procedure  Chi2      df      phi       P')
fprintf('---------------------------------------- -----------------------------------\n');
fprintf('ASD %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', tbl(1,1),tbl(1,2),chi2(1),df,phi,p(1));
fprintf('TD  %9.2f%9.2f\n\n', tbl(2,1),tbl(2,2));
fprintf('---------------------------------------------------------------------------\n\n');

% pics
output_path=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures','supplementary','ASD_TD_strategy_preferecne_untrain_post.tiff');
bar_mean_group_strategy(tbl,[0 30],[0:10:30],[0:10:30], {'ASD';'TD'}, 'Participants (N)','Post', output_path);


%% trained vs. untrained strategy separation
% trained vs. untrained strategy changes in ASD (pre)
data_for_ttest=[sub_preference(find(sub_preference(:,4)==1),13);sub_preference(find(sub_preference(:,4)==1),15)];
train_untrained = [ones(length(sub_preference(find(sub_preference(:,4)==1),13)),1);ones(length(sub_preference(find(sub_preference(:,4)==1),15)),1).*2];
[tbl,chi2,p,labels] = crosstab(train_untrained, data_for_ttest);
df = 1;
phi = sqrt(chi2/sum(sum(tbl,2)));

disp('Chi-square Ttest Analysis Table for problem vs stategy in ASD at pre');
fprintf('-----------------------------------------------------------------\n');
disp('              Memory  Procedure   Chi2      df      phi      P')
fprintf('-----------------------------------------------------------------\n');
fprintf('Trained    %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', tbl(1,1),tbl(1,2),chi2(1),df,phi,p(1));
fprintf('Untrained  %9.2f%9.2f\n\n', tbl(2,1),tbl(2,2));
fprintf('-----------------------------------------------------------------\n\n');

% pics
output_path=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures','ASD_strategy_preferecne_train_untrain_pre.tiff');
bar_mean_group_strategy(tbl,[0 35],[0:10:30],[0:10:30], {'Trained';'Untrained'}, 'Participants (N)','Pre', output_path);

% trained vs. untrained strategy changes in ASD (post)
data_for_ttest=[sub_preference(find(sub_preference(:,4)==1),14);sub_preference(find(sub_preference(:,4)==1),16)];
train_untrained = [ones(length(sub_preference(find(sub_preference(:,4)==1),14)),1);ones(length(sub_preference(find(sub_preference(:,4)==1),16)),1).*2];
[tbl,chi2,p,labels] = crosstab(train_untrained, data_for_ttest);
df = 1;
phi = sqrt(chi2/sum(sum(tbl,2)));

disp('Chi-square Ttest Analysis Table for problem vs stategy in ASD at post');
fprintf('-----------------------------------------------------------------\n');
disp('              Memory  Procedure  Chi2       df      phi        P')
fprintf('-----------------------------------------------------------------\n');
fprintf('Trained    %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', tbl(1,1),tbl(1,2),chi2(1),df,phi,p(1));
fprintf('Untrained  %9.2f%9.2f\n\n', tbl(2,1),tbl(2,2));
fprintf('-----------------------------------------------------------------\n\n');

% pics
output_path=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures','ASD_strategy_preferecne_train_untrain_post.tiff');
bar_mean_group_strategy(tbl,[0 30],[0:10:30],[0:10:30], {'Trained';'Untrained'}, 'Participants (N)','Post', output_path);

% trained vs. untrained strategy changes in TD (pre)
data_for_ttest=[sub_preference(find(sub_preference(:,4)==2),13);sub_preference(find(sub_preference(:,4)==2),15)];
train_untrained = [ones(length(sub_preference(find(sub_preference(:,4)==2),13)),1);ones(length(sub_preference(find(sub_preference(:,4)==2),15)),1).*2];
[tbl,chi2,p,labels] = crosstab(train_untrained, data_for_ttest);
df = 1;
phi = sqrt(chi2/sum(sum(tbl,2)));


disp('Chi-square Ttest Analysis Table for problem vs stategy in TD at pre');
fprintf('----------------------------------------------------------------\n');
disp('              Memory  Procedure  Chi2      df      phi       P')
fprintf('----------------------------------------------------------------\n');
fprintf('Trained   %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', tbl(1,1),tbl(1,2),chi2(1),df,phi,p(1));
fprintf('Untrained %9.2f%9.2f\n\n', tbl(2,1),tbl(2,2));
fprintf('----------------------------------------------------------------\n\n');

% pics
output_path=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures','TD_strategy_preferecne_train_untrain_pre.tiff');
bar_mean_group_strategy(tbl,[0 35],[0:10:30],[0:10:30], {'Trained';'Untrained'}, 'Participants (N)','Pre', output_path);

% trained vs. untrained strategy changes in TD (post)
data_for_ttest=[sub_preference(find(sub_preference(:,4)==2),14);sub_preference(find(sub_preference(:,4)==2),16)];
train_untrained = [ones(length(sub_preference(find(sub_preference(:,4)==2),14)),1);ones(length(sub_preference(find(sub_preference(:,4)==2),16)),1).*2];
[tbl,chi2,p,labels] = crosstab(train_untrained, data_for_ttest);
df = 1;
phi = sqrt(chi2/sum(sum(tbl,2)));

disp('Chi-square Ttest Analysis Table for problem vs stategy in TD at post');
fprintf('-------------------------------------------------------------------\n');
disp('             Memory  Procedure    Chi2      df      phi       P')
fprintf('-------------------------------------------------------------------\n');
fprintf('Trained    %9.2f%9.2f%9.2f%9.2f%9.2f%9.3f\n\n', tbl(1,1),tbl(1,2),chi2(1),df,phi,p(1));
fprintf('Untrained  %9.2f%9.2f\n\n', tbl(2,1),tbl(2,2));
fprintf('-------------------------------------------------------------------\n\n');
% pics
output_path=fullfile(box_path,'7. data, scripts and results','results','Behavior','figures','TD_strategy_preferecne_train_untrain_post.tiff');
bar_mean_group_strategy(tbl,[0 30],[0:10:30],[0:10:30], {'Trained';'Untrained'}, 'Participants (N)','Post', output_path)
