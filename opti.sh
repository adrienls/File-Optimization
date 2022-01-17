#!/bin/sh

# Exit when any command fails
set -e

output_name(){
  # output_name requires 1 argument
  # $1 is the file name
  # Get compressed output name by adding '-min' at the end of the original name
  baseName="$(echo "$1" | awk -F '.' '{print $1}')"
  extension="$(echo "$1" | awk -F '.' '{print $2}')"
  echo "$baseName-min.$extension"
}

file_size(){
  # file_size requires 1 argument
  # $1 is the file name
  du -h "$1" | awk '{print $1}'
}

pdf_process(){
  # pdf_process requires 1 argument
  # $1 is the file name
  # Get file info
  currentPdfSize="$(du "$1" | awk '{print $1}')"
  # Get compressed output name
  outputName="$(output_name "$1")"

  # Compress PDF
  gs -q -dSAFER -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile="$outputName" "$1"

  # Check if new file is smaller than original one
  if [ "$currentPdfSize" -le "$(du "$outputName" | awk '{print $1}')" ]; then
    # Remove the new file if original one was smaller
    rm "$outputName"
  else
    # Remove the original file if the new one is smaller
    rm "$1" && mv "$outputName" "$1"
  fi
}

jpeg_process(){
  # jpeg_process requires 1 argument
  # $1 is the file name
  jpegoptim -q --preserve --all-progressive "$1"
}

compress_file(){
  # post_process requires 3 arguments
  # $1 is the file name
  fileName="$1"
  # Find file type
  type="$(file -b "$fileName" | awk -F ',' '{print $1}')"

  # Check valid format
  if [ "$type" = "PDF document" ] || [ "$type" = "PNG image data" ] || [ "$type" = "JPEG image data" ]; then
    # Find file size
    originalFileSize="$(file_size "$fileName")"

    # Continue compressing until the file size stops being smaller
    while :
    do
      # Get info on current file
      currentFileSize="$(file_size "$fileName")"

      # Process the file according to its format
      # Compress PDF
      if [ "$type" = "PDF document" ]; then
        pdf_process "$fileName"

      # Compress PNG
      elif [ "$type" = "PNG image data" ]; then
        optipng -quiet -preserve "$fileName"

      # Compress JPEG
      elif [ "$type" = "JPEG image data" ]; then
        jpeg_process "$fileName"
      fi

      # If previous size is the same as the current size stop compressing
      if [ "$currentFileSize" = "$(file_size "$fileName")" ]; then
        break
      fi
    done

    # Result
    chmod 600 "$fileName"
    echo "'$fileName' original size was $originalFileSize. Is is now $(file_size "$fileName")."

  else
    echo "File type '$type' of '$fileName' is not supported."
  fi
}

help(){
   # Display Help
   echo "Opti is a small shell script to optimize files in place. Supported format are PDF, JPG and PNG."
   echo
   echo "* You must specify the target file or directory to be optimized."
   echo "* Valid files that cannot be optimized by this program are normally left untouched, their size will not increase."
   echo "* For PNG and JPG files, date exif are preserved by the optimization. However, creation date may vary depending on the OS."
   echo "* Date exif are not kept for PDF files."
   echo "* If you specify a directory, each subdirectory will be tested recursively and each compatible file will be optimized."
   echo
   echo "More information here: https://github.com/adrienls/File-Optimization"
   echo
   echo "Syntax: opti [-h] [file|directory]"
   echo "Options:"
   echo "   -h    Print this help."
   echo
}

main(){
  # Check if file exists and is a regular file
  if [ -f "$1" ]; then
    compress_file "$1"
  # Check if file exists and is a directory
  elif [ -d "$1" ]; then
    # List all files in directory and subdirectories
    fileList="$(find "$1" -type f -not -empty -print)"

    # Change IFS to check files with spaces in their name
    IFS=$(printf '\n.')
    IFS=${IFS%.}

    for file in $fileList
    do
      compress_file "$file"
    done
  else
    help
  fi
}

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":h" option
do
  case $option in
    h) help
      exit 0;;
    \?) echo "Unknown option: -$option"
      echo "Please refer to the correct usage thanks to the \"-h\" option."
      exit 1;;
   esac
done
shift $((OPTIND - 1))

main "$1"

exit 0
