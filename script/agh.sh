#!/bin/bash
# This script for custom download the latest packages version from snapshots/stable repo's url and github releases.
# Put file name and url base.

# Download packages from official snapshots, stable repo's urls and custom repo's.
{
    files1=(
        "luci-app-adguardhome|https://api.github.com/repos/kongfl888/luci-app-adguardhome/releases/latest"
    )
    echo "#########################################"
    echo "Downloading packages from github releases"
    echo "#########################################"
    echo "#"
    for entry in "${files1[@]}"; do
    IFS="|" read -r filename1 base_url <<< "$entry"
    echo "Processing file: $filename1"
    file_urls=$(curl -s "$base_url" | grep "browser_download_url" | grep -oE "https.*/${filename1}_[_0-9a-zA-Z\._~-]*\.ipk" | sort -V | tail -n 1)
    for file_url in $file_urls; do
        if [ ! -z "$file_url" ]; then
            echo "Downloading $(basename "$file_url")"
            echo "from $file_url"
            curl -Lo "packages/$(basename "$file_url")" "$file_url"
            echo "Packages [$filename1] downloaded successfully!."
            echo "#"
            break
        else
            echo "Failed to retrieve packages [$filename1] because it's different from $file_url. Retrying before exit..."
        fi
    done
done

}