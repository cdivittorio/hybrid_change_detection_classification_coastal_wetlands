
############Part 1########################

# Check if required packages are installed, install if missing
packages <- c("changepoint", "bcp", "strucchange", "segmented", "tree")
install_if_missing <- packages[!(packages %in% installed.packages()[, "Package"])]
if(length(install_if_missing)) install.packages(install_if_missing)

# Load necessary libraries
library(changepoint)
library(bcp)
library(strucchange)
library(segmented)
library(tree)

# Data Upload
# Reading CSV files for bareland data
bareland_files <- paste0("B_", 1:8, ".csv")
bareland_data <- lapply(bareland_files, read.csv)

# Assign labels to each data frame in the list
bareland_data <- lapply(bareland_data, function(df) {
  df$Label <- 1
  return(df)
})

# Example: Check NDVI range for the first dataset
range(bareland_data[[1]]$NDVI)

# Vegetation Indices Functions
# Normalized Difference Vegetation Index (NDVI)
ndvi <- function(k, i) {
  (k - i) / (k + i)
}

# Normalized Difference Water Index (NDWI)
ndwi <- function(k, i) {
  (k - i) / (k + i)
}

# Modified Normalized Difference Water Index (MNDWI)
mndwi <- function(k, i) {
  (k - i) / (k + i)
}

# Normalized Pigment Chlorophyll Ratio Index (NPCRI)
npcri <- function(k, i) {
  (k - i) / (k + i)
}

# Normalized Difference Moisture Index (NDMI)
ndmi <- function(k, i) {
  (k - i) / (k + i)
}

# Bare Soil Index (BSI)
bsi <- function(k, i, p, q) {
  ((k + i) - (p - q)) / ((k + i) + (p + q))
}

# Soil Index (SI)
si <- function(k, i, p) {
  (k * (1 - i) * (1 - p)) ^ (1/3)
}

# Green Normalized Difference Vegetation Index (GNDVI)
gndvi <- function(k, i) {
  (k - i) / (k + i)
}

# Enhanced Vegetation Index (EVI)
evi <- function(k, i, p) {
  2.5 * ((k - i) / (k + 6 * i - 7.5 * p + 1))
}

# Atmospherically Resistant Vegetation Index (AVI)
avi <- function(k, i) {
  ((k * (1 - i)) * (k - i)) ^ (1/3)
}

# Soil-Adjusted Vegetation Index (SAVI)
savi <- function(k, i) {
  ((k - i) / (k + i + 0.5)) * 1.5
}

# Moisture Stress Index (MSI)
msi <- function(k, i) {
  k / i
}

# Green Chlorophyll Index (GCI)
gci <- function(k, i) {
  (k / i) - 1
}

# Simple Ratio (SR)
sr <- function(k, i) {
  k / i
}

# Modified Simple Ratio (MSR)
msr <- function(k, i) {
  k / ((i / k + 1) ^ 0.5)
}

# Infrared Percentage Vegetation Index (IRG)
irg <- function(k, i) {
  k - i
}

# Difference Vegetation Index (DVI)
dvi <- function(k, i) {
  k - i
}

# Modified Soil-Adjusted Vegetation Index (MSAVI)
msavi <- function(k, i) {
  0.5 * (2 * k + 1 - ((2 * k + 1)^2 - 8 * (k - i))^0.5)
}

# Automated Water Extraction Index - Normalized with Shadow (AWEInsh)
aweinsh <- function(k, i, p, q) {
  k + 2.5 * i - 1.5 * (p - q) - 0.25 * q
}

# List of datasets
datasets <- list(Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8)

# Function to compute all indices for a dataset
compute_indices <- function(data) {
  data$NDVI <- ndvi(data$NIR, data$Red)
  data$NDWI <- ndwi(data$NIR, data$SWIR1)
  data$MNDWI <- ndwi(data$Green, data$SWIR1)
  data$NPCRI <- npcri(data$Red, data$Blue)
  data$NDMI <- ndmi(data$NIR, data$SWIR2)
  data$BSI <- bsi(data$Red, data$SWIR1, data$NIR, data$Blue)
  data$SI <- si(data$Red, data$Green, data$Blue)
  data$GNDVI <- gndvi(data$NIR, data$Green)
  data$EVI <- evi(data$NIR, data$Red, data$Blue)
  data$AVI <- avi(data$NIR, data$Red)
  data$SAVI <- savi(data$NIR, data$Red)
  data$MSI <- msi(data$SWIR1, data$NIR)
  data$GCI <- gci(data$NIR, data$Green)
  data$SR <- sr(data$NIR, data$Red)
  data$MSR <- msr(data$Red, data$NIR)
  data$IRG <- irg(data$Red, data$Green)
  data$DVI <- dvi(data$NIR, data$Red)
  data$MSAVI <- msavi(data$NIR, data$Red)
  data$AEWInsh <- aweinsh(data$Blue, data$Green, data$NIR, data$SWIR2)
  
  return(data)
}

