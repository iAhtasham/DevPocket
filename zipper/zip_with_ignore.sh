#!/bin/bash

# Convert incoming path to Unix style for Git Bash
RAW_PATH="$1"
TARGET_DIR=$(cygpath -u "$RAW_PATH")

if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Target directory not found: $TARGET_DIR"
    read -p "Press Enter to exit..."
    exit 1
fi

echo "📂 Target directory: $TARGET_DIR"

IGNORE_FILE="$TARGET_DIR/.ignore"
IGNORES=("node_modules" "bin")

# Read ignores from .ignore file if it exists
if [ -f "$IGNORE_FILE" ]; then
    echo "📄 Reading ignore file..."
    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        IGNORES+=("$line")
    done < "$IGNORE_FILE"
fi

# Create temp exclude file
EXCLUDE_FILE=$(mktemp)
for pattern in "${IGNORES[@]}"; do
    echo "$pattern" >> "$EXCLUDE_FILE"
done

PARENT_DIR=$(dirname "$TARGET_DIR")
FOLDER_NAME=$(basename "$TARGET_DIR")
OUTPUT_ZIP="$PARENT_DIR/$FOLDER_NAME.zip"

echo "🛠 Creating ZIP: $OUTPUT_ZIP"
echo "🚫 Ignoring patterns:"
cat "$EXCLUDE_FILE"

# Run zip from parent directory
(
    cd "$PARENT_DIR" || exit 1
    if ! command -v zip &> /dev/null; then
        echo "❌ 'zip' command not found. Install it in Git Bash."
        read -p "Press Enter to exit..."
        exit 1
    fi
    zip -r "$OUTPUT_ZIP" "$FOLDER_NAME" -x@"$EXCLUDE_FILE"
)

rm -f "$EXCLUDE_FILE"
echo "✅ Done! Created: $OUTPUT_ZIP"
read -p "Press Enter to exit..."
