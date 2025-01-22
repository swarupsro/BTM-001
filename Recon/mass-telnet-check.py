import socket
import csv

# Function to check telnet connectivity using socket
def check_telnet(host, port):
    try:
        with socket.create_connection((host, port), timeout=5):
            return f"Port {port} on {host} is open."
    except socket.timeout:
        return f"Port {port} on {host} timed out."
    except (socket.gaierror, ConnectionRefusedError):
        return f"Port {port} on {host} is closed or unreachable."
    except Exception as e:
        return f"Port {port} on {host} encountered an error: {str(e)}"

# Read the CSV file and perform checks
def telnet_check_from_csv(file_path):
    results = []
    try:
        with open(file_path, 'r') as file:
            reader = csv.DictReader(file)
            for row in reader:
                host = row.get('Host', '').strip()
                port = row.get('Port', '').strip()
                if host and port.isdigit():
                    result = check_telnet(host, int(port))
                    results.append(result)
                else:
                    results.append(f"Invalid entry in CSV: {row}")
    except Exception as e:
        results.append(f"Error processing the file: {str(e)}")
    return results

# Main function to run the script
if __name__ == "__main__":
    file_path = '/mnt/data/mass-telnet.csv'  # Update with your uploaded file path
    output = telnet_check_from_csv(file_path)
    for line in output:
        print(line)

## the csv file must have two column (host, port)