# Apply the function to each dataset
datasets <- lapply(datasets, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data1 <- datasets[[1]]
Data2 <- datasets[[2]]
Data3 <- datasets[[3]]
Data4 <- datasets[[4]]
Data5 <- datasets[[5]]
Data6 <- datasets[[6]]
Data7 <- datasets[[7]]
Data8 <- datasets[[8]]


# Define the columns to keep
columns_to_keep <- c("Blue", "Green", "Red", "NIR", "SWIR1", "SWIR2", "NDVI", "NDWI", "MNDWI", "Label", 
                     "NPCRI", "NDMI", "BSI", "SI", "GNDVI", "EVI", "SAVI", "MSI", "GCI", "SR", 
                     "MSR", "IRG", "DVI", "MSAVI", "AEWInsh")

# Create a function to select columns
select_columns <- function(data, columns) {
  data[, columns, drop = FALSE]
}

# Apply the function to all datasets
Data1 <- select_columns(Data1, columns_to_keep)
Data2 <- select_columns(Data2, columns_to_keep)
Data3 <- select_columns(Data3, columns_to_keep)
Data4 <- select_columns(Data4, columns_to_keep)
Data5 <- select_columns(Data5, columns_to_keep)
Data6 <- select_columns(Data6, columns_to_keep)
Data7 <- select_columns(Data7, columns_to_keep)
Data8 <- select_columns(Data8, columns_to_keep)


## Estuarine Emergent
## Uploading the Data
Data9=read.csv("E_1.csv")
Data10=read.csv("E_2.csv")
Data11=read.csv("E_3.csv")
Data12=read.csv("E_4.csv")
Data13=read.csv("E_5.csv")
Data14=read.csv("E_6.csv")
Data15=read.csv("E_7.csv")
Data16=read.csv("E_8.csv")

# List of datasets
datasets <- list(Data9, Data10, Data11, Data12, Data13, Data14, Data15, Data16)

# Function to compute all indices for a dataset
compute_indices <- function(data) {
  data$NDVI <- ndvi(data$NIR, data$Red)
  data$NDWI <- ndwi(data$NIR, data$SWIR1)
  data$MNDWI <- ndwi(data$Green, data$SWIR1)
  data$NPCRI <- npcri(data$Red, data$Blue)
  data$NDMI <- ndmi(data$NIR, data$SWIR2)
  data$BSI <- bsi(data$Red, data$SWIR1, data$NIR, data$Blue)
  data$SI <- si(data$Red, data$Green, data$Blue)
  data$GNDVI <- gndvi(data$NIR, data$Green)
  data$EVI <- evi(data$NIR, data$Red, data$Blue)
  data$AVI <- avi(data$NIR, data$Red)
  data$SAVI <- savi(data$NIR, data$Red)
  data$MSI <- msi(data$SWIR1, data$NIR)
  data$GCI <- gci(data$NIR, data$Green)
  data$SR <- sr(data$NIR, data$Red)
  data$MSR <- msr(data$Red, data$NIR)
  data$IRG <- irg(data$Red, data$Green)
  data$DVI <- dvi(data$NIR, data$Red)
  data$MSAVI <- msavi(data$NIR, data$Red)
  data$AEWInsh <- aweinsh(data$Blue, data$Green, data$NIR, data$SWIR2)
  
  return(data)
}

# Apply the function to each dataset
datasets <- lapply(datasets, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data9 <- datasets[[1]]
Data10 <- datasets[[2]]
Data11 <- datasets[[3]]
Data12 <- datasets[[4]]
Data13 <- datasets[[5]]
Data14 <- datasets[[6]]
Data15 <- datasets[[7]]
Data16 <- datasets[[8]]

## Estuarine Emergent to Open Water
## Uploading the Data
Data17=read.csv("EO_1.csv")
Data18=read.csv("EO_2.csv")
Data19=read.csv("EO_3.csv")
Data20=read.csv("EO_4.csv")
Data21=read.csv("EO_5.csv")
Data22=read.csv("EO_6.csv")
Data23=read.csv("EO_7.csv")
Data24=read.csv("EO_8.csv")

# List of datasets
datasets <- list(Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24)

# Function to compute all indices for a dataset
compute_indices <- function(data) {
  data$NDVI <- ndvi(data$NIR, data$Red)
  data$NDWI <- ndwi(data$NIR, data$SWIR1)
  data$MNDWI <- ndwi(data$Green, data$SWIR1)
  data$NPCRI <- npcri(data$Red, data$Blue)
  data$NDMI <- ndmi(data$NIR, data$SWIR2)
  data$BSI <- bsi(data$Red, data$SWIR1, data$NIR, data$Blue)
  data$SI <- si(data$Red, data$Green, data$Blue)
  data$GNDVI <- gndvi(data$NIR, data$Green)
  data$EVI <- evi(data$NIR, data$Red, data$Blue)
  data$AVI <- avi(data$NIR, data$Red)
  data$SAVI <- savi(data$NIR, data$Red)
  data$MSI <- msi(data$SWIR1, data$NIR)
  data$GCI <- gci(data$NIR, data$Green)
  data$SR <- sr(data$NIR, data$Red)
  data$MSR <- msr(data$Red, data$NIR)
  data$IRG <- irg(data$Red, data$Green)
  data$DVI <- dvi(data$NIR, data$Red)
  data$MSAVI <- msavi(data$NIR, data$Red)
  data$AEWInsh <- aweinsh(data$Blue, data$Green, data$NIR, data$SWIR2)
  
  return(data)
}

# Apply the function to each dataset
datasets <- lapply(datasets, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data17 <- datasets[[1]]
Data18 <- datasets[[2]]
Data19 <- datasets[[3]]
Data20 <- datasets[[4]]
Data21 <- datasets[[5]]
Data22 <- datasets[[6]]
Data23 <- datasets[[7]]
Data24 <- datasets[[8]]


# List of datasets
datasets <- list(Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24)

# List to store results
outputs <- list()

# Column names to select
columns_to_select <- c("Blue", "Green", "Red", "NIR", "SWIR1", "SWIR2", 
                       "NDVI", "NDWI", "MNDWI", "NPCRI", "BSI", "EVI", "AEWInsh")

# Loop through datasets and process
for (i in 1:length(datasets)) {
  # Select relevant columns and convert to matrix
  data_matrix <- data.matrix(datasets[[i]][, columns_to_select])
  
  # Perform Change Point Detection using e.divisive function
  outputs[[i]] <- e.divisive(data_matrix, sig.lvl = 0.05, R = 5000, alpha = 0.01)
}

# Assign the results to named variables for clarity if needed
names(outputs) <- paste0("output", 1:8)


# Define a function to split, label, and merge datasets
process_data <- function(data, ranges, labels, output_path) {
  processed_data <- list()
  
  # Split data according to given ranges
  for (i in 1:length(ranges)) {
    subset_data <- data[ranges[[i]],]
    subset_data$Label <- labels[i]  # Assign the label for this subset
    processed_data[[i]] <- subset_data
  }
  
  # Merge subsets
  merged_data <- do.call(rbind, processed_data)
  
  # Write the middle subset to CSV
  write.csv(processed_data[[2]], output_path, row.names = FALSE)
  
  return(merged_data)
}

# Split ranges and labels for each dataset
ranges17 <- list(1:74, 75:245, 246:479)
labels17 <- c(2, 8, 6)
ranges18 <- list(1:110, 111:399, 400:459)
labels18 <- c(2, 8, 6)
ranges19 <- list(1:67, 68:267, 268:474)
labels19 <- c(2, 8, 6)
ranges20 <- list(1:123, 124:172, 173:484)
labels20 <- c(2, 8, 6)
ranges21 <- list(1:96, 97:158, 159:439)
labels21 <- c(2, 8, 6)
ranges22 <- list(1:173, 174:439)
labels22 <- c(2, 6)
ranges23 <- list(1:145, 146:453)
labels23 <- c(2, 6)
ranges24 <- list(1:138, 139:352)
labels24 <- c(2, 6)

# Process datasets and save output
Data17 <- process_data(Data17, ranges17, labels17, "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data17b.csv")
Data18 <- process_data(Data18, ranges18, labels18, "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data18b.csv")
Data19 <- process_data(Data19, ranges19, labels19, "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data19b.csv")
Data20 <- process_data(Data20, ranges20, labels20, "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data20b.csv")
Data21 <- process_data(Data21, ranges21, labels21, "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data21b.csv")
Data22 <- process_data(Data22, ranges22, labels22, NULL)  # No CSV for Data22
Data23 <- process_data(Data23, ranges23, labels23, NULL)  # No CSV for Data23
Data24 <- process_data(Data24, ranges24, labels24, NULL)  # No CSV for Data24


## Palustrine Emergent Wetland

## Uploading the Data
Data25=read.csv("PE_1.csv")
Data26=read.csv("PE_2.csv")
Data27=read.csv("PE_3.csv")
Data28=read.csv("PE_4.csv")
Data29=read.csv("PE_5.csv")
Data30=read.csv("PE_6.csv")
Data31=read.csv("PE_7.csv")
Data32=read.csv("PE_8.csv")
Data33=read.csv("PE_9.csv")
Data34=read.csv("PE_10.csv")

# List of additional datasets
datasets_extended <- list(Data25, Data26, Data27, Data28, Data29, Data30, Data31, Data32, Data33, Data34)

# Apply the same compute_indices function to each dataset
datasets_extended <- lapply(datasets_extended, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data25 <- datasets_extended[[1]]
Data26 <- datasets_extended[[2]]
Data27 <- datasets_extended[[3]]
Data28 <- datasets_extended[[4]]
Data29 <- datasets_extended[[5]]
Data30 <- datasets_extended[[6]]
Data31 <- datasets_extended[[7]]
Data32 <- datasets_extended[[8]]
Data33 <- datasets_extended[[9]]
Data34 <- datasets_extended[[10]]


## Palustrine Emergent to Open Water
## Uploading the Data
Data35=read.csv("PEO_1.csv")
Data36=read.csv("PEO_2.csv")
Data37=read.csv("PEO_3.csv")
Data38=read.csv("PEO_4.csv")
Data39=read.csv("PEO_5.csv")
Data40=read.csv("PEO_6.csv")
Data41=read.csv("PEO_7.csv")
Data42=read.csv("PEO_8.csv")
Data43=read.csv("PEO_9.csv")
Data44=read.csv("PEO_10.csv")


# List of additional datasets (35 to 44)
datasets_extended_35_44 <- list(Data35, Data36, Data37, Data38, Data39, Data40, Data41, Data42, Data43, Data44)

# Apply the same compute_indices function to each dataset
datasets_extended_35_44 <- lapply(datasets_extended_35_44, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data35 <- datasets_extended_35_44[[1]]
Data36 <- datasets_extended_35_44[[2]]
Data37 <- datasets_extended_35_44[[3]]
Data38 <- datasets_extended_35_44[[4]]
Data39 <- datasets_extended_35_44[[5]]
Data40 <- datasets_extended_35_44[[6]]
Data41 <- datasets_extended_35_44[[7]]
Data42 <- datasets_extended_35_44[[8]]
Data43 <- datasets_extended_35_44[[9]]
Data44 <- datasets_extended_35_44[[10]]

# Load necessary libraries
library(dplyr)
library(easyPartition) # for e.divisive function

# Define the input dataset names (replace with your actual dataset names)
datasets <- list(Data35, Data36, Data37, Data38, Data39, Data40, Data41, Data42, Data43, Data44)

# Define the column names that are to be used in matrix conversion
columns_of_interest <- c("Blue", "Green", "Red", "NIR", "SWIR1", "SWIR2", "NDVI", "NDWI", 
                         "MNDWI", "NPCRI", "BSI", "EVI", "AEWInsh")

# Convert datasets to matrices for each Data frame
data_matrices <- lapply(datasets, function(data) data.matrix(data[, columns_of_interest]))

# Apply change point detection to each dataset matrix using e.divisive
change_point_results <- lapply(data_matrices, function(matrix) 
  e.divisive(matrix, sig.lvl = 0.05, R = 5000, alpha = 0.01))

# Helper function to process data and assign labels
process_data <- function(data, labels, split_indices, output_file) {
  data_split <- mapply(function(indices, label) {
    subset_data <- data[indices, ]
    subset_data$Label <- label
    return(subset_data)
  }, split_indices, labels, SIMPLIFY = FALSE)
  
  # Combine all the split datasets and write to CSV
  processed_data <- do.call(rbind, data_split)
  write.csv(processed_data, output_file, row.names = FALSE)
  return(processed_data)
}

# Define the split indices and labels for each dataset
split_indices <- list(
  list(1:120, 121:396, 397:456),
  list(1:86, 87:443, 444:478),
  list(1:95, 96:455, 455:478),
  list(1:95, 96:447, 448:482),
  list(1:136, 137:385, 386:479),
  list(1:282),
  list(1:94, 95:184, 185:475),
  list(1:46, 47:413, 414:447)
)

labels_list <- list(
  c(3, 9, 6),
  c(3, 9, 6),
  c(3, 9, 6),
  c(3, 9, 6),
  c(3, 9, 6),
  c(3), # Only one part for Data40
  c(3, 9, 6),
  c(3, 9, 6)
)

output_files <- c(
  "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data35b.csv",
  "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data36b.csv",
  "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data37b.csv",
  "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data38b.csv",
  "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data39b.csv",
  "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data40b.csv",
  "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data41b.csv",
  "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data42b.csv"
)

# Process datasets with respective split indices, labels, and output file paths
processed_data_list <- mapply(process_data, datasets, labels_list, split_indices, output_files, SIMPLIFY = FALSE)

# Check results and explore outputs if needed
processed_data_list[[1]]  # Example for Data35 processed result

# Example for displaying the change point results for one of the datasets (Data35)
change_point_results[[1]] # Change point detection result for Data35


## Palsutrine Scub Wetland
## Uploading the Data
Data45=read.csv("PS_1.csv")
Data46=read.csv("PS_2.csv")
Data47=read.csv("PS_3.csv")
Data48=read.csv("PS_4.csv")
Data49=read.csv("PS_5.csv")

# List of additional datasets (45 to 49)
datasets_extended_45_49 <- list(Data45, Data46, Data47, Data48, Data49)

# Apply the same compute_indices function to each dataset
datasets_extended_45_49 <- lapply(datasets_extended_45_49, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data45 <- datasets_extended_45_49[[1]]
Data46 <- datasets_extended_45_49[[2]]
Data47 <- datasets_extended_45_49[[3]]
Data48 <- datasets_extended_45_49[[4]]
Data49 <- datasets_extended_45_49[[5]]



## Palustrine Scrub Wetland to Open Water
## Uploading the Data
## Uploading the Data
Data50=read.csv("PSO_1.csv")
Data51=read.csv("PSO_2.csv")
Data52=read.csv("PSO_3.csv")
Data53=read.csv("PSO_4.csv")
Data54=read.csv("PSO_5.csv")


# List of additional datasets (50 to 54)
datasets_extended_50_54 <- list(Data50, Data51, Data52, Data53, Data54)

# Apply the same compute_indices function to each dataset
datasets_extended_50_54 <- lapply(datasets_extended_50_54, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data50 <- datasets_extended_50_54[[1]]
Data51 <- datasets_extended_50_54[[2]]
Data52 <- datasets_extended_50_54[[3]]
Data53 <- datasets_extended_50_54[[4]]
Data54 <- datasets_extended_50_54[[5]]


# Load necessary libraries
library(dbplyr)

# Dropping Unimportant Columns from the datasets
important_columns <- c("Blue", "Green", "Red", "NIR", "SWIR1", "SWIR2", "NDVI", "NDWI", "MNDWI", 
                       "NPCRI", "NDMI", "BSI", "SI", "GNDVI", "EVI", "SAVI", "MSI", "GCI", "SR", 
                       "MSR", "IRG", "DVI", "MSAVI", "AEWInsh")

Data50 <- Data50[, important_columns]
Data51 <- Data51[, important_columns]
Data52 <- Data52[, important_columns]
Data53 <- Data53[, important_columns]
Data54 <- Data54[, important_columns]

# Convert to matrix for change point detection
Data50m <- data.matrix(Data50)
Data51m <- data.matrix(Data51)
Data52m <- data.matrix(Data52)
Data53m <- data.matrix(Data53)
Data54m <- data.matrix(Data54)

# Change Point Detection using e.divisive
output20 <- e.divisive(Data50m, sig.lvl = 0.05, R = 5000, alpha = 0.01)
output21 <- e.divisive(Data51m, sig.lvl = 0.05, R = 5000, alpha = 0.01)
output22 <- e.divisive(Data52m, sig.lvl = 0.05, R = 5000, alpha = 0.01)
output23 <- e.divisive(Data53m, sig.lvl = 0.05, R = 5000, alpha = 0.01)
output24 <- e.divisive(Data54m, sig.lvl = 0.05, R = 5000, alpha = 0.01)

# Split the Data for Classification

# Data50 Split
Data50a <- Data50[1:113,]
Data50b <- Data50[114:268,]
Data50a$Label <- 4
Data50 <- merge(Data50a, Data50b, all = TRUE)

# Data51 Split
Data51a <- Data51[1:52,]
Data51b <- Data51[53:402,]
Data51c <- Data51[403:458,]
Data51a$Label <- 4
Data51b$Label <- 10
Data51c$Label <- 6
Data51i <- merge(Data51a, Data51b, all = TRUE)
Data51 <- merge(Data51i, Data51c, all = TRUE)
write.csv(Data51b, "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data51b.csv", row.names = FALSE)

# Data52 Split
Data52a <- Data52[1:51,]
Data52b <- Data52[52:376,]
Data52c <- Data52[377:433,]
Data52a$Label <- 4
Data52b$Label <- 10
Data52c$Label <- 6
Data52i <- merge(Data52a, Data52b, all = TRUE)
Data52 <- merge(Data52i, Data52c, all = TRUE)
write.csv(Data52b, "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data52b.csv", row.names = FALSE)

# Data53 Split
Data53a <- Data53[1:34,]
Data53b <- Data53[35:368,]
Data53c <- Data53[369:426,]
Data53a$Label <- 4
Data53b$Label <- 10
Data53c$Label <- 6
Data53i <- merge(Data53a, Data53b, all = TRUE)
Data53 <- merge(Data53i, Data53c, all = TRUE)
write.csv(Data53b, "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data53b.csv", row.names = FALSE)

# Data54 Split
Data54a <- Data54[1:66,]
Data54b <- Data54[67:384,]
Data54c <- Data54[385:435,]
Data54a$Label <- 4
Data54b$Label <- 10
Data54c$Label <- 6
Data54i <- merge(Data54a, Data54b, all = TRUE)
Data54 <- merge(Data54i, Data54c, all = TRUE)
write.csv(Data54b, "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data54b.csv", row.names = FALSE)


## Palustrine Forested Wetland

## Uploading the Data
Data55=read.csv("PF_1.csv")
Data56=read.csv("PF_2.csv")
Data57=read.csv("PF_3.csv")
Data58=read.csv("PF_4.csv")
Data59=read.csv("PF_5.csv")
Data60=read.csv("PF_6.csv")
Data61=read.csv("PF_7.csv")
Data62=read.csv("PF_8.csv")
Data63=read.csv("PF_9.csv")
Data64=read.csv("PF_10.csv")

# List of additional datasets (55 to 64)
datasets_extended_55_64 <- list(Data55, Data56, Data57, Data58, Data59, Data60, Data61, Data62, Data63, Data64)

# Apply the compute_indices function to the new datasets
datasets_extended_55_64 <- lapply(datasets_extended_55_64, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data55 <- datasets_extended_55_64[[1]]
Data56 <- datasets_extended_55_64[[2]]
Data57 <- datasets_extended_55_64[[3]]
Data58 <- datasets_extended_55_64[[4]]
Data59 <- datasets_extended_55_64[[5]]
Data60 <- datasets_extended_55_64[[6]]
Data61 <- datasets_extended_55_64[[7]]
Data62 <- datasets_extended_55_64[[8]]
Data63 <- datasets_extended_55_64[[9]]
Data64 <- datasets_extended_55_64[[10]]

## Palustrine Forested to Open Water
## Uploading the Data
Data65=read.csv("PFO_1.csv")
Data66=read.csv("PFO_2.csv")
Data67=read.csv("PFO_3.csv")
Data68=read.csv("PFO_4.csv")
Data69=read.csv("PFO_5.csv")
Data70=read.csv("PFO_6.csv")
Data71=read.csv("PFO_7.csv")
Data72=read.csv("PFO_8.csv")
Data73=read.csv("PFO_9.csv")
Data74=read.csv("PFO_10.csv")


# List of additional datasets (65 to 74)
datasets_extended_65_74 <- list(Data65, Data66, Data67, Data68, Data69, Data70, Data71, Data72, Data73, Data74)

# Apply the compute_indices function to each dataset
datasets_extended_65_74 <- lapply(datasets_extended_65_74, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data65 <- datasets_extended_65_74[[1]]
Data66 <- datasets_extended_65_74[[2]]
Data67 <- datasets_extended_65_74[[3]]
Data68 <- datasets_extended_65_74[[4]]
Data69 <- datasets_extended_65_74[[5]]
Data70 <- datasets_extended_65_74[[6]]
Data71 <- datasets_extended_65_74[[7]]
Data72 <- datasets_extended_65_74[[8]]
Data73 <- datasets_extended_65_74[[9]]
Data74 <- datasets_extended_65_74[[10]]


# Load necessary libraries
library(dbplyr)

# Drop unnecessary columns
selected_columns <- c("Blue", "Green", "Red", "NIR", "SWIR1", "SWIR2", "NDVI", 
                      "NDWI", "MNDWI", "NPCRI", "NDMI", "BSI", "SI", "GNDVI", 
                      "EVI", "SAVI", "MSI", "GCI", "SR", "MSR", "IRG", "DVI", 
                      "MSAVI", "AEWInsh")

datasets <- list(Data65, Data66, Data67, Data68, Data69, Data70, Data71, Data72, Data73, Data74)

# Loop through datasets and drop unnecessary columns
for (i in 1:length(datasets)) {
  datasets[[i]] <- datasets[[i]][, selected_columns]
}

# Convert each dataset to matrix format for analysis
for (i in 1:length(datasets)) {
  datasets[[i]] <- data.matrix(datasets[[i]])
}

# Perform Change Point Detection
library(denstrip)
output_list <- list()

for (i in 1:length(datasets)) {
  output_list[[i]] <- e.divisive(datasets[[i]], sig.lvl = 0.05, R = 5000, alpha = 0.01)
}

# Split data into parts and label
split_data <- function(data, split_points, labels, file_path) {
  data_split <- list()
  
  # Split the data into parts based on split_points and label them
  for (i in 1:length(split_points)) {
    data_split[[i]] <- data[split_points[[i]], ]
    data_split[[i]]$Label <- labels[i]
  }
  
  # Merge the parts back together
  merged_data <- do.call(rbind, data_split)
  
  # Write the middle part to CSV
  write.csv(data_split[[2]], file_path, row.names = FALSE)
  
  return(merged_data)
}

# Define split points and labels for each dataset
split_info <- list(
  list(1:80, 81:252, 253:446),
  list(1:80, 81:216, 217:271),
  list(1:144, 145:209, 210:293),
  list(1:292),
  list(1:39, 40:190, 191:285)
)

labels <- list(c(5, 11, 6), c(5, 11, 6), c(5, 11, 6), c(5), c(5, 11, 6))

# Split and label each dataset
for (i in 1:length(datasets)) {
  file_path <- paste0("D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data", 65 + i, "b.csv")
  datasets[[i]] <- split_data(datasets[[i]], split_info[[i]], labels[[i]], file_path)
}

# Final merged datasets
Data65 <- datasets[[1]]
Data66 <- datasets[[2]]
Data67 <- datasets[[3]]
Data68 <- datasets[[4]]
Data69 <- datasets[[5]]

## OPENWATER

## Uploading the Data
Data75=read.csv("O_1.csv")
Data76=read.csv("O_2.csv")
Data77=read.csv("O_3.csv")
Data78=read.csv("O_4.csv")
Data79=read.csv("O_5.csv")
Data80=read.csv("O_6.csv")
Data81=read.csv("O_7.csv")
Data82=read.csv("O_8.csv")
Data83=read.csv("O_9.csv")
Data84=read.csv("O_10.csv")


# List of additional datasets (75 to 84)
datasets_extended_75_84 <- list(Data75, Data76, Data77, Data78, Data79, Data80, Data81, Data82, Data83, Data84)

# Apply the compute_indices function to each dataset
datasets_extended_75_84 <- lapply(datasets_extended_75_84, compute_indices)

# Assign back the modified datasets to the original variables if necessary
Data75 <- datasets_extended_75_84[[1]]
Data76 <- datasets_extended_75_84[[2]]
Data77 <- datasets_extended_75_84[[3]]
Data78 <- datasets_extended_75_84[[4]]
Data79 <- datasets_extended_75_84[[5]]
Data80 <- datasets_extended_75_84[[6]]
Data81 <- datasets_extended_75_84[[7]]
Data82 <- datasets_extended_75_84[[8]]
Data83 <- datasets_extended_75_84[[9]]
Data84 <- datasets_extended_75_84[[10]]




############Part 2########################

# List of data frames
data_list <- list(Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10,
                  Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20,
                  Data21, Data22, Data23, Data24, Data25, Data26, Data27, Data28, Data29, Data30,
                  Data31, Data32, Data33, Data34, Data35, Data36, Data37, Data38, Data39, Data40,
                  Data41, Data42, Data43, Data44, Data45, Data46, Data47, Data48, Data49, Data50,
                  Data51, Data52, Data53, Data54, Data55, Data56, Data57, Data58, Data59, Data60,
                  Data61, Data62, Data63, Data64, Data65, Data66, Data67, Data68, Data69, Data70,
                  Data71, Data72, Data73, Data74, Data75, Data76, Data77, Data78, Data79, Data80,
                  Data81, Data82, Data83, Data84, Data85, Data86, Data87, Data88, Data89)

# Loop to write each data frame to a CSV file
for (i in 1:length(data_list)) {
  write.csv(data_list[[i]], paste0("D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Data", i, ".csv"), row.names = FALSE)
}


library(tidyverse)
library(caret)
library(magrittr)
library(randomForest)
library(dbplyr)

# Function to load and preprocess data
load_and_preprocess_data <- function(path) {
  data_all <- list.files(path = path, pattern = "*.csv", full.names = TRUE) %>%
    lapply(read_csv) %>%
    bind_rows()
  
  # Select relevant columns
  data <- data_all[, c("Blue", "Green", "Red", "NIR", "SWIR1", "SWIR2", 
                       "NDVI", "NDWI", "MNDWI", "Label", "NPCRI", "EVI", "AEWInsh", "BSI")]
  
  # Remove NA values
  data <- na.omit(data)
  
  # Convert Label to factor
  data$Label <- as.factor(data$Label)
  
  return(data)
}

# Load training and testing data
train_data <- load_and_preprocess_data("D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Train")
test_data <- load_and_preprocess_data("D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Test")

# Print summaries
summary(train_data$Label)
summary(test_data$Label)

# Set up Random Forest model training
trainIndex <- createDataPartition(train_data$Label, p = 1, list = FALSE)
TRAIN <- train_data[trainIndex, ]
TEST <- test_data

train_ctrl <- trainControl(method = 'repeatedcv', repeats = 3, number = 10)

# Train Random Forest Model
model_rf <- train(Label ~ Blue + Green + Red + NIR + SWIR1 + SWIR2 + NDVI + 
                    NDWI + MNDWI + BSI + EVI + NPCRI + AEWInsh,
                  data = TRAIN,
                  method = "rf",
                  metric = "Accuracy",
                  trControl = train_ctrl,
                  ntree = 741,
                  importance = TRUE)

# Plot variable importance
randomForest::varImpPlot(model_rf$finalModel)


# Load necessary libraries
library(tidyverse)
library(caret)
library(magrittr)
library(NHANES)

# Set random seed for reproducibility
set.seed(8576309)

# Load training data
TRAIN <- read.csv("path/to/your/train_data.csv") # Update with the actual path
TEST <- read.csv("path/to/your/test_data.csv")   # Update with the actual path

# Convert Label to factor
TRAIN$Label <- factor(TRAIN$Label)

# Train Random Forest model
model_rf <- train(Label ~ ., 
                  data = TRAIN, 
                  method = "rf", 
                  trControl = trainControl(method = "cv", number = 10),
                  tuneLength = 10)

# Print model summary and variable importance
print(model_rf)
plot(model_rf)
varImp_rf <- varImp(model_rf)
plot(varImp_rf, main = "Variable Importance of RF Tuned Model")

# Evaluate model performance on training data
train_predictions <- predict(model_rf, newdata = TRAIN[, -ncol(TRAIN)], type = "raw")
confusionMatrix(train_predictions, as.factor(TRAIN$Label))

# Evaluate model performance on test data
test_predictions <- predict(model_rf, newdata = TEST[, -ncol(TEST)], type = "raw")
confusionMatrix(test_predictions, as.factor(TEST$Label))

# Load test data for classification
Data_test <- read.csv("D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Test/Combined_4_test.csv")
Data_test$Label <- factor(Data_test$Label)

# Filter out irrelevant classes
Data_test <- subset(Data_test, !Label %in% c("7", "8", "9", "10", "11"))

# Recode to 4 classes
Data_test$Label <- recode_factor(Data_test$Label, 
                                 "1" = "1", 
                                 "2" = "2",
                                 "3" = "3", 
                                 "4" = "3", 
                                 "5" = "3", 
                                 "6" = "4")

# Load prediction data for various classes
test_data_files <- list.files(path = "path/to/test/data/", pattern = "*.csv", full.names = TRUE)

# Function to predict and save results
predict_and_save <- function(model, data_files, class_count, output_path) {
  for (file in data_files) {
    data <- read.csv(file)
    predictions <- predict(model, newdata = data, type = ifelse(class_count == 6, "raw", "prob"))
    output_file <- paste0(output_path, "P_", basename(file))
    write.csv(predictions, output_file, row.names = FALSE)
  }
}

# Predict and save for 6 classes
predict_and_save(model_rf, test_data_files, class_count = 6, output_path = "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/")

# Predict and save for 4 classes
predict_and_save(model_rf, test_data_files, class_count = 4, output_path = "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/")



# Function to combine time data and predictions into a data frame
combine_data <- function(data_time, predictions) {
  combined_df <- cbind(data_time, predictions)
  return(data.frame(combined_df))
}

# Function to write a data frame to a CSV file
write_data_to_csv <- function(data_frame, file_path) {
  write.csv(data_frame, file_path, row.names = FALSE)
}

# Combining required DataFrames for Estuarine Emergent to Open Water
P1_4 <- combine_data(Data17$Time, P1_4$predict.model_rf..newdata...Data17.)
P2_4 <- combine_data(Data18$Time, P2_4$predict.model_rf..newdata...Data18.)
P3_4 <- combine_data(Data19$Time, P3_4$predict.model_rf..newdata...Data19.)
P4_4 <- combine_data(Data20$Time, P4_4$predict.model_rf..newdata...Data20.)
P5_4 <- combine_data(Data21$Time, P5_4$predict.model_rf..newdata...Data21.)
P6_4 <- combine_data(Data22$Time, P6_4$predict.model_rf..newdata...Data22.)
P7_4 <- combine_data(Data23$Time, P7_4$predict.model_rf..newdata...Data23.)
P8_4 <- combine_data(Data24$Time, P8_4$predict.model_rf..newdata...Data24.)

# Combining required DataFrames for Palustrine Emergent to Open Water
P9_4 <- combine_data(Data35$Time, P9_4$predict.model_rf..newdata...Data35.)
P10_4 <- combine_data(Data36$Time, P10_4$predict.model_rf..newdata...Data36.)
P11_4 <- combine_data(Data37$Time, P11_4$predict.model_rf..newdata...Data37.)
P12_4 <- combine_data(Data38$Time, P12_4$predict.model_rf..newdata...Data38.)
P13_4 <- combine_data(Data39$Time, P13_4$predict.model_rf..newdata...Data39.)
P14_4 <- combine_data(Data40$Time, P14_4$predict.model_rf..newdata...Data40.)
P15_4 <- combine_data(Data41$Time, P15_4$predict.model_rf..newdata...Data41.)
P16_4 <- combine_data(Data42$Time, P16_4$predict.model_rf..newdata...Data42.)
P17_4 <- combine_data(Data43$Time, P17_4$predict.model_rf..newdata...Data43.)
P18_4 <- combine_data(Data44$Time, P18_4$predict.model_rf..newdata...Data44.)

# Combining required DataFrames for Palustrine Scrub to Open Water
P19_4 <- combine_data(Data50$Time, P19_4$predict.model_rf..newdata...Data50.)
P20_4 <- combine_data(Data51$Time, P20_4$predict.model_rf..newdata...Data51.)
P21_4 <- combine_data(Data52$Time, P21_4$predict.model_rf..newdata...Data52.)
P22_4 <- combine_data(Data53$Time, P22_4$predict.model_rf..newdata...Data53.)
P23_4 <- combine_data(Data54$Time, P23_4$predict.model_rf..newdata...Data54.)

# Combining required DataFrames for Palustrine Forested to Open Water
P24_4 <- combine_data(Data65$Date, P24_4$predict.model_rf..newdata...Data65.)
P25_4 <- combine_data(Data66$Dates, P25_4$predict.model_rf..newdata...Data66.)
P26_4 <- combine_data(Data67$Dates, P26_4$predict.model_rf..newdata...Data67.)
P27_4 <- combine_data(Data68$Dates, P27_4$predict.model_rf..newdata...Data68.)
P28_4 <- combine_data(Data69$Dates, P28_4$predict.model_rf..newdata...Data69.)
P29_4 <- combine_data(Data70$Dates, P29_4$predict.model_rf..newdata...Data70.)
P30_4 <- combine_data(Data71$Dates, P30_4$predict.model_rf..newdata...Data71.)
P31_4 <- combine_data(Data72$Dates, P31_4$predict.model_rf..newdata...Data72.)
P32_4 <- combine_data(Data73$Dates, P32_4$predict.model_rf..newdata...Data73.)
P33_4 <- combine_data(Data74$Date, P33_4$predict.model_rf..newdata...Data74.)

# Combining required DataFrames for Bareland to Open Water
P34_4 <- combine_data(Data87$Date, P34_4$predict.model_rf..newdata...Data87.)
P35_4 <- combine_data(Data88$Date, P35_4$predict.model_rf..newdata...Data88.)
P36_4 <- combine_data(Data89$Date, P36_4$predict.model_rf..newdata...Data89.)
P37_4 <- combine_data(Data90$Date, P37_4$predict.model_rf..newdata...Data90.)

# Defining file paths for CSV export
output_directory <- "D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/Train/Class/"
files_to_export <- list(
  P1_4, P2_4, P3_4, P4_4, P5_4, P6_4, P7_4, P8_4,
  P9_4, P10_4, P11_4, P12_4, P13_4, P14_4, P15_4, P16_4,
  P17_4, P18_4, P19_4, P20_4, P21_4, P22_4, P23_4,
  P24_4, P25_4, P26_4, P27_4, P28_4, P29_4, P30_4, P31_4,
  P32_4, P33_4, P34_4, P35_4, P36_4, P37_4
)

# Exporting datasets to CSV files
for (i in seq_along(files_to_export)) {
  write_data_to_csv(files_to_export[[i]], file.path(output_directory, paste0("P", i, "_4.csv")))
}


# Define a list of datasets for prediction
data_list <- list(Data17, Data18, Data19, Data20, Data21, Data22, Data23, Data24,
                  Data35, Data36, Data37, Data38, Data39, Data40, Data41, Data42,
                  Data43, Data44, Data50, Data51, Data52, Data53, Data54,
                  Data65, Data66, Data67, Data68, Data69, Data70, Data71, Data72, Data73, Data74,
                  Data87, Data88, Data89, Data90)

# Define a naming convention for output files
output_names <- c(paste0("P", 1:8, "_4_P"),
                  paste0("P", 9:18, "_4_P"),
                  paste0("P", 19:23, "_4_P"),
                  paste0("P", 24:33, "_4_P"),
                  paste0("P", 34:37, "_4_P"))

# Loop through datasets to make predictions and save results
for (i in seq_along(data_list)) {
  # Make predictions
  prob_predictions <- data.frame(predict(model_rf, newdata = data_list[[i]], type = "prob"))
  
  # Save predictions to CSV
  write.csv(prob_predictions, 
            file = paste0("D:/Rabby/Blackwater/Analysis_Combined_Tide/Classification/13 Factors/", output_names[i], ".csv"), 
            row.names = FALSE)
}


############Part 3########################


## Uploading the NetCDF Files and Applying the Models


## Load necessary packages
library(ncdf4)
library(tidyverse)

set.seed(8576309)

## Uploading bands

band1 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb1.nc")
band2 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb2.nc")
band3 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb3.nc")
band4 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb4.nc")
band5 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb5.nc")
band7 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb7.nc")

# Check attributes of the bands
print(band1)
print(band2)
print(band3)
print(band4)
print(band5)
print(band7)

# Extract latitude, longitude, and time
lat = ncvar_get(band1, "lat")
lon = ncvar_get(band1, "lon")
time = ncvar_get(band7, "time")

lat = as.vector(lat)
lon = as.vector(lon)

# Band1 Data Extraction
band_array = ncvar_get(band1, "band1")
bands = list()

# Extract specific bands
for (i in 1201:1210) {
  bands[[i-1200]] = band_array[,,i]
}

# Convert the first band data into a dataframe and combine with lat/lon
b1 = bands[[1]]
b1_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b1 = as.vector(b1))

# Repeat for other bands
b2 = bands[[2]]
b2_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b2 = as.vector(b2))

b3 = bands[[3]]
b3_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b3 = as.vector(b3))

b4 = bands[[4]]
b4_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b4 = as.vector(b4))

b5 = bands[[5]]
b5_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b5 = as.vector(b5))

b6 = bands[[6]]
b6_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b6 = as.vector(b6))

b7 = bands[[7]]
b7_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b7 = as.vector(b7))

b8 = bands[[8]]
b8_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b8 = as.vector(b8))

b9 = bands[[9]]
b9_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b9 = as.vector(b9))

