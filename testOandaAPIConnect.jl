using HTTP, JSON, DotEnv

# Load environment variables
env_overlay = DotEnv.config()

# Manually merge the overlay into the global ENV
for (k, v) in env_overlay
    ENV[k] = v
end

# Retrieve environment variables
account_id = ENV["OANDA_ACCOUNT_ID"]
access_token = ENV["OANDA_ACCESS_TOKEN"]

# Define the API URL
url = "https://api-fxpractice.oanda.com/v3/accounts/$(account_id)/instruments/"

# Setup the headers for the HTTP request
headers = [
    "Content-Type" => "application/json",
    "Authorization" => "Bearer $(access_token)"
]

# Make a GET request to OandaAPI
response = HTTP.get(url, headers)

# Initialize an empty array for the display names
display_names = String[]

# Handling OandaAPI response
if HTTP.status(response) == 200
    println("Successfully connected to OandaAPI")
    
    # Parse the JSON response
    instruments = JSON.parse(String(response.body))
    
    # Check if the 'instruments' key is in the parsed data
    if haskey(instruments, "instruments")
        # Iterate over the instruments and print them
        for instrument in instruments["instruments"]
            #println(instrument)
            if haskey(instrument, "displayName")
                push!(display_names, instrument["displayName"])
            end
        end
    else
        println("No instruments found in the response.")
    end
else
    println("Failed to connect to Oanda")
end

# Now, display_names contains all the display names from the instruments
# Print 12 display names per line
for idx in eachindex(display_names)
    print(display_names[idx], " ")
    if idx % 12 == 0
        println()  # Newline after every 12th name
    end
end

# To handle the case where the number of instruments is not a multiple of 12,
# ensure we print a newline character at the end if needed.
if length(display_names) % 12 != 0
    println()
end
