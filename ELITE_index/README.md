![elite_stand_stripe](https://github.com/PKullberg/EEA_and_BD/blob/master/figures/elitestripe3.PNG?raw=true)
# Automated process of calculating ELITE forest condition indices

This repo contains documentation and scripts of full pipeline for calculating ELITE forest condition indices and derived metrics in protected areas (PAs). In the process index is calculated for each forest stand in provided set of protected areas, after which PA specific metrics are provided. These include PA mean index value and metrics describing amount of good condition forest patches. Only input data in process is biotope stand characteristics from SAKTI, Protected area biotope information system by Finnish Metsähallitus (Suojelualueiden kuviotietojärjestelmän biotooppikuvioaineisto). Data is not openly available and is not provided here - however, full process is demonstrated and visualized in "PA_ForestElite_DEMO" R Markdown file an resulting [html accessed by this link](https://tyttijussila.github.io/portfolio/PA_ForestElite_DEMO.html). For detailed information of process, see the actual function scripts in "R" folder.  

### What is ELITE?

ELITE is a method developed by Kotiaho et al. (2015) to measure ecosystem condition in the context of it's assumed reference condition in a natural state. In boreal forests, index consists of three indicator features: amount of large trunks, dead wood and broad-leaved trees (Fig. 1). Weights and feature reference values are habitat dependent. Index values vary between 0 and 1, where 1 refers to 100% natural ecosystem.

![Calculating ELITE](https://github.com/PKullberg/EEA_and_BD/blob/master/figures/CalculatingELITE_english.PNG?raw=true)


### Applying the forest ELITE pipeline

Input files needed from SAKTI database:
- Biotope compartment shapefile (.shp) = stand data
- Tree stratum database files (.dbf) = deadwood and living trees data related to stands

The main script executing the full process (Fig. 2) is the "plan.R" at the root directory. This is the only part that has to be modified - the user provides paths to input files described above and to output file folder, sets working directory, and may change default processing options. These include options of for which areas to calculate index, treshold value(s) of quality forest, and output options (stand or PA level, csv or geospatial format). All functionalities in the process are separated as their own functions, which the plan.R imports from the "R"-folder. One or two functions, one R-script. 


![ELITE process flowchart](https://github.com/PKullberg/EEA_and_BD/blob/master/figures/ELITE_workflow2.4.png?raw=true)

#### References:
-  Kotiaho, J.S., Kuusela, S. Nieminen, E., & Päivinen J. 2015. Elinympäristöjen tilan edistäminen Suomessa. Suomen ympäristö. 8/2015. Ympäristöministeriö. Helsinki. https://helda.helsinki.fi/handle/10138/156982
- SAKTI. 2020. Protected area biotope information system, biotope data. Metsähallitus, Parks & Wildlife Finland. / Suojelualueiden kuviotietojärjestelmä, biotooppikuvioaineisto. Metsähallitus, Luontopalvelut.
