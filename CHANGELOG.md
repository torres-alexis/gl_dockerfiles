# Docker image change log
 
## [NF_MAAffymetrix_v1.0.0-rc.9](https://github.com/torres-alexis/gl_dockerfiles/releases/tag/NF_MAAffymetrix_v1.0.0-rc.9)
- Switch from Bionic to Jammy for Ubuntu LTS OS base image
- Software changelog
    - |Program|Previous version|Current version|
        |:----|:--------------:|:--------------|
        |R|4.1.3|4.3.3|
        |Python*|3.10|3.11|
        |DT|0.26|0.32|
        |dplyr|1.0.10|1.1.4|
        |tibble|3.1.8|3.2.1|
        |stringr|1.5.0|1.5.1|
        |R.utils|2.12.2|2.12.3|
        |oligo|1.58.0|1.66.0|
        |limma|3.50.3|3.58.1|
        |glue|1.6.2|1.7.0|
        |biomaRt|2.50.0|2.58.2|
        |matrixStats|0.63.0|1.2.0|
        |statmod|1.5.0|1.5.0|
        |Quarto|1.1.251|1.4.551|
- Remove Quarto installation file from local assets in favor of downloading Quarto from Github since old versions are consistently available
- Reorganize Dockerfile
- Changed label naming scheme to workflow_**vX.X.X[-rc-.X]**
    - Cannot use direct label versioning which would be ideal, unless all images were hosted in their own repos. 

\* Python and several Python and R packages have been updated but are omitted from the software list in [GL-DPPD-7114.md](https://github.com/nasa/GeneLab_Data_Processing/blob/master/Microarray/Affymetrix/Pipeline_GL-DPPD-7114_Versions/GL-DPPD-7114.md), as they are utilized for background processes.
<br> 

---

<br> 

All previous versions were associated with [Jonathan Oribello's GeneLab Dockerfiles repository](https://github.com/J-81/gl_dockerfiles). 

