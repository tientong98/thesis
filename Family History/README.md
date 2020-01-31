This folder has codes for identifying subjects with (Family History Positive - FHP) and without (Family History Negative - FHN) a family history of Alcohol Use Disorder. 

1. First, identify FHP and FHN `FamHisAlc.Rmd` 
2. Then, exclude the identified subjects and drug exposure in utero `PhysicalHealth.Rmd`
3. Then, exclude subjects with any substance use  `substance.Rmd`
3. Lastly, exclude those with major disorders (schizophrenia, bipolar) `MentalHealth.Rmd`
4. Merge all demographic information, match FHN with FHP `demographs.Rmd`, get the final list of FHN and FHP
5. Run a group analysis on baseline neuropsychological measures `neuropsych.Rmd` and `EFA.Rmd`


# Family History

Details of the instruments are in Barch et al 2018, *Dev Cog Neuroscience*

11,875 subjects

Age in months at the time of the interview (interview_age)

This value has been calculated from the de-identified birth date (middle of the birth month date) and the assent signature time stamp (annual visits) or mypi_date for mid-year visits, and is the same for all sessions of the baseline visit for each participant (even when these fall on different days).   
  
FHP = at least 1 biological parent with AUD 
FHN = no first- and second-degree relative with AUD
  
Variables are in:
ABCD Family History Assessment Part 1 fhxp101 (alc, drugs, depression)
ABCD Family History Assessment Part 2 fhxp201 (mania, schizo, nervous, counselor, hospitalized, suicide)
Questions from:	Modification of the Family History Assessment from NCANDA	15 min	Brown et al. (2015)

Codes from ABCD to categorize FH: https://github.com/ABCD-STUDY/family_history_problem_summary_scores/blob/master/FHx.alc.R

In ABCD we employed a version of the Family History Assessment Module Screener (FHAM-S) (Rice et al., 1995) that was used in the National Consortium on Alcohol and Neurodevelopment in Adolescence (NCANDA) study (http://www.ncanda.org/index.php). In the ABCD FHAM-S version, we have parents report on the presence/absence of symptoms associated with alcohol use disorder, substance use disorder, depression, mania, psychosis, and antisocial personality disorder in all 1st and 2nd degree “blood relatives” of the youth. (That is, biological relatives including full and half-siblings, parents, grandparents, and aunts and uncles.) 

Question:
Has ANY blood relative of your child ever had any problems due to alcohol, such as:

0. No problem  
1. Marital  separation or divorce;   
2. Laid off or fired from work;   
3. Arrests or DUIs;   
4. Alcohol harmed their health; 
5. In an alcohol treatment program; 
6. Suspended or expelled from school 2 or more times; 
7. Isolated self from family, caused arguments or were drunk a lot.  

AUD diagnose (https://www.niaaa.nih.gov/alcohol-health/overview-alcohol-consumption/alcohol-use-disorders)  

## FH Known issues release 2.0.1:

“Missing” or blank responses could mean:
1) Nothing is known about any biological relative (famhx_1=0) so questions are not asked.
2) The problem can be assumed to be negative or a “0” (zero) because the respondent indicated that no biological relative had that particular type of problem.
3) The relative does not exist (e.g., only has 1 paternal uncle so paternal uncle 2 is blank); questions are only asked if the relative exists. The number and type of biological relatives can be found in variables famhx_1a_p – to-- fhx_3h_older_p.
4) The Research Assistant did not administer the relevant questions because s/he thought s/he only needed to administer the relevant questions for those relatives whom the respondent believed might have been affected. That is, the respondent had knowledge of the biological relatives, had indicated that one or more relatives had the problem being assessed, but was told to just identify those relatives known to be affected.


# Others

**FH of AUD scoring**

From David Benjamin Ph.D., dpbenjamin@ucsd.edu

Thanks for reaching out and for your interest in the ABCD Study. Are you seeking to analyze ABCD data, or are you simply interested in the FHAM for your own use? The Family History assessment we use in ABCD came from the COGA project. I would suggest looking at their website: https://niaaagenetics.org/ and look under COGA Instruments for Family History Assessment Module (FHAM). 

For ABCD, there are several scoring schemes in progress, and I believe there is one in our Data Exploration and Analysis Portal (DEAP) to code for if the participant has a history of AUD in the parents. In general, the scoring principles are complicated owing to the structure of the interview. There should be some user notes in the ReadMe files on NDA to find out more. The data are highly conditional based on the presence or absence of different “blood” relatives, whether or not someone indicates the absence of a problem in any blood relatives for a given problem/module, etc.
 
As for the alcohol module (and for the drug module too), we looked at a number of alternative problem counts (specifically, 1, 2, and 3) to decide as to when a given relative is deemed to have an alcohol (or drug) problem. For initial research purposes, we selected a cut-off of one or more as the default for both alcohol and drugs. This was based on the fact that this cut-off yielded prevalences that were most similar to the larger literature and because, in general, family history methodology is known to be fairly high in specificity but low in sensitivity. Of course, it is fairly straightforward to raise the cut-off higher if specificity is of greater concern than sensitivity. 
 
The issue of “cut offs” is moot for the other modules since they are all, essentially, single-item assessments for each relative. The issue of taking the structure of the interview into account when scoring the FH Interview, however, remains. Again, the user notes on DNA document the major issues a user would want to be familiar with. I hope this is helpful, but please ready out if you have any additional questions, 

**Autism and Tics**

From Jazmin @ ABCD-issues: 

They should NOT use the autism variable for diagnosis - that is why it says full criteria not assessed - it is better assessed in KSADs 2.0. TICs is being assessed starting at year 3.

We do not have a good variable to definitely eliminate youth who might have mild autism spectrum disorder in the dataset. We did not enroll youth with autism severe enough to preclude being in a regular classroom. After the 2 year follow up we will have better data on autism spectrum from the updated KSADs.
