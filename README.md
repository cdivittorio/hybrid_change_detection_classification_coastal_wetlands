# hybrid_change_detection_classification_coastal_wetlands
This repository describes the development of a hybrid change detection and classification algorithm used to map coastal wetland changes in Blackwater, MD, USA. The paper is currently under review in Remote Sensing (MDPI)

## Summary of R Script (Hybrid_Change_Detection_RF_Model.R):

### Part 1: Vegetation and Water Indices Calculation
Description: This section calculates several vegetation and water indices across multiple datasets using reflectance data from different bands (Blue, Green, Red, NIR, SWIR1, and SWIR2). These indices are essential for vegetation, water detection, and soil analysis in environmental and remote sensing studies.

Setup Prerequisites:\
The following R packages are required:\
  •	changepoint\
  •	BCP\
  •	strucchange\
  •	segmented\
  •	tree

Steps:\
a.	Data Preparation: Upload CSV files containing reflectance data for different wetland types in the working directory. Filenames should follow the specified patterns for consistency:\
   •	Bareland: B_1.csv, B_2.csv, ..., B_8.csv\
   •	Estuarine Emergent: E_1.csv, ..., E_8.csv\
   •	Estuarine to Open Water: EO_1.csv, ..., EO_8.csv\
b.	Index Calculation: A function (compute_indices) calculates indices such as NDVI, NDWI, MNDWI, and others. Modify this function to match column names in your data files (e.g., replace data$NIR, data$Red with appropriate column references).\
c.	Index Application: After uploading the datasets, run compute_indices on each, retaining only essential columns for analysis. Once calculated, the data can be saved or exported for further processing.


### Part 2: Change Point Detection and Data Splitting
Description: This section processes multiple datasets, applies a change point detection algorithm, and labels data for classification tasks. The change point analysis helps identify significant changes within the dataset, which is useful for wetland classification and understanding transition instability.

Steps:\
a. Data Loading and Initial Processing: CSV files are loaded into separate data frames (Data45 to Data74) to represent different datasets in the study.\
b. Column Selection: Use important_columns to specify essential indices and features (e.g., "Blue", "Green", "NDVI"). Only these columns are retained in each dataset for streamlined processing.\
c. Change Point Detection: Convert each dataset to a matrix format required for the e.divisive function. Apply e.divisive to detect significant shifts in the data and store results in an output_list.\
d. Data Splitting and Labeling: For specific datasets (e.g., 50-54, 65-74), split data by row ranges using the split_data function, which adds classification labels. Export these labeled subsets (e.g., Data65b.csv, Data66b.csv) for analysis.

### Part 3: Random Forest Model:
Description: This workflow utilizes a Random Forest model to classify and predict wetland stability, leveraging various remote sensing indices and spectral bands. The primary objective is to assess wetland stability based on labeled data, enabling the classification of wetlands into stable and unstable categories.

Steps:\
a. Data Preparation\
   •	A series of data frames (Data1, Data2, …, Data89) are compiled and saved as individual CSV files for analysis.\
   •	Each data frame represents a unique dataset within a list, which is iteratively saved to a specified directory.\
b. Data Loading and Preprocessing\
   •	A custom function load_and_preprocess_data() reads CSV files from the specified directory, combines them, and preprocesses the data by selecting relevant columns and removing any NA values.\
   •	Data labels are converted to factors to facilitate classification in the model.\
c. Model Training\
   •	A Random Forest model is trained using the selected spectral indices (Blue, Green, Red, NIR, SWIR1, SWIR2, NDVI, NDWI, MNDWI, BSI, EVI, NPCRI, and AEWInsh).\
   •	Cross-validation (repeated 10-fold) is applied to optimize accuracy, plotting variable importance to visualize feature contributions.\
d. Model Evaluation\
   •	Model performance is evaluated on training and testing datasets using confusion matrices.\
   •	Accuracy and classification performance metrics are generated for model assessment.\
e. Classification Prediction\
   •	Predictions are generated on new test data with either a 6-class or 4-class labeling scheme.
   •	The classification results are saved as separate CSV files for each test dataset, enabling subsequent analysis.\
f. Result Combination and Export\
   •	Classification predictions are combined with time-stamped data to track wetland stability changes.\
   •	Combined data frames are then exported as CSV files for further review and analysis.\
g. Custom Functions\
   •	predict_and_save(): Predicts stability classes and saves the results.\
   •	combine_data(): Merges predictions with time data.\
   •	write_data_to_csv(): Exports final combined data frames to CSV.

### Output:
The final CSV files, saved in the designated directory, contain classification predictions for different wetland types, providing insight into changes in wetland stability across multiple time points.

## Summary of MATLAB script (change_smoothing.m):
Description: This code smooths the time series and distinguishes between temporary and permanent changes and abrupt and gradual changes. 

Steps:\
a. Stack images into 3D matrix.\
b. For each pixel identify when changes occur and for how long.\
c. If segment of change is less than three years, consider smoothing according to logic below:

Condition of temporary segment	--> Adjustment to land cover class\
Between two stable segments of the same class	--> Unstable version of stable class\
Between two stable segments of different classes	--> Unstable version of the preceding stable class\
Between a stable and an unstable segment	--> Unstable version of the stable segment\
Between two unstable segments --> 	Same as the first unstable segment\
First segment in time series and followed by stable class --> 	Unstable version of the stable class that follows\
First segment in time series and followed by unstable class --> 	Same as the unstable segment that follows\
Last segment in time series and preceded by stable class	--> Unstable version of the stable class that precedes\
Last segment in time series and preceded by unstable class --> 	Same as the unstable segment that precedes
