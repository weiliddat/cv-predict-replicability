
PROC IMPORT OUT=ToM1
       DATAFILE= "x\KiddCastano\Data&Analysis\data_used\348.xlsx"
       DBMS= xlsx REPLACE;


RUN;
quit;

data TOM_1;
set TOM1;

subj = _n_;

wrong = sum (of art_1 - art_65);
art_c = sum (of correct_1 - correct_65);
art = art_c - wrong;
sqrt_art = sqrt(art);
s_art = art;

Text = "Nothing at all";
if Bird_1 = 1 then Text = "Bird";
if Bamboo_1 = 1 then Text = "Bamboo";
if Potato_1 = 1 then Text = "Potato";
if Chekhov_1 = 1 then Text = "Chekhov";
if DeLillo_1 = 1 then Text = "DeLillo";
if Davis_1 = 1 then Text = "Davis";

Condition = "No Condition Given";
if Bird_1 = 1 then Condition = "NonFiction";
if Bamboo_1 = 1 then Condition = "NonFiction";
if Potato_1 = 1 then Condition = "NonFiction";
if Chekhov_1 = 1 then Condition = "Fiction";
if DeLillo_1 = 1 then Condition = "Fiction";
if Davis_1 = 1 then Condition = "Fiction";

Chekhov_Time = mean (of Chek_Time1 - Chek_Time2) ;
Davis_Time = mean (of Davi_Time1 - Davi_Time4);
DeLillo_Time = mean (of 	Deli_Time1- Deli_Time7);
Potato_Time = mean (of Pota_time1 - Pota_time5);
Bamboo_Time = mean (of Bamb_Time1 - Bamb_Time3);
Bird_Time = mean (of Bird_Time1 - Bird_Time3);

Time = .;
if text = "Chekhov" then Time = Chekhov_time;
if text = "Davis" then Time = Davis_Time;
if text = "DeLillo" then Time = DeLillo_Time;
if text = "Bird" then Time = bird_time;
if text = "Bamboo" then Time = bamboo_time;
if text = "Potato" then Time = potato_time;


Trans_2 = 8 - Trans_2r_1;
Trans_5 = 8 - Trans_5r_1;
Trans_9 = 8 - Trans_9r_1;

Transportation = mean (of Trans_1_1 Trans_2 Trans_3_1 Trans_4_1 Trans_5 Trans_6_1 Trans_7_1 Trans_8_1 Trans_9 Trans_10_1 Trans_11_1 Trans_12_1);

CH_Determined = EMO_Check_1;
CH_Attentive = EMO_check_2;
CH_Alert = EMO_check_3;
CH_Inspired = EMO_check_4;
CH_Active = EMO_check_5;
CH_Afraid = EMO_check_6;
CH_Nervous = EMO_check_7;
CH_Upset = EMO_check_8;
CH_Ashamed = EMO_check_9;
CH_Hostile = EMO_check_10;
CH_Happy = EMO_check_11;
CH_Sad = EMO_check_12;

PA = mean (of ch_Determined ch_attentive ch_alert ch_inspired ch_active);
NA = mean (of ch_afraid ch_nervous ch_upset ch_ashamed CH_hostile);


Gender = "None Given";
if Gender_1 = 1 then Gender = "Male";
if Gender_2 = 1 then Gender = "Female";

PolAff = mean (of Gen_Pol_1 Soc_Pol_1 Fis_Pol_1);




FB = "False Belief";
if NOFB_INST = 1 then FB = "No False Bel";

CorrectBox = FB_TOM_1;
if FB = "No False Bel" then CorrectBox = FB_NoTOM_1;

FalseBox = FB_TOM_4;
if FB = "No False Bel" then FalseBox = fb_NoTom_4;

 total_tom = sum (of fb_tom_1 fb_tom_2 fb_tom_3 fb_tom_4);
if FB = "No False Bel" then total_tom = sum (of fb_notom_1 - fb_notom_4 );

 total_false = sum (of fb_tom_2 - fb_tom_4);
