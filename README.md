![alt text](https://c2.staticflickr.com/4/3028/3043243774_c72dc125e1_z.jpg)

# Semantic Analysis of Canadian Regulations

This project combines expertise in legislative drafting and legal data science to conduct an automated semantic analysis of more than 2700 Canadian federal regulations. It investigates four legal characteristics of regulations: **(1) Prescriptivity, (2) Flexibility, (3) Complexity, and (4) Age**. Drawing on the literature in relation to the assessment of regulatory burden, automated analysis of legal text, and plain language drafting, we devise a conceptualization and operationalization of these four characteristics. In order to scale the legal analysis of these characteristics, we rely primarily on an easily extendable and transparent dictionary approach that searches through the corpus of regulations for the presence of signaling terms and phrases. 

## Github Resources

This repository contains several resources that allow users to replicate, extend or validate our research.
- Dataset of 2700+ Federal Canadian Regulations with full text and meta data (in .RDS format)
- Analytics script investigating four dimensions of these regulations (in .R format)
- Extendable wordlists to extend or deepen the analysis

*Last updated 16 October 2018*

## Project Background

The project work was conducted between May to September 2018 by researchers at the Common Law Section of the University of Ottawa for the Canada School of Public Service (GSPS). The group of researchers was led by Professor Wolfgang Alschner, who specialises in legal data science, and Professor John Mark Keyes, a legal drafting expert and former Chief Legislative Counsel of the Canadian Department of Justice. 

We are grateful for the hard work and dedication of our student researchers: Alexander Geddes, Elina Korchagina, Marco Pontello, Rex Yeung and Peter C. Zachar.
 
## Conceptual Approach and Main Findings

**1. Prescriptivity:** How binding are regulations?
-	We define prescriptivity as a *relative* measure of prescriptiveness (“shall”, “must”, ect.) in comparison to permissiveness (“may”, “entitled to”, ect.). Prescriptivity of Canadian regulations is increasing. Although prescriptive terms themselves are decreasing, this is offset by a larger drop in permissive terms rendering regulations more rigid. 
-	Prescriptivity tends to vary by regulatory subject matter. Consumer product regulations tend to be very prescriptive (see e.g. Carriages and Strollers Regulations scoring among the highest on our count) whereas other regulatory fields such as procedural court regulations tend to display low prescriptivity. Additional grouping will be necessary to determine whether, within a group of similar regulations, a document is overly prescriptive. Overly prescriptive regulations can signify either poor drafting (e.g. unnecessary repetition of prescriptions) or burdensome regulation. 

**2. Flexibility:** How responsive are regulations to changing circumstances? 
- Flexibility has several distinct dimensions including whether flexibility is conferred on the regulator or the regulatee. We investigate three of its aspects: (1) exceptions, (2) discretion and (3) incorporation by reference.
- Similarly to precriptiveness, flexibility varies systematically across the type of regulations. Whereas financial or transport regulations, for instance, have more opportunity to incorporate external industry standards, other types of regulation contain few such references.    

**3. Complexity:** How easily understandable are regulations?
-	Complexity, in our definition, captures how accessible the regulatory text is to its readers. This is achieved through plain, clear and well-structured drafting. Unfortunately, off-the-shelves readability measures (e.g. Flesch Kincaid) do not accurately capture the accessibility of regulatory texts since they regulations are differently formatted and structured as compared to the natural language texts for which these readability measures were developed.
-	Using a word list approach instead, we find that regulations become more complex in their structure through more cross-references, but rely less on legal jargon..

**4. Age:** What is the average age of regulations?  
-	We calculate how much time has passed since a regulation was last amended, but also look for technology-related outdatedness specifically. We find, for instance, that some regulations specify permitted means of communications, which can lead to the omission of newer forms of communciation such as EMail in older regulations that have not yet been recently amended.  

## Interactive Website

We have a created an interactive website that allows you to visualize and compare results. It is available at: https://regulations.herokuapp.com/.

## Contact
Wolfgang Alschner (wolfgang.alschner@uottawa.ca)
