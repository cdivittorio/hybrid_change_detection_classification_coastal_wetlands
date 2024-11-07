# hybrid_change_detection_classification_coastal_wetlands
This repository describes the development of a hybrid change detection and classification algorithm that was used to map coastal wetland changes in Blackwater, MD, USA.


## Part 1: Vegetation and Water Indices Calculation
In Part 1, This R project calculates various vegetation and water indices across multiple datasets, primarily using reflectance data (e.g., Blue, Green, Red, NIR, SWIR1, SWIR2 bands). The indices calculated can be used for vegetation analysis, water detection, and soil analysis in environmental and remote sensing studies.

Setup
Prerequisites
The following R packages are required:

changepoint
bcp
strucchange
segmented
tree

Usage
Data Preparation: CSV files for the datasets should be organized in the working directory with filenames following these patterns:

Bareland: B_1.csv, B_2.csv, ..., B_8.csv
Estuarine Emergent: E_1.csv, ..., E_8.csv
Estuarine to Open Water: EO_1.csv, ..., EO_8.csv
Index Calculation: The provided functions calculate indices including NDVI, NDWI, MNDWI, and more.

Function for Index Computation: The compute_indices function takes a dataset and calculates indices. To apply it:
Replace data$NIR, data$Red, etc., with the appropriate columns in your data files.

Run Calculations on Multiple Datasets: Load your datasets, compute indices, and keep only the necessary columns:
Save or Export: Once all calculations are completed, you may export the modified data for analysis.

Part 2: In part 2 This script effectively handles multiple datasets for analysis and labeling tasks in R. Here's a summary of its key elements and functionality:

1. Data Loading and Initial Processing
Multiple CSV files are read into separate data frames (Data45 to Data74), each representing different datasets related to the wetland study.
Lists are created to apply compute_indices, allowing each dataset to go through the same index computation process if defined in compute_indices.
2. Column Selection
The important_columns vector specifies key indices and features such as "Blue", "Green", "NDVI", etc. Only these columns are retained in each dataset to streamline processing and focus on relevant data.
3. Matrix Conversion and Change Point Detection
Each dataset is converted into a matrix format, which is required for change point detection using the e.divisive function.
e.divisive is applied to identify significant shifts within the data. The results for each dataset are stored in an output list (output_list).
4. Data Splitting and Labeling
For datasets 50-54 and 65-74, each dataset is divided based on specific row ranges. The split_data function handles this by:
Accepting row split points and associated labels.
Adding labels for classification purposes.
Writing specified sections (e.g., middle parts) to CSV files.
5. Finalizing and Saving Labeled Data
After processing, each dataset is re-assigned to its original variable name, allowing further analysis.
The final CSV files (Data65b.csv, Data66b.csv, etc.) are saved with labeled subsets.

Part 3: 
Prediction and CSV Saving:

Using model_rf, this loop makes predictions on a list of datasets (data_list) and saves each output as a CSV file. Each dataset corresponds to a prediction file, named according to the specified output_names.
NetCDF File Processing:

Opens and processes several NetCDF files representing different bands, extracts latitudes, longitudes, and times, and then converts band-specific data into data frames (b1_df, b2_df, etc.).
Constructs a list (band_dfs) to hold each band’s data frame, making it easy to access each processed band individually.
Index Calculation for Datasets:

The calculate_indices function computes several vegetation indices for datasets (e.g., NDVI, NDWI), using a set of specific bands.
This function is then applied to multiple datasets (T1 to T10).
Threshold Sensitivity and Specificity Analysis:

Calculates threshold-based classifications on a Vegetation dataset based on a range of thresholds (from 50% to 80%).
Generates confusion matrices for each threshold and stores them in confusion_matrices.
Extracts key performance metrics (e.g., sensitivity, specificity) and plots both Commission (CE) and Omission (OE) Errors against threshold values.
Plotting CE and OE Errors:

Creates individual plots for CE and OE errors using ggplot2, and a combined plot showing both errors across threshold values.
Additional Notes:
Libraries: Ensure the required libraries (caret, ncdf4, tidyverse, ggplot2, magrittr) are installed and loaded as they are essential for functions like nc_open, confusionMatrix, and ggplot.
Function Definitions: Functions such as ndvi, ndwi, npcri, bsi, evi, and aweinsh should be defined or imported to avoid errors.

