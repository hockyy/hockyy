import requests
import socket
import time

# The login URL and hostname
login_url = "https://wificonnect.innocellhk.org:8443/login"
hostname = "wificonnect.innocellhk.org"

# The login payload/data
payload = {
    "username": "hocky.yudhiono@.com",
    "password": "",
    "RedirectUrl": "",
    "anonymous": "DISABLE",
    "anonymousurl": "",
    "accesscode": "",
    "accesscode1": "DISABLE",
    "checkbox1": "on",
    "checkbox": "on"
}

# Headers to mimic a browser request
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
}

def get_ip_address(hostname):
    try:
        print(f"Resolving hostname {hostname}...")
        ip_address = socket.gethostbyname(hostname)
        print(f"IP address for {hostname} is {ip_address}")
        return ip_address
    except socket.gaierror as e:
        print(f"Failed to resolve hostname {hostname}: {e}")
        return None

def perform_login():
    try:
        # Get the IP address first
        ip = get_ip_address(hostname)
        if ip:
            print(f"Using IP address: {ip}")
            # You can use the IP directly in the URL if needed
            # ip_url = f"https://{ip}:8443/login"
        
        # Send the POST request
        print("Sending login request...")
        response = requests.post(login_url, data=payload, headers=headers, verify=False)
        
        # Check if the request was successful
        if response.status_code == 200:
            print("Login request sent successfully (Status code: 200)")
            print(f"Response length: {len(response.text)} characters")
            
            # Check for common indicators of successful login
            if "success" in response.text.lower() or "welcome" in response.text.lower():
                print("Login appears to be successful!")
            else:
                print("Request completed, but login success couldn't be confirmed.")
                # You could add more detailed analysis here
                if "logged" in response.text.lower():
                    print("Found 'logged' in response, might indicate success")
        else:
            print(f"Failed to login. Status code: {response.status_code}")
            print(f"Response: {response.text}")
    
    except requests.exceptions.RequestException as e:
        print(f"Error sending request: {e}")

def check_internet_connection():
    """Check if we can reach a common internet site"""
    return False
    try:
        # Try to connect to Google's DNS
        socket.create_connection(("8.8.8.8", 53), timeout=3)
        return True
    except OSError:
        return False

if __name__ == "__main__":
    # Suppress SSL certificate verification warnings
    import urllib3
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    
    # Check if we need to login (no internet connection)
    if not check_internet_connection():
        print("No internet connection detected. Attempting login...")
        # Perform the login
        perform_login()
        
        # Wait a bit and check if we have internet now
        time.sleep(5)
        if check_internet_connection():
            print("Internet connection is now available!")
        else:
            print("Still no internet connection after login attempt.")
    else:
        print("Internet connection already available. No need to login.")