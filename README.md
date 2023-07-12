# Nuclear Power Plant Geo Data Analysis

[Nuclear Power Plants](https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Kerncentrale_Doel_in_werking.jpg/260px-Kerncentrale_Doel_in_werking.jpg)

This repository contains a data analysis project focused on Nuclear Power Plant Geo Data. The project utilizes data warehousing and OLAP techniques using Python and MySQL. The analysis is conducted on a dataset obtained from [Kaggle](https://www.kaggle.com/datasets/marchman/geo-nuclear-data), which is licensed under the Open Database License and the Database Contents License.

## Project Structure

The repository is organized into the following folders:

1. **Dataset**: Contains the dataset in JSON, CSV, and MySQL formats. For detailed information about the tables structure and data sources, please refer to the [Dataset README.md](1. Dataset/README.md).

2. **Preprocessing**: Includes the necessary scripts and SQL codes for data preprocessing. Here are the files within this folder:

   - `nuclear.sql`: SQL code to load the data onto a MySQL database. This script should be executed first.
   - `continents.sql`: SQL code to add a new table called "continents" to the database.
   - `preprocessing_continents.py`: Python program that updates every row in the "countries" table with a respective continent code, linking to the "continents" table using the `pycountry_convert` library.

3. **Data Warehousing & OLAP**: Contains the files related to data warehousing and OLAP operations. The folder includes:

   - `structure.sql`: Data warehouse schema using a snowflake schema model.
   - `data.sql`: SQL code to load data from the original database onto the data warehouse.
   - `olap.sql`: SQL commands to perform OLAP operations on the data warehouse.

4. **Report and Presentation**: Includes the final report and presentation slides for the project. The files within this folder are:

   - `Report.pdf`: The comprehensive report summarizing the project objectives, methodologies, findings, and conclusions.
   - `Slides.pdf`: The presentation slides highlighting the key aspects of the project.

## Credits

I would like to express my gratitude to [Ts. Dr Anbuselvan Sangodiah](https://scholar.google.com/citations?user=KmTXLTIAAAAJ&hl=en) for providing valuable support and guidance throughout the project.

Please refer to the respective folders for more detailed information on each component of the project. Feel free to explore and provide feedback or suggestions.
