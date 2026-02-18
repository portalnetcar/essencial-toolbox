## OCR Linux

## Version with tesseract (limited performance)

1. Install Required Tools
- First, ensure that Tesseract OCR is installed on your system:

```Shel
sudo apt update
sudo apt install tesseract-ocr
```

- You may also want to install additional language packs if needed:

```Shel
sudo apt install tesseract-ocr-eng  # For English
```

2. Create the OCR Script
- Next, create a script that will handle the OCR processing when you right-click on an image file.

```Shell
mkdir -p ~/.local/share/nautilus/scripts/
nano ~/.local/share/nautilus/scripts/OCR
```

- Paste the following content into the file:

```Shell
#!/bin/bash

# Check if a file is selected
if [ -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
    zenity --error --text="No file selected!"
    exit 1
fi

# Loop through selected files
for INPUT_FILE in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    # Get the output directory and base name
    OUTPUT_DIR=$(dirname "$INPUT_FILE")
    BASE_NAME=$(basename "$INPUT_FILE" | cut -d. -f1)

    # Run Tesseract OCR on the image
    tesseract "$INPUT_FILE" "$OUTPUT_DIR/$BASE_NAME"

    # Notify the user that OCR is complete
    zenity --info --text="OCR Complete! Text saved to $OUTPUT_DIR/$BASE_NAME.txt"
done

```

- Make the script executable:

```Shell
chmod +x ~/.local/share/nautilus/scripts/OCR
```

- Note : If you don't have zenity installed, you can install it with: 

```Shell
sudo apt install zenity

```

- Restart Nautilus

```Shell
nautilus -q

```

- Test the OCR Option
- Now, when you right-click on an image file (e.g., PNG, JPEG, JPG), you should see a new option under the "Scripts" submenu called "OCR" .

- Right-click on an image file.
- Navigate to "Scripts" > "OCR" .
- The script will run Tesseract OCR on the image, and the extracted text will be saved in the same directory as the image file with a .txt extension.
- A notification will pop up to inform you that the OCR process is complete.


## Version with ollama (better performance)
- Create the script:

```Shell
nano ~/.local/share/nautilus/scripts/Ollama-OCR
chmod +x ~/.local/share/nautilus/scripts/Ollama-OCR
```

- With this code:

```Shell
#!/bin/bash
# Revised Nautilus OCR Script for Ollama Vision:
#  - Calls the API with the Base64-encoded image.
#  - Extracts only the "content" fields from the JSON stream using jq.
#  - Saves the extracted OCR text to a file.
#
# Ensure jq is installed: sudo apt install jq

# Use arguments if provided (Nautilus may pass file paths as arguments)
if [ "$#" -gt 0 ]; then
    FILE_LIST=("$@")
elif [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
    # Read newline-separated list from environment variable into an array
    IFS=$'\n' read -r -d '' -a FILE_LIST <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
else
    zenity --error --text="No file selected!"
    exit 1
fi

for INPUT_FILE in "${FILE_LIST[@]}"; do
    # Strip "file://" prefix if present
    if [[ "$INPUT_FILE" =~ ^file:// ]]; then
        INPUT_FILE="${INPUT_FILE#file://}"
    fi
    # Remove stray newline characters
    INPUT_FILE=$(echo "$INPUT_FILE" | tr -d '\n')
    
    if [ ! -f "$INPUT_FILE" ]; then
        zenity --error --text="File not found:\n$INPUT_FILE"
        continue
    fi

    # Determine output directory and file base name
    OUTPUT_DIR=$(dirname "$INPUT_FILE")
    FILE_NAME=$(basename "$INPUT_FILE")
    BASE_NAME="${FILE_NAME%.*}"  # removes extension

    # Encode the image file to a single-line Base64 string
    IMAGE_BASE64=$(base64 -w 0 "$INPUT_FILE")
    if [ -z "$IMAGE_BASE64" ]; then
        zenity --error --text="Failed to encode file:\n$INPUT_FILE"
        continue
    fi

    # Create a temporary file for the API response
    TMPFILE=$(mktemp /tmp/ollama_api.XXXXXX)
    if [ -z "$TMPFILE" ]; then
        zenity --error --text="Failed to create temporary file."
        continue
    fi

    # Build the JSON payload
    read -r -d '' PAYLOAD <<EOF
{
  "model": "llama3.2-vision:11b",
  "messages": [
    {
      "role": "user",
      "content": "What text is in this image?",
      "images": ["$IMAGE_BASE64"]
    }
  ]
}
EOF

    # Call the Ollama Vision API
    HTTP_CODE=$(curl -s -o "$TMPFILE" -w "%{http_code}" \
      -H "Content-Type: application/json" \
      -d "$PAYLOAD" \
      http://localhost:11434/api/chat)

    if [ "$HTTP_CODE" -ne 200 ]; then
        ERROR_MSG=$(cat "$TMPFILE")
        rm "$TMPFILE"
        zenity --error --width=400 --text="Ollama API error (HTTP $HTTP_CODE):\n$ERROR_MSG"
        continue
    fi

    RESPONSE=$(cat "$TMPFILE")
    rm "$TMPFILE"

    # Parse the JSON stream to extract only the "content" fields and remove newlines.
    # This will join all pieces of text into one continuous line.
    EXTRACTED_TEXT=$(echo "$RESPONSE" | jq -r '.message.content' | tr -d '\n')

    # Save the extracted text to a .txt file next to the original image.
    OUTPUT_FILE="$OUTPUT_DIR/$BASE_NAME.txt"
    if ! echo "$EXTRACTED_TEXT" > "$OUTPUT_FILE"; then
        zenity --error --text="Failed to save OCR text to:\n$OUTPUT_FILE"
        continue
    fi

    zenity --info --width=400 --text="OCR Complete!\nText saved to:\n$OUTPUT_FILE"
done

```

- Restart Nautilus

```Shell
nautilus -q

```

## Explanation
- Parsing the JSON Stream :
- The jq command is used to parse the JSON and extract the "content" field from each line.
- The -r flag ensures that the output is raw text (not quoted).
```bash
jq -r '.message.content'
```
- Concatenating the Text :
- The tr -d '\n' command removes newline characters, ensuring that all the text is concatenated into a single string.
- To install jq:

```bash
sudo apt install jq
```

## Attention
- Ollama serve must be running