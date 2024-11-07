# hybrid_change_detection_classification_coastal_wetlands
This repository describes the development of a hybrid change detection and classification algorithm used to map coastal wetland changes in Blackwater, MD, USA.


 Part 1: Vegetation and Water Indices Calculation
Description
This section calculates several vegetation and water indices across multiple datasets using reflectance data from different bands (Blue, Green, Red, NIR, SWIR1, and SWIR2). These indices are essential for vegetation, water detection, and soil analysis in environmental and remote sensing studies.
Setup Prerequisites
The following R packages are required:
•	changepoint
•	BCP
•	strucchange
•	segmented
•	tree

Usage
1.	Data Preparation: Upload CSV files containing reflectance data for different wetland types in the working directory. Filenames should follow the specified patterns for consistency:
o	Bareland: B_1.csv, B_2.csv, ..., B_8.csv
o	Estuarine Emergent: E_1.csv, ..., E_8.csv
o	Estuarine to Open Water: EO_1.csv, ..., EO_8.csv
2.	Index Calculation: A function (compute_indices) calculates indices such as NDVI, NDWI, MNDWI, and others. Modify this function to match column names in your data files (e.g., replace data$NIR, data$Red with appropriate column references).
3.	Index Application: After uploading the datasets, run compute_indices on each, retaining only essential columns for analysis. Once calculated, the data can be saved or exported for further processing.


Part 2: Change Point Detection and Data Splitting
Description
This section processes multiple datasets, applies a change point detection algorithm, and labels data for classification tasks. The change point analysis helps identify significant changes within the dataset, which is useful for wetland classification and understanding transition instability.

Steps
Data Loading and Initial Processing: CSV files are loaded into separate data frames (Data45 to Data74) to represent different datasets in the study.

Column Selection: Use important_columns to specify essential indices and features (e.g., "Blue", "Green", "NDVI"). Only these columns are retained in each dataset for streamlined processing.

Change Point Detection:

Convert each dataset to a matrix format required for the e.divisive function.
Apply e.divisive to detect significant shifts in the data and store results in an output_list.
Data Splitting and Labeling:

For specific datasets (e.g., 50-54, 65-74), split data by row ranges using the split_data function, which adds classification labels.
Export these labeled subsets (e.g., Data65b.csv, Data66b.csv) for analysis.

Part 3: This workflow utilizes a Random Forest model to classify and predict wetland stability, leveraging various remote sensing indices and spectral bands. The primary objective is to assess wetland stability based on labeled data, enabling the classification of wetlands into stable and unstable categories.
Workflow Structure
1. Data Preparation
•	A series of data frames (Data1, Data2, …, Data89) are compiled and saved as individual CSV files for analysis.
•	Each data frame represents a unique dataset within a list, which is iteratively saved to a specified directory.
2. Data Loading and Preprocessing
•	A custom function load_and_preprocess_data() reads CSV files from the specified directory, combines them, and preprocesses the data by selecting relevant columns and removing any NA values.
•	Data labels are converted to factors to facilitate classification in the model.
3. Model Training
•	A Random Forest model is trained using the selected spectral indices (Blue, Green, Red, NIR, SWIR1, SWIR2, NDVI, NDWI, MNDWI, BSI, EVI, NPCRI, and AEWInsh).
•	Cross-validation (repeated 10-fold) is applied to optimize accuracy, plotting variable importance to visualize feature contributions.
4. Model Evaluation
•	Model performance is evaluated on training and testing datasets using confusion matrices.
•	Accuracy and classification performance metrics are generated for model assessment.
5. Classification Prediction
•	Predictions are generated on new test data with either a 6-class or 4-class labeling scheme.
•	The classification results are saved as separate CSV files for each test dataset, enabling subsequent analysis.
6. Result Combination and Export
•	Classification predictions are combined with time-stamped data to track wetland stability changes.
•	Combined data frames are then exported as CSV files for further review and analysis.
7. Custom Functions
•	predict_and_save(): Predicts stability classes and saves the results.
•	combine_data(): Merges predictions with time data.
•	write_data_to_csv(): Exports final combined data frames to CSV.
Output
The final CSV files, saved in the designated directory, contain classification predictions for different wetland types, providing insight into changes in wetland stability across multiple time points.


