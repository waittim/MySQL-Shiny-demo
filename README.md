# MySQL-Shiny-demo

## Introduction for files

- **10_data_prep.Rmd:** This file is used to preprocess the original data and add the primary key.
- **20_loan_db.sql:** This file is used to build a database, load data and add trigger and other content.
- **30_shiny_app.Rmd:** This file is used to create an interactive shiny dashboard.

## Guidelines for use

1. Run *10_data_prep.Rmd* in *R studio* to obtain a data file in csv format (about 234.9MB).
2. Run *20_loan_db.sql* in MySQL to establish the database backend.
3. Run *30_shiny_app.Rmd* in *R studio* to get an interactive dashboard. Note that you need to change localhost and port to local information.

![](https://github.com/waittim/MySQL-Shiny-demo/blob/master/dashboard_screenshot.png)
