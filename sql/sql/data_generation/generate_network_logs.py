import pandas as pd
import random
from datetime import datetime, timedelta

# Load the subscriber IDs from the existing CSV file
subscribers_df = pd.read_csv('subscribers_data.csv')
subscribers = subscribers_df['subscriber_id'].tolist()

# Parameters
num_records = 500000
start_date = datetime(2023, 1, 1)
end_date = datetime(2025, 11, 7)
event_types = ['call_started', 'call_ended', 'data_usage']

# Function to generate a random timestamp
def random_timestamp(start, end):
    delta = end - start
    random_days = random.randint(0, delta.days)
    random_seconds = random.randint(0, 86400)  # Seconds in a day
    return start + timedelta(days=random_days, seconds=random_seconds)

# Create the logs
logs = []
for log_id in range(1, num_records + 1):
    timestamp = random_timestamp(start_date, end_date)
    subscriber_id = random.choice(subscribers)
    event_type = random.choice(event_types)
    if event_type == 'call_ended':
        value = random.randint(1, 300)  # Call duration in seconds
    elif event_type == 'data_usage':
        value = random.randint(1, 5000)  # Data usage in MB
    else:
        value = 0  # call_started has no value
    logs.append([log_id, timestamp, subscriber_id, event_type, value])

# Create a DataFrame
df = pd.DataFrame(logs, columns=['log_id', 'timestamp', 'subscriber_id', 'event_type', 'value'])

# Save to CSV
df.to_csv('network_logs.csv', index=False)

print("Network logs generated successfully!")