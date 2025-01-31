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

    # Encode the image file to Base64
    IMAGE_BASE64=$(base64 -w 0 "$INPUT_FILE")

    # Run Ollama Vision on the image
    OLLAMA_RETURN=$(curl -s http://localhost:11434/api/chat -d '{
        "model": "llama3.2-vision:11b",
        "messages": [
            {
                "role": "user",
                "content": "What text is in this image?",
                "images": ["'"$IMAGE_BASE64"'"]
            }
        ]
    }')

    # Save the response to a text file
    echo "$OLLAMA_RETURN" > "$OUTPUT_DIR/$BASE_NAME.txt"

    # Notify the user that OCR is complete
    zenity --info --text="OCR Complete! Text saved to $OUTPUT_DIR/$BASE_NAME.txt"
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