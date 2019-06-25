To view results run the following:

1. To view the replication result from the first data collection (N=285 after exclusions), please run "Data&Analysis\analysis\285analysis.sas"
2. To view the result from the first data collection without additional exclusion criteria (N=291 after exclusions), please run "Data&Analysis\analysis\291analysis.sas"
3. To view the replication result from the first and second data collection pooled (N=714 after exclusions), please run "Data&Analysis\analysis\714pooledanalysis.sas"
4. To view the result from the first and second data collection pooled without additional exclusion criteria (N=739 after exclusions), please run "Data&Analysis\analysis\739analysis.sas"
5. To view the result when the exclusions are based on the full sample of 919 observation rather than on the two samples separately (N=714), please run "Data&Analysis\analysis\714analysis.sas" .


To get datasets after exclusions run the following (the points are corresponding to the results above):

1. To get the dataset for the first replication result from the first data collection (N=285 after exclusions) please do the following
   a) "KiddCastano\Data&Analysis\data_selection\get285" this file does the non-distributional exclusions on the 348 observations collected for the first replication result (did not answer NO on the question about previous participation, had 0 seconds reading time, had a negative score on the author recognition test or had missing values on at least one of the RMET questions, in total 39 subjects are excluded, see report).
   b) The remaining dataset (N=293) is used to determine treshholds for the distributional exclusioncriteria.
   c) As seen when running "KiddCastano\Data&Analysis\data_selection\get285" these are:
		i. on time: * Time mean=123.4446240 SD=149.1979108 th=123.4446240 SD=149.1979108 th==123.4446240 + (3.5*149.1979108)=645.6373118;
		ii.on art: *wrong mean=1.1331058 SD=2.4868207 th=1.1331058 +(3.5*2.4868207)=9.83697825;
		iii. on score: *score mean=25.9453925 SD=5.3106014 th=25.9453925-(3.5*5.3106014)=7.3582876;

   d) By adding the distributional exclusion criteria above, we get the file "Data&Analysis\analysis\285analysis.sas" which produces the replication result from the first data collection.

2. To get the dataset for the first replication result from the first data collection without additional exclusion criteria (N=291 after exclusions) please do the following:
	a) run "KiddCastano\Data&Analysis\data_selection\get291" this file does the non-distributional exclusions from the original paper (the exact difference to 1 a) above is that we use observations regardless of whether or not they answered “No” on the question about previous participation).
	b) The remaining dataset (N=299) is used to determine tresholds for the distributional exclusioncriteria.
	c) As seen when running "KiddCastano\Data&Analysis\data_selection\get291" these are:
 	   	i. on time: mean=122.5429168 SD=147.8439948 th==122.5429168+3.5*147.8439948=639.9968986 
		ii. on art:  mean=1.1237458 SD=2.4675215 th=1.1237458+(3.5*2.4675215)=9.76007105;
		iii. on score: mean=25.9498328 SD=5.4082486 th==25.9498328 -(3.5*5.4082486 )=7.0209627;


d) By adding the distributional exclusion criteria above, we get the file "Data&Analysis\analysis\291analysis.sas" which produces the replication result from the first data collection (N=348) without the additional exclusion criteria.



3. To get the dataset for the replication result from the first and second data collection pooled (N=714 after exclusions), please do the following:

a) The get first part of this dataset (N=285) has already been discussed above in point 1. and will not be further described.

b) To get the second part (N=429) please do the following:

	i. Run "KiddCastano\Data&Analysis\data_selection\get429" this file does the non-distributional exclusions on the 571 observations collected for the second data collection for the pooled replication result (did not answer NO on the question about previous participation, had 0 seconds reading time, had a negative score on the author recognition test or had missing values on at least one of the RMET questions).
	ii. The remaining dataset (N=437)  is used to determine tresholds for the distributional exclusioncriteria.
	iii. As seen when running "KiddCastano\Data&Analysis\data_selection\get429" these are:

        i1) On time: mean=164.1884749 SD=416.4120515 th= 164.1884749+(3.5*416.4120515)=1621.63065515;
	i2) on art: mean=1.0755149 SD=2.2860306 th=1.0755149 +(3.5*2.2860306)=9.076622;
	i3) on score: mean=25.3867277 SD=5.5779799 th=25.3867277-(3.5*5.5779799)=5.86379805;

c) By adding the distributional exclusion criteria above, we get the 429 observations which are added to the first 285 observations to create the N=714 dataset for the pooled replication result. 


4. To get the dataset from the first and second data collection pooled without additional exclusion criteria (N=739 after exclusions), please do the following:

a) The first part of this dataset (N=291) has already been discussed in point 2. above and will not be further described.

b) To get the second part (N=448) please do the following:
	
	i. Run  "KiddCastano\Data&Analysis\data_selection\get448" this file does the non-distributional exclusions from the original paper on the on the 571 observations collected for the second data collection for the pooled replication result (the exact difference is that we use observations regardless of whether or not they answered “No” on the question about previous participation).
	ii. The remaining dataset (N=459)  is used to determine tresholds for the distributional exclusioncriteria.
	iii. As seen when running "KiddCastano\Data&Analysis\data_selection\get448" these are:

	i1) on time: mean=160.8109020 SD=406.7720251 th=160.8109020 +(3.5*406.7720251)=1584.51298985
	i2) on art: mean=1.0631808 SD=2.2405394 th=1.0631808 +(3.5*2.2405394)=8.9050687;
	i3) on score: mean=25.4509804 SD=5.5692636 th=25.4509804-(3.5*5.5692636)=5.9585578;


c) By adding the distributional exclusion criteria above, we get the 448 observations which are added to the first 291 observations to create the N=739 dataset for the pooled replication result. 


5. To get the datasets when the exclusions are based on the full sample of 919 observation rather than on the two samples separately (N=714), please run "KiddCastano\Data&Analysis\data_selection\get714" .

	i. Run "KiddCastano\Data&Analysis\data_selection\get714" this file does the non-distributional exclusions on all the 919 observations collected (did not answer NO on the question about previous participation, had 0 seconds reading time, had a negative score on the author recognition test or had missing values on at least one of the RMET questions).
	ii. The remaining dataset (N=730)  is used to determine tresholds for the distributional exclusioncriteria.
	iii. As seen when running "KiddCastano\Data&Analysis\data_selection\get714" these are:


	i1) on time:  mean=147.8351211 SD=336.1874923 th=147.8351211+(3.5*336.1874923)=1324.49134415;
	i2) on art:   mean=1.0986301 SD=2.3671560 th=1.0986301+(3.5*2.3671560)=9.3836761 ;
	i3) on score: mean=25.6109589 SD=5.4754111 th==25.6109589-(3.5*5.4754111)=6.44702005;

c) By adding the distributional exclusion criteria above, we get the 714 observations used to get result 5.