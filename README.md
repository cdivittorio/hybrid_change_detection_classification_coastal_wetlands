# hybrid_change_detection_classification_coastal_wetlands
This repository describes the development of a hybrid change detection and classification algorithm that was used to map coastal wetland changes in Blackwater, MD, USA.


 Part 1: Vegetation and Water Indices Calculation
Description
In this section, we calculate several vegetation and water indices across multiple datasets using reflectance data from different bands (Blue, Green, Red, NIR, SWIR1, and SWIR2). These indices are essential for vegetation, water detection, and soil analysis in environmental and remote sensing studies.
Setup Prerequisites
The following R packages are required:
•	changepoint
•	bcp
•	strucchange
•	segmented
•	tree
Please ensure these packages are installed for the analysis scripts to work correctly.
Usage
1.	Data Preparation: Upload CSV files containing reflectance data for different wetland types in the working directory. Filenames should follow the specified patterns for consistency:
o	Bareland: B_1.csv, B_2.csv, ..., B_8.csv
o	Estuarine Emergent: E_1.csv, ..., E_8.csv
o	Estuarine to Open Water: EO_1.csv, ..., EO_8.csv
2.	Index Calculation: A function (compute_indices) calculates indices such as NDVI, NDWI, MNDWI, and others. Modify this function as needed to match column names in your data files (e.g., replace data$NIR, data$Red with appropriate column references).
3.	Index Application: After uploading the datasets, run compute_indices on each, retaining only essential columns for analysis. Once calculated, the data can be saved or exported for further processing.
Part 2: Change Point Detection and Data Splitting
Description
This section processes multiple datasets, applies a change point detection algorithm, and labels data for classification tasks. The change point analysis helps identify significant changes within the dataset, useful for wetland classification and understanding transitions in stability.

Steps
Data Loading and Initial Processing: CSV files are loaded into separate data frames (Data45 to Data74) to represent different datasets in the study.

Column Selection: Use important_columns to specify essential indices and features (e.g., "Blue", "Green", "NDVI"). Only these columns are retained in each dataset for streamlined processing.

Change Point Detection:

Convert each dataset to a matrix format required for the e.divisive function.
Apply e.divisive to detect significant shifts in the data, and store results in an output_list.
Data Splitting and Labeling:

For specific datasets (e.g., 50-54, 65-74), split data by row ranges using the split_data function, which adds classification labels.
Export these labeled subsets (e.g., Data65b.csv, Data66b.csv) for analysis.

Part 3: Prediction and Classification of Wetland Stability
Description
In this section, a trained Random Forest model is used to label the NetCDF data, identifying stable and unstable wetlands. The model is trained on datasets previously split and labeled by the change point algorithm. The model classifies the data, applies a threshold-based analysis to assess stability, and calculates classification metrics.
Workflow
1.	Model Training:
o	Apply the Random Forest model to the NetCDF data, which contains the seven spectral bands (e.g., Blue, Green, Red, NIR, SWIR1, SWIR2).
o	Train the model using the labeled data from Part 2 as input.
2.	Prediction on NetCDF Data:
o	Load NetCDF files representing the study area and extract latitudes, longitudes, and timestamps.
o	Generate indices from the bands and apply the trained Random Forest model to classify each data point.
o	Save predictions in separate CSV files based on the classification results.
3.	Threshold-Based Analysis for Wetland Stability:
o	Apply threshold values (e.g., 50% to 80%) on vegetation indices to classify wetlands as stable or unstable.
o	Calculate sensitivity, specificity, and generate confusion matrices for each threshold.
o	Store metrics in confusion_matrices, and plot Commission Error (CE) and Omission Error (OE) using ggplot2.
4.	Plotting CE and OE Errors:
o	Create separate plots for CE and OE errors across thresholds.
o	Display both errors on a combined plot for a comprehensive view of stability classification accuracy.