b10 = bands[[10]]
b10_df = data.frame(lat = rep(lat, length(lon)), lon = rep(lon, each = length(lat)), b10 = as.vector(b10))

# Now, you can access the processed band data frames like b1_df, b2_df, etc.
# Example: View the first few rows of the first band
head(b1_df)

## Load necessary packages
library(ncdf4)
library(tidyverse)

set.seed(8576309)

## Uploading bands

band1 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb1.nc")
band2 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb2.nc")
band3 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb3.nc")
band4 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb4.nc")
band5 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb5.nc")
band7 = nc_open("D:/Rabby/NETCDF/BW_netcdf/BWb7.nc")

# Check attributes of the bands
print(band1)
print(band2)
print(band3)
print(band4)
print(band5)
print(band7)

# Extract latitude, longitude, and time
lat = ncvar_get(band1, "lat")
lon = ncvar_get(band1, "lon")
time = ncvar_get(band7, "time")

lat = as.vector(lat)
lon = as.vector(lon)

# Band Data Extraction
band_array = ncvar_get(band1, "band1")

# Create a list to hold data frames for each band
band_dfs = list()

# Loop through bands 1 to 7 and create a data frame for each
for (i in 1:7) {
  band_data = band_array[, , 1200 + i]  # Adjust the index to select bands 1-7
  band_df = data.frame(
    lat = rep(lat, length(lon)), 
    lon = rep(lon, each = length(lat)), 
    band = as.vector(band_data)
  )
  
  # Name each data frame dynamically
  band_dfs[[paste0("band", i, "_df")]] = band_df
}