if FB = "No False Bel" then total_false = sum (of fb_notom_2 - fb_notom_4 );


PT_Acc = correctbox - falsebox;
if total_tom < 50 then pt_acc = .;


cAnticipate = 0;
if Anticipate = 2 then cAnticipate = 1;
if canticipate = 0 then t_anticip_3 = .;

cSkeptical = 0;
if Skeptical  = 3 then cSkeptical = 1;
if cskeptical = 0 then t_skeptic_3 = .;

cRegretful = 0;
if Regretful  = 3 then cRegretful = 1;
if cregretful = 0 then t_regret_3 = .;

cCautious_1 = 0;
if Cautious_1 = 1 then cCautious_1 = 1;
if ccautious_1 = 0 then t_caut_1_3 = .;

cPreocc_1 = 0;
if Preocc_1  = 4 then cPreocc_1  = 1;
if cpreocc_1 = 0 then t_preocc_1_3 = .;

cDespondent = 0;
if Despondent =  1 then cDespondent = 1;
if cdespondent = 0 then t_despond_3 = .;

cUneasy = 0;
if Uneasy =  3 then cUneasy = 1;
if cuneasy = 0 then t_uneasy_3 = .;

cFantasy_1  = 0;
if Fantasy_1  = 2 then cFantasy_1  = 1;
if cfantasy_1 = 0 then t_fant_1_3 = .;

cWorried = 0;
if Worried  = 3 then cWorried = 1;
if cworried = 0 then t_worried_3 = .;

cInsisting  = 0;
if Insisting = 	2 then cInsisting  = 1;
if cinsisting = 0 then t_insist_3 = .;

cDesire = 0;
if Desire  = 2 then cDesire = 1;
if cdesire = 0 then t_desire_3 = .;

cUpset = 0;
if Upset = 	2 then cUpset  = 1;
if cupset = 0 then t_upset_3 = .;

cPlayful = 0;
if Playful = 1 then cPlayful  = 1;
if cplayful = 0 then t_playful_3 = .;

cSuspicious = 0;
if Suspicious =  3 then cSuspicious = 1;
if csuspicious = 0 then t_suspic_3 = .;

cNervous = 0;
if Nervous  = 2 then cNervous  = 1;
if cnervous = 0 then t_nervous_3 = .;

cDistrust = 0;
if Distrust  = 	3 then cDistrust = 1;
if cdistrust = 0 then t_distrust_3 = .;

cConcerned = 0;
if Concerned = 4 then cConcerned = 1;
if cconcerned = 0 then t_concern_3 = .;

cSerious = 0;
if Serious = 1 then cSerious  =1;
if cserious = 0 then t_serious_3 = .;

cConfident = 0;
if Confident = 2 then cConfident = 1;
if cconfident = 0 then t_confid_3 = .;

cFlirt = 0;
if Flirt = 2 then cFlirt = 1;
if cflirt = 0 then t_flirt_3 = .;

cReflective = 0;
if Reflective = 4 then cReflective = 1;
if creflective = 0 then t_reflect_3 = .;

cInterest_2 = 0;
if Interest_2  = 1 then cInterest_2 = 1;
if cinterest_2 = 0 then t_intere_2_3 = .;

cCautious_2 = 0;
if Cautious_2 = 2 then cCautious_2  = 1;
if ccautious_2 = 0 then t_caut_2_3 = .;

cHostile = 0;
if Hostile  = 3 then cHostile  = 1;
if chostile = 0 then t_hostile_3 = .;

cInterest_1  = 0;
if Interest_1  =  4 then cInterest_1 = 1;
if cinterest_1 = 0 then t_intere_1_3 = .;

cPensive  = 0;
if Pensive  = 1 then cPensive  = 1;
if cpensive = 0 then t_pensive_3 = .;

cDefiant  = 0;
if Defiant  = 3 then cDefiant  = 1;
if cdefiant = 0 then t_defiant_3 = .;

