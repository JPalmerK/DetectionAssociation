# Detection Association
Implementation of K. Cortopassi cross correlation code to work with multi-channel Raven Selection tables

This is a qick implmentation of call association code that takes detections from a single channel and uses normalized cross correlation and array spacing to identify additional arrivals on other channels.

The detections format must match the Raven selection table output of which a sample is included and organized into day files (one text file per day). Sound files must be in a single folder. For example if the selection table folder has contains five days of text files (Apr 1-5) the sound table folder must contain all sound files (not divided into day folders) of those same days. 

This returns
1. Csv file with each detection on the primary channel in the first column and the id of linked detections in the second column. 
2. CSV file with the normalized cross correlation scores for detections on the primary channel and all potential detections (within the array timing) on the secondary channels
3. CSV file with id of all detections within the array spacing of the primary channel


![image](https://user-images.githubusercontent.com/28478110/169581606-b4b62fc4-5971-4845-98f3-fb39b94a26f4.png)

