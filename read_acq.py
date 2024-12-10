import bioread
import matplotlib.pyplot as plt
import numpy as np

# Load the first .acq file
file_path_1 = "C:\\Users\\km615\\OneDrive\\Documents\\NORMAL .acq"
data_1 = bioread.read_file(file_path_1)
ecg_channel_1 = data_1.channels[0]  # Replace 0 with the correct index for ECG
ecg_signal_1 = ecg_channel_1.data
time_1 = ecg_channel_1.time_index  # Time array for the signal

# Load the second .acq file
file_path_2 = "C:\\Users\\km615\\OneDrive\\Documents\\STZ .acq"
data_2 = bioread.read_file(file_path_2)
ecg_channel_2 = data_2.channels[0]  # Replace 0 with the correct index for ECG
ecg_signal_2 = ecg_channel_2.data
time_2 = ecg_channel_2.time_index  # Time array for the signal

# Specify the time interval for comparison (e.g., 10–20 seconds)
start_time, end_time = 20, 30

# Extract corresponding segments
segment_1 = ecg_signal_1[(time_1 >= start_time) & (time_1 <= end_time)]
segment_2 = ecg_signal_2[(time_2 >= start_time) & (time_2 <= end_time)]

# Synchronize segment lengths if needed
min_length = min(len(segment_1), len(segment_2))
segment_1 = segment_1[:min_length]
segment_2 = segment_2[:min_length]
time_segment = time_1[(time_1 >= start_time) & (time_1 <= end_time)][:min_length]

# Plot the two segments for visual comparison
plt.figure(figsize=(12, 6))
plt.plot(time_segment, segment_1, label="ECG Signal 1", linewidth=1.5)
plt.plot(time_segment, segment_2, label="ECG Signal 2", linestyle='--', linewidth=1.5)
plt.title("Comparison of ECG Signals in 10–20s Interval")
plt.xlabel("Time (s)")
plt.ylabel("Amplitude")
plt.legend()
plt.grid(True)
plt.show()

# Quantitative comparison (e.g., correlation)
correlation = np.corrcoef(segment_1, segment_2)[0, 1]
print(f"Correlation between the two ECG segments: {correlation:.2f}")
