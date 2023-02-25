# data-challenges
## Challenges
### 1. Query Optimization
A common challenge encountered when working with data related to financial entities is combining datasets that utilize different identifier schemes. For instance, a proprietary dataset from one provider might use a bespoke unique ID. While a publicly available dataset might use a standardized identifier like an alphanumeric Instrument ID. Being able to associate disparate datasets to individual financial entities using various identifiers like these in order to gain insight from them is a core function of our Data team.

Your task is to use the PostgreSQL schema and tables contained in [data.dmp](/query_optimization/data.dmp?raw=true) to summarize some (E)nvironmental, (S)ocial, (G)overnance, and Total Impact scores for fictitious entities listed on the S&P 500. Your requirements are as follows:
* Determine the most efficient method of joining the included `sp500`, `id_map`, and `esg_scores` tables
* Create a new `sp500_esg_scores` table that lists all available id, name, and score columns for the S&P 500 constituent entities
* Add a `rank` column to the new `sp500_esg_scores` table that ranks the S&P 500 constituent entities by percentile on `total_score` in ascending order
* Add a MEDIAN row to the `sp500_esg_scores` table that shows the median value for each score column across the S&P 500 constituents 
* Make sure that where S&P 500 constituent entities are missing score values they still appear in the `sp500_esg_scores` table and are ranked in the 0 percentile
* Suggest a database and ETL architecture if there were a much larger universe of companies eg. 50,000. This universe would be updated on a weekly basis and rankings would need to be recomputed upon update.

Your submission should include a new `esg_analysis.dmp` file with the database code to replicate your solution as well as a `query.sql` file containing the SQL query used to produce the `sp500_esg_scores` table.

### 2. Carbon Analytic Calculation
Use Python to implement a function that can be utilized to calculate the (strawman) Adjusted CO2 Total emissions for a company. The calculation is laid out below. mu_purch, mu_max_purch, and phi_prod could be adjusted for a given run meaning that they would be the same for each company, but can be edited in between runs.

The data is stored inside of the [included data file](/carbon_calculation/data.json?raw=true). 

Your code structure can take whatever you believe to be best (individual function, class, module, etc.). You can do it in a Jupyter notebook or directly in a .py file. Please implement the code as well as write tests with pytest or unittest for the calculation, showcasing how you would write tests for such requirements. Provide instructions with your submission for how to call your implemented function as well as how to run the tests.

![Calculation](/carbon_calculation/calculation.png?raw=true "Calculation")

* Suggest how to orchestrate updating the data and then computing this. Assume the data is saved in a PostgreSQL database.

### 3. Data QA
You are given a TestPortfolio which has 6 holdings; 5 are company instruments and 1 is a Test Fund. Complete data QA in the [spreadsheet](/data_qa/TestPortfolio_5entities1fund.xlsx) by checking the computations and filling in the cells highlighted in yellow. Those are the fields that will be displayed in the web app.

The first sheet `portfolio holdings` has the Asset Class, holding_amount, and Name of the holdings. The second sheet `Test Fund Infos` contains the carbon and financial information of the constituents of the Test Fund, which is one of the holdings. The last file `carbon` has the carbon information of the holdings of the rest of the portfolio and can be filled in to determine the overall carbon intensity and the "owned" carbon for the portfolio.

Computation definitions:

carbon
```
ownership_weight = holding_amount/enterprise_value (the % of the company "owned" in the portfolio)
portfolio_weight = holding_amount/total_portfolio_amount
total_intensity (for a company) = co2_scope_1_intensity+co2_scope_1_intensity+co2_scope_1_intensity
total_intensity (for a fund) = Fund intensity (defined below)
owned_carbon (for a company)= total_emitted*ownership_weight
owned_carbon (for a fund) = carbon owned by the fund position (you compute)

Portfolio total_intensity = sum(portfolio_weight*total_intensity for each company)

Portfolio owned_carbon = sum(owned_carbon)
```

Test Fund infos
```
fund_weight = weight of the holding in the fund
total_intensity = co2_scope_1_intensity+co2_scope_1_intensity+co2_scope_1_intensity
owned_carbon = carbon owned by the holding position in the fund (you compute)

Fund intensity = sum(fund_weight*total_intensity for each company)
Fund owned_carbon = sum(owned_carbon)
```

Check the computations and fill in the rest. What would make the test easier? What are some other cases that may be useful to test?


### Open in Colab

[![Open 'Query Optimization' In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/ginobaltazar7/esg-datachallenges/blob/main/query_optimization/YvesQO.ipynb)

[![Open 'Query Optimization' In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/ginobaltazar7/esg-datachallenges/blob/main/carbon_calculation/MockYves2.ipynb)

