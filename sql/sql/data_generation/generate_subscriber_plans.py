import pandas as pd
import random
from datetime import datetime, timedelta

# Load the subscribers and plans data
subscribers_df = pd.read_csv('subscribers_data.csv')
plans_df = pd.read_csv('plans.csv')

# Get lists of subscriber_ids and plan_ids
subscriber_ids = subscribers_df['subscriber_id'].tolist()
plan_ids = plans_df['plan_id'].tolist()

# Parameters
num_records = 350000

# Function to generate a random start date within a given range
def random_start_date():
    start_date = datetime(2023, 1, 1)
    end_date = datetime(2025, 11, 7)
    delta = end_date - start_date
    random_days = random.randint(0, delta.days)
    return start_date + timedelta(days=random_days)

# Generate the subscriber plans
subscriber_plans = []
for _ in range(num_records):
    subscriber_id = random.choice(subscriber_ids)
    plan_id = random.choice(plan_ids)
    start_date = random_start_date()
    end_date = start_date + timedelta(days=30)  # Set end_date to be 30 days after start_date

    subscriber_plans.append([subscriber_id, plan_id, start_date.strftime('%Y-%m-%d'), end_date.strftime('%Y-%m-%d')])

# Create a DataFrame
subscriber_plans_df = pd.DataFrame(subscriber_plans, columns=['subscriber_id', 'plan_id', 'start_date', 'end_date'])

# Save to CSV
subscriber_plans_df.to_csv('subscriber_plans.csv', index=False)

print("Subscriber Plans table generated successfully!")