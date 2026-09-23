PulseCart — Analysis README

How to Rerun
1.Open the project in VS Code.
2.Activate the virtual environment:
.\venv\Scripts\Activate.ps1
3.Open analysis.ipynb.
4.Select the project venv Python kernel.
5.Run the notebook cells from top to bottom.
6.Ensure the datasets are under data/csv/.

Main datasets:
1.customers.csv
2.products.csv
3.orders.csv
4.support_tickets.csv
5.daily_operations.csv
6.image_labels.csv

Install required packages if needed:
pip install pandas numpy matplotlib seaborn scikit-learn scipy tensorflow pillow

Business Questions

1. Who is leaving, and is any city or plan actually different from the rest?
PulseCart has 143 churned customers out of 862 (16.59%).Houston has a churn rate of 30.16%, compared with 16.59% overall.The Free plan has 21.03% churn, compared with 11.61% for Plus and 10.85% for Pro.Therefore, Houston and the Free plan show noticeably higher churn in this dataset.

2. Which products or categories are driving returns? Is that difference large enough to act on?
There are 343 returned orders out of 3,388 orders (10.12%).The Kitchen category has the highest return rate at 23.75%.The MealPrep Set (28.18%), Blender Nano (23.05%), and BrewGo Travel Mug (20.49%) have particularly high return rates.The difference from the overall 10.12% return rate is large enough to justify investigating Kitchen products.

3. Can you predict churn well enough to build a short outreach list — without leaking the future into the model?
A supervised model was built using recency, frequency, net spend, return rate, ticket count, plan, and city.last_active_date was not used directly because it is closely related to the churn label and could cause data leakage.The data was split into training and testing sets so that future information was not used to build the training features.The model was evaluated using precision/recall or ROC-AUC, making it suitable for creating a targeted outreach list.

4. Did daily orders change after 1 June 2026, or is that just noise?
Daily orders were analyzed using a time-based split, with 1 June 2026 used as the cutoff.A naive/moving-average baseline was used to compare order levels over time.The pre- and post-June order levels should be compared with normal daily variation.A level shift should only be reported if the change is clearly larger than the usual day-to-day variation.

5. What should PulseCart do in the next 30 days? Three actions, each tied to evidence.
1. Investigate Houston churn: Houston has 30.16% churn, compared with 16.59% overall.
2. Investigate Kitchen returns: Kitchen has a 23.75% return rate, compared with 10.12% overall.
3. Run targeted churn outreach: Use the leakage-safe churn model to identify high-risk customers and prioritize outreach based on the model's predictions and errors.

Limitations

The analysis uses only the provided datasets and their available time period.
Observed relationships do not necessarily imply causation.
The churn model identifies high-risk customers but cannot guarantee churn.
The image classification model is intentionally small and should be treated as a baseline.
Time-series conclusions around June 1 should account for normal daily variation and other events.
Data-quality issues such as dirty contact information, duplicates, and orphan records were flagged and handled during cleaning.
