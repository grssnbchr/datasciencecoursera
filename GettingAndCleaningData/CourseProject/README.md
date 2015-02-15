# Getting And Cleaning Data Course Project
Course project for the "Getting and cleaning data" Coursera class.

## Prequisites to run the code
None, it will download and extract the archive automagically and produce the output as tidy_data.txt

## Explanation of what happens
Actually, my code is commented thoroughly and I don't see the point in explaining everything all over again, here. But here's an overview:

- **Step 0** (corresponds to the steps in the assignment): After loading necessary packages (dplyr, data.table and reshape2) and getting the raw data, the raw data is saved into data.tables.
- **Step 1**: Both training and test sets are unionized using `rbind`. 
- **Step 2 + 3**: Feature names are read in and used to replace the V1, V2's, etc. Regular expressions (with `grep`) are then used to only retain features containing `mean()` and `std()`. Here, dplyr's `select` comes in handy.
- **Step 4**: As we have only numbers for activities, the actual activity lables are read in and joined using the `label`-column (with `merge`), which is then removed as it is no longer used.
- **Step 5**: The dataset is molten into a long format with the subject and activity columns as IDs, which gives, for every combination of subject and activity, all the measured features and their values. This is then used to calculate the mean of every subject-activity-feature combination, which again gives a table in wide format (using `dcast`). As I wanted a long format in the end which allows to easily summarize, for example, all subject-feature or all activity-feature combinations, I melted it again using `melt`, and I also renamed the variables in the same step. 
- Lastly, the dataset is written to a txt file. 
