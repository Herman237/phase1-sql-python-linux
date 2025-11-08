import pandas as pd
import random

# Define the list of Cameroon regions
cameroon_regions = [
    "Center", "North", "North West", "South West", "West",
    "South", "Adamawa", "Far North", "Littoral", "East"
]

# Function to generate random age with a higher proportion between 18 and 50
def generate_age():
    if random.random() < 0.75:  # 75% chance of being in the 18-50 range
        return random.randint(18, 50)
    else:
        return random.randint(51, 80)

# Generate subscriber data
num_subscribers = 500000
subscribers = {
    "subscriber_id": range(1, num_subscribers + 1),
    "name": [f"Subscriber {i}" for i in range(1, num_subscribers + 1)],
    "age": [generate_age() for _ in range(num_subscribers)],
    "gender": [random.choice(['male', 'female']) for _ in range(num_subscribers)],
    "region": [random.choice(cameroon_regions) for _ in range(num_subscribers)]
}

# Create a DataFrame
subscribers_df = pd.DataFrame(subscribers)

# Save to CSV
subscribers_df.to_csv('subscribers_data.csv', index=False)

print("Subscribers data generated successfully!")