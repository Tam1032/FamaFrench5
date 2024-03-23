# Forecasting rate of returns based on Fama-French five-factor model
Fama-French Five-factor is an effective economic model for explaining the relationships between rate of returns and market risks. 
In this project, we used the Fama-French five-factor model to predict the rate of returns using the stock market data in the US between July 1963 and April 2022.
Models specialized in time series forecasting, including ARIMA and ARMA-GARCH, are applied to predict future values for the rates of return.
The results conclude that hybrid models like dynamic regression, a combination of linear regression and ARIMA process, could be a promising approach to improve the forecasting accuracy compared to sole autoregression approach.
We also conduct statiscal hypothesis testing to evaluate the usefulness of some input features like the rolling window size and the HML feature to the Fama French five-factor.

This project used R and Python programming languages. You can access the data we used from [here](https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library/f-f_5_factors_2x3.html). The code for forecasting models are placed in the Code folder.
