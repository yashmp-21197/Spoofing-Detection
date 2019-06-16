genuine_scores = rand(1,5);
impostor_scores = rand(1,5);
FAR_val_per = 10;
pas0 = 10000;

[EER confInterEER OP confInterOP] = EER_DET_conf(genuine_scores,impostor_scores,FAR_val_per,pas0,false);
EER

f = figure;
t = uitable(f);
t.ColumnName = {'Type','LMS','RLMS','IF','BPD','GD','MGD','AVG'};
t.ColumnEditable = true;
d = {'s1-s5 (known)',10,20,30,40,50,60,35;'s6-s9 (unknown)',10,20,30,40,50,60,35;'s10 (unknown)',10,20,30,40,50,60,35};
t.Data = d;
t.Position = [20 20 650 100];

Type = {'s1-s5 (known)';'s6-s9 (unknown)';'s10 (unknown)'};
LMS = [10;20;30];
LMS = num2str(LMS);
RLMS = [10;20;30];
RLMS = num2str(RLMS);
IF = [10;20;30];
IF = num2str(IF);
BPD = [10;20;30];
BPD = num2str(BPD);
GD = [10;20;30];
GD = num2str(GD);
MGD = [10;20;30];
MGD = num2str(MGD);
AVG = [10;20;30];
AVG = num2str(AVG);
T = table(Type,LMS,RLMS,IF,BPD,GD,MGD,AVG);
c = table2cell(T)
m = cellstr(c)
msgbox(c,'accuracy and eer');