# Now you have a list 'band_dfs' with data frames for each band from 1 to 7.
# Example: View the first few rows of the first band
head(band_dfs$band1_df)


# Define a function to calculate indices for each dataset
calculate_indices <- function(data) {
  data$NDVI <- ndvi(data$NIR, data$Red)
  data$NDWI <- ndwi(data$NIR, data$SWIR1)
  data$MNDWI <- ndwi(data$Green, data$SWIR1)
  data$NPCRI <- npcri(data$Red, data$Blue)
  data$BSI <- bsi(data$Red, data$SWIR1, data$NIR, data$Blue)
  data$EVI <- evi(data$NIR, data$Red, data$Blue)
  data$AEWInsh <- aweinsh(data$Blue, data$Green, data$NIR, data$SWIR2)
  return(data)
}

# Apply the function to each dataset
T1 <- calculate_indices(T1)
T2 <- calculate_indices(T2)
T3 <- calculate_indices(T3)
T4 <- calculate_indices(T4)
T5 <- calculate_indices(T5)
T6 <- calculate_indices(T6)
T7 <- calculate_indices(T7)
T8 <- calculate_indices(T8)
T9 <- calculate_indices(T9)
T10 <- calculate_indices(T10)


## Threshold for Sensitivity and Specificity

# Load necessary libraries
library(caret)
library(tidyverse)
library(magrittr)

# Set seed for reproducibility
set.seed(8576309)

# Read data
Vegetation <- read.csv("Vegetation.csv")

# Create factors based on percentage thresholds
thresholds <- seq(50, 80, by = 1)
for (i in 1:length(thresholds)) {
  Vegetation[[paste0("P", i)]] <- ifelse(Vegetation$Percentage > thresholds[i], "S", "Un")
}

# Convert relevant columns to factors
Vegetation$Condition <- factor(Vegetation$Condition)
for (i in 1:31) {
  Vegetation[[paste0("P", i)]] <- factor(Vegetation[[paste0("P", i)]])
}

# Define expected and predicted values
expected_value <- Vegetation$Condition
predicted_values <- Vegetation[, paste0("P", 1:31)]

# Function to calculate confusion matrices for each predicted value
confusion_matrices <- lapply(predicted_values, function(predicted_value) {
  confusionMatrix(predicted_value, expected_value)
})

# Output confusion matrices for each P1 to P31
names(confusion_matrices) <- paste0("Confusion_Matrix_P", 1:31)

# Print confusion matrices
confusion_matrices

# Load necessary libraries
library(caret)
library(dplyr)
library(ggplot2)

# Set seed for reproducibility
set.seed(8576309)

# Read data
Vegetation <- read.csv("Vegetation.csv")