cPreocc_2 = 0;
if Preocc_2 = 1 then cPreocc_2 = 1;
if cpreocc_2 = 0 then t_preocc_2_3 = .;

cFantasy_2  = 0;
if Fantasy_2  = 2 then cFantasy_2  = 1;
if cfantasy_2 = 0 then t_fanta_2_3 = .;

cFriendly  = 0;
if Friendly  = 2 then cFriendly  = 1;
if cfriendly = 0 then t_friendly_3 = .;

cTentative = 0;
if Tentative  = 4 then cTentative = 1;
if ctentative = 0 then t_tentativ_3 = .;

cDecisive = 0;
if Decisive  = 1 then cDecisive  = 1;
if cdecisive = 0 then t_decisive_3 = .;

cDoubtful = 0;
if Doubtful  = 1 then cDoubtful = 1;
if cdoubtful = 0 then t_doubtful_3 = .;

cThoughtful  = 0;
if Thoughtful  = 2 then cThoughtful  = 1;
if cthoughtful = 0 then t_thought_3 = .;

cContemplat  = 0;
if Contemplat  = 1 then cContemplat  = 1;
if ccontemplat = 0 then t_contempl_3 = .;

cAccusing = 0;
if Accusing = 4 then cAccusing = 1;
if caccusing = 0 then t_accusing_3 = .;

rme_time = mean (of T_playful_3 T_Upset_3 T_Desire_3 T_Insist_3 T_Worried_3 T_Fant_1_3 T_Uneasy_3 T_Despond_3 T_Preocc_1_3 T_Caut_1_3 T_Regret_3 T_Skeptic_3 T_Anticip_3
T_Accusing_3 T_Contempl_3 T_Thought_3 T_Doubtful_3 T_Decisive_3 T_Tentativ_3 T_Friendly_3 T_Fanta_2_3 T_Preocc_2_3 T_Defiant_3 T_Pensive_3 T_Intere_1_3
T_Hostile_3 T_Caut_2_3 T_Intere_2_3 T_Reflect_3 T_Flirt_3 T_Confid_3 T_Serious_3 T_Concern_3 T_Distrust_3 T_Nervous_3 T_Suspic_3);

score = sum (of  cAnticipate cSkeptical cRegretful cCautious_1 cPreocc_1 cDespondent cUneasy cFantasy_1 cWorried cInsisting cDesire cUpset cPlayful cSuspicious
            	cNervous cDistrust cConcerned cSerious cConfident cFlirt cReflective cInterest_2 cCautious_2 cHostile cInterest_1 cPensive cDefiant cPreocc_2
	            cFantasy_2 cFriendly cTentative cDecisive cDoubtful cThoughtful cContemplat cAccusing);

s_na = na;
s_pa = pa;
s_age = age;
************RUN THESE EXCLUSIONS FIRST THEN UPDATE TRESHHOLDS USING MEAN AND SD***************************
**Exclude all subjects that are excluded from distribution due to skip, previous participation or reading time****
**************EXCLUDE ALL PARTICIPANTS WHO SKIPPED AN RMET QUESTION;

