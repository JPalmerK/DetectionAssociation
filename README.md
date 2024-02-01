
# Detection Association
![image](https://user-images.githubusercontent.com/28478110/169581606-b4b62fc4-5971-4845-98f3-fb39b94a26f4.png)
Implementation of K. Cortopassi cross correlation code to work with multi-channel Raven Selection tables

This code was created to assocaite detections from a primary channel defined by the suer to detections on secondary channels. It's orgional incarnation was designed to automatically associate right whale detections from neural networks to aid in animal location. Specifically, calls were either manually annotated or automatically detected and validated using the algorithim in Y Shiu and KJ Palmer et al. 2020 producing multiple detections of the same animal on different hydrophones.

When using this system, the detections format must match the Raven selection table output of which a sample is included and organized into day files (one text file per day). Sound files must be in a single folder representing all the detections in each selection table. For example, if the selection table folder has contains five days of text files (Apr 1-5) the sound table folder must contain all sound files (not divided into day folders) of those same days. 

## Graphic User Interface
A GUI has been built such that users may input the information about the Raven selection tables, hydrophone spacing, and soundfile stream such that the cross correlation can happen autiomatically.

![image](https://github.com/JPalmerK/DetectionAssociation/assets/28478110/4c3829aa-e7f5-46a2-897f-26297ffaa009)

## Inputs and Outputs

### Inputs
**Sound File Location** Path to sound file folder containing data used to make selection tables. 
**Raven Selection Tables** Path to folder containing raven selection tables created using sound files in above folder.
**Hydrophone Locs CSV** Full path to csv location containing the hydrophone locations

Note that raven selection tables must have low and high frequency, start time from beginning of stream and end time from beginning of file stream. The reamining columns are ignored. 

Example hydrophone locations and raven selection tables have been provided for expected formatting reference. 

### Outputs 
1. Csv file with each detection on the primary channel in the first column and the id of linked detections in the second column. 
2. CSV file with the normalized cross correlation scores for detections on the primary channel and all potential detections (within the array timing) on the secondary channels
3. CSV file with id of all detections within the array spacing of the primary channel


##  Known Bugs/to do
- Find funding to support this work
- Switch case for identifying audio files in folder not working. Currently only identifies aiffs, high priortiy fix
- Make robust to folder structures