# Create factors based on percentage thresholds (50 to 80)
thresholds <- seq(50, 80, by = 1)
for (i in 1:length(thresholds)) {
  Vegetation[[paste0("P", i)]] <- ifelse(Vegetation$Percentage > thresholds[i], "S", "Un")
}

# Convert relevant columns to factors
Vegetation$Condition <- factor(Vegetation$Condition)
for (i in 1:31) {
  Vegetation[[paste0("P", i)]] <- factor(Vegetation[[paste0("P", i)]])
}

# Define expected and predicted values
expected_value <- Vegetation$Condition
predicted_values <- Vegetation[, paste0("P", 1:31)]

# Function to calculate confusion matrix for each predicted value
get_confusion_matrix <- function(predicted_value, expected_value) {
  confusionMatrix(predicted_value, expected_value)
}

# Apply the function to each predicted column
results <- lapply(predicted_values, get_confusion_matrix, expected_value = expected_value)

# Extract confusion matrix results for "byClass"
results_byClass <- lapply(results, function(res) res$byClass)

# Convert to a data frame
XY <- as.data.frame(results_byClass)

# Remove unnecessary rows (rows 3-10)
XY <- XY %>% slice(-c(3:10))

# Transpose the data frame
XY_new <- as.data.frame(t(XY))
# Add threshold values
XY_new$Threshold <- seq(50, 80, by = 1)