if	Playful	=	99	then	delete	;
if	Upset	=	99	then	delete	;
if	Desire	=	99	then	delete	;
if	Insisting	=	99	then	delete	;
if	Worried	=	99	then	delete	;
if	Fantasy_1	=	99	then	delete	;
if	Uneasy	=	99	then	delete	;
if	Despondent	=	99	then	delete	;
if	Preocc_1	=	99	then	delete	;
if	Cautious_1	=	99	then	delete	;
if	Regretful	=	99	then	delete	;
if	Skeptical	=	99	then	delete	;
if	Anticipate	=	99	then	delete	;
if	Accusing	=	99	then	delete	;
if	Contemplat	=	99	then	delete	;
if	Thoughtful	=	99	then	delete	;
if	Doubtful	=	99	then	delete	;
if	Decisive	=	99	then	delete	;
if	Tentative	=	99	then	delete	;
if	Friendly	=	99	then	delete	;
if	Fantasy_2	=	99	then	delete	;
if	Preocc_2	=	99	then	delete	;
if	Defiant	=	99	then	delete	;
if	Pensive	=	99	then	delete	;
if	Interest_1	=	99	then	delete	;
if	Hostile	=	99	then	delete	;
if	Cautious_2	=	99	then	delete	;
if	Interest_2	=	99	then	delete	;
if	Reflective	=	99	then	delete	;
if	Flirt	=	99	then	delete	;
if	Confident	=	99	then	delete	;
if	Serious	=	99	then	delete	;
if	Concerned	=	99	then	delete	;
if	Distrust	=	99	then	delete	;
if	Nervous	=	99	then	delete	;
if	Suspicious	=	99	then	delete	;

*exclude everyone who doesnt answer "no" on previous participation;
*if Previous=0 then delete;
*if Previous=1 then delete;
*if Previous=3 then delete;


*to avoid drops in sqrt(art) exclude all that have an art with less than 0; 
if art < 0 then delete;

time_check = 0;
*exclude everyone with too little reading time;
if time =0 then time_check = 1;

*update these means and standard deviations, 3.5*sd+-mean after exclusion has been made; 
* Time mean=122.5429168 SD=147.8439948 th==122.5429168+3.5*147.8439948=639.9968986;
*if time >639.9968986 then time_check = 1;
if time_check = 1 then delete;

art_check = 0;
*wrong mean=1.1237458 SD=2.4675215 th=1.1237458+(3.5*2.4675215)=9.76007105;
*if wrong > 9.76007105 then art_check = 1;
if art_check = 1 then delete;

score_check = 0;
*update scoretresshold mean=25.9498328 SD=5.4082486 th==25.9498328 -(3.5*5.4082486 )=7.0209627;
*if score < 7.0209627 then score_check = 1;
if score_check = 1 then delete;

d_cond = -1;
if condition = "Fiction" then d_cond = 1; 
run;quit;
*get means and use them to update;
proc means data = ToM_1;
var time wrong score;
where time > 0;
run;quit;

proc freq data = ToM_1;
Table Text Condition;
Run;quit; 
proc freq data = ToM_1;
Table Text Condition;
Run;quit;


proc standard data = ToM_1 out = ToM_1s mean = 0 std = 1; 
var s_art sqrt_art transportation;
run;quit;

*proc corr alpha data = ToM_1s;
*var Trans_1_1 Trans_2 Trans_3_1 Trans_4_1 Trans_5 Trans_6_1 Trans_7_1 Trans_8_1 Trans_9 Trans_10_1 Trans_11_1 Trans_12_1;
*run;*quit;

data ToM_1s;
set ToM_1s;
d_cond_x_art = d_cond*sqrt_ART;
run;quit;
*proc reg;
*model score = d_cond_x_art sqrt_art d_cond/stb;
*run;*quit;

proc glm;
class condition gender ;
model score = condition|sqrt_art/ effectsize;
lsmeans  condition/tdiff cl;
means condition;
run;quit;

proc standard mean = 0 std = 1; 
var score age transportation na rme_time;
run;quit;
*proc glm;
*class condition gender ;
*model score = condition|sqrt_art gender education age transportation na ch_sad rme_time/ effectsize solution;
*lsmeans  condition/tdiff cl;
*means condition;
*run;*quit;


*proc univariate plots normal; 
*var falsebox;
*where   total_tom > 50 and falsebox < 50;
*run;*quit;
*proc glm;
*class condition fb;
*model  falsebox correctbox = condition|fb  ;
*means condition|fb;
*lsmeans condition|fb/tdiff;
*where   total_tom > 50 and falsebox < 50;
*run;*quit;
*proc means; 
*var falsebox;
*where   total_tom > 50 and falsebox < 50;
*run;*quit;


