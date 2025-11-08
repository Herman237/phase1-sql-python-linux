import pandas as pd

# Define the plans
plans = [
    {"plan_id": 1, "plan_name": "Basic", "monthly_fee": 5000, "data_limit": 1000},
    {"plan_id": 2, "plan_name": "Premium", "monthly_fee": 10000, "data_limit": 5000},
    {"plan_id": 3, "plan_name": "Unlimited", "monthly_fee": 20000, "data_limit": None},
    {"plan_id": 4, "plan_name": "Night Plan", "monthly_fee": 3000, "data_limit": 2000},
    {"plan_id": 5, "plan_name": "Daily Plan", "monthly_fee": 100, "data_limit": 100},
    {"plan_id": 6, "plan_name": "Social Media", "monthly_fee": 1500, "data_limit": 500},
    {"plan_id": 7, "plan_name": "YouTube", "monthly_fee": 2000, "data_limit": 2000},
    {"plan_id": 8, "plan_name": "Family Plan", "monthly_fee": 15000, "data_limit": 10000},
    {"plan_id": 9, "plan_name": "Student Plan", "monthly_fee": 4000, "data_limit": 3000},
    {"plan_id": 10, "plan_name": "Business Plan", "monthly_fee": 25000, "data_limit": 20000}
]

# Create a DataFrame
plans_df = pd.DataFrame(plans)

# Save to CSV
plans_df.to_csv('plans.csv', index=False)

print("Plans table generated successfully!")