# Calculate Commission and Omission Errors
XY_new$CE <- 1 - XY_new$Specificity
XY_new$OE <- 1 - XY_new$Sensitivity

# Plot Commission Error (CE)
ggplot(XY_new, aes(x = Threshold, y = CE)) +
  geom_line() +
  ggtitle("Commission Error (CE)") +
  xlab("Threshold") + 
  ylab("CE")

# Plot Omission Error (OE)
ggplot(XY_new, aes(x = Threshold, y = OE)) +
  geom_line() +
  ggtitle("Omission Error (OE)") +
  xlab("Threshold") + 
  ylab("OE")

# Combined plot (CE and OE)
plot(XY_new$Threshold, XY_new$CE, type = "o", col = "blue", pch = "o", ylab = "Error", xlab = "Threshold", lty = 1)
points(XY_new$Threshold, XY_new$OE, col = "red", pch = "*")
lines(XY_new$Threshold, XY_new$OE, col = "red", lty = 2)

# Add legend
legend("topright", legend = c("CE", "OE"), col = c("blue", "red"), pch = c("o", "*"), lty = c(1, 2), ncol = 1)


# Loading necessary libraries
library(caret)      # For confusionMatrix function
library(tidyverse)  # For data manipulation and plotting
library(magrittr)   # For piping (%<>%)
library(NHANES)     # If necessary for other functionalities
library(dplyr)      # For data manipulation

# Setting a random seed for reproducibility
set.seed(8576309)

# Reading the Openwater dataset
Openwater <- read.csv("Openwater.csv")

# Creating binary columns based on percentage thresholds
thresholds <- seq(50, 80, 1)
for (i in 1:length(thresholds)) {
  column_name <- paste0("P", i)
  Openwater[[column_name]] <- ifelse(Openwater$Percentage > thresholds[i], "S", "Un")
}

# Converting columns to factors
factor_columns <- c("Condition", paste0("P", 1:31))
Openwater[factor_columns] <- lapply(Openwater[factor_columns], factor)

# Assigning expected and predicted values
expected_value <- Openwater$Condition
predicted_values <- lapply(1:31, function(i) Openwater[[paste0("P", i)]])

# Calculating confusion matrices for each prediction column
results <- lapply(predicted_values, function(pred) confusionMatrix(data = pred, reference = expected_value))

# Extracting byClass results from each confusion matrix
byClass_results <- lapply(results, function(res) res$byClass)

# Combining results into a data frame for easy manipulation
XY_P <- as.data.frame(byClass_results)

# Removing unnecessary rows from the results
XY_P <- XY_P %>% slice(-c(3, 4, 5, 6, 7, 8, 9, 10, 11))

# Transposing the results to match the structure needed
XY_Pnew <- as.data.frame(t(XY_P))
XY_Pnew$Threshold <- thresholds

# Calculating Commission Error (CE) and Omission Error (OE)
XY_Pnew$CE <- 1 - XY_Pnew$Specificity
XY_Pnew$OE <- 1 - XY_Pnew$Sensitivity

# Plotting Commission Error (CE) vs Threshold
ggplot(XY_Pnew, aes(x = Threshold, y = CE)) +
  geom_line() +
  labs(title = "Commission Error vs Threshold", y = "Commission Error (CE)", x = "Threshold") +
  theme_minimal()

# Plotting Omission Error (OE) vs Threshold
ggplot(XY_Pnew, aes(x = Threshold, y = OE)) +
  geom_line() +
  labs(title = "Omission Error vs Threshold", y = "Omission Error (OE)", x = "Threshold") +
  theme_minimal()

# Base plot with both CE and OE for comparison
plot(XY_Pnew$Threshold, XY_Pnew$CE, type = "o", col = "blue", pch = "o", ylab = "Error", lty = 1, 
     xlab = "Threshold", main = "Commission and Omission Errors")
points(XY_Pnew$Threshold, XY_Pnew$OE, col = "red", pch = "*")
lines(XY_Pnew$Threshold, XY_Pnew$OE, col = "red", lty = 2)

# Adding a legend
legend("topright", legend = c("CE", "OE"), col = c("blue", "red"), pch = c("o", "*"), lty = c(1, 2), ncol = 1)


# Load required libraries
library(caret)
library(tidyverse)
library(NHANES)
library(magrittr)

# Set seed for reproducibility
set.seed(8576309)

# Read data
Overall <- read.csv("Overall.csv")

# Define thresholds for binary classification
thresholds <- 50:80

# Create binary classification columns dynamically
for (i in 1:length(thresholds)) {
  threshold <- thresholds[i]
  Overall[[paste0("P", i)]] <- with(Overall, ifelse(Percentage > threshold, "S", "Un"))
}

# Convert all columns to factor
factor_columns <- c("Condition", paste0("P", 1:31))
Overall[factor_columns] <- lapply(Overall[factor_columns], factor)

# Extract expected and predicted values for each model
expected_value <- Overall$Condition
predicted_values <- lapply(1:31, function(i) Overall[[paste0("P", i)]])

# Calculate confusion matrices for each predicted value
results <- lapply(predicted_values, function(predicted) confusionMatrix(data = predicted, reference = expected_value))

# Extract byClass results
x_O <- lapply(results, function(res) res$byClass)

# Convert the list into a data frame
XY_O <- as.data.frame(x_O)

# Remove irrelevant rows
XY_O <- XY_O %>% slice(-c(3, 4, 5, 6, 7))

# Transpose and prepare the data for plotting
XY_O_new <- as.data.frame(t(XY_O))
XY_O_new$Threshold <- thresholds

# Calculate Commission and Omission errors
XY_O_new$CE <- 1 - XY_O_new$Specificity
XY_O_new$OE <- 1 - XY_O_new$Sensitivity

# Plot Commission Error (CE)
ggplot(XY_O_new, aes(x = Threshold, y = CE)) +
  geom_line() +
  labs(title = "Commission Error (CE) vs Threshold", x = "Threshold", y = "CE")

# Plot Omission Error (OE)
ggplot(XY_O_new, aes(x = Threshold, y = OE)) +
  geom_line() +
  labs(title = "Omission Error (OE) vs Threshold", x = "Threshold", y = "OE")

# Combined plot for CE and OE
plot(XY_O_new$Threshold, XY_O_new$CE, type = "o", col = "blue", pch = "o", ylab = "Error", lty = 1,
     main = "Commission and Omission Errors vs Threshold")
points(XY_O_new$Threshold, XY_O_new$OE, col = "red", pch = "*")
lines(XY_O_new$Threshold, XY_O_new$OE, col = "red", lty = 2)

# Add legend
legend("topright", legend = c("CE", "OE"), col = c("blue", "red"), pch = c("o", "*"), lty = c(1, 2), ncol = 1)


