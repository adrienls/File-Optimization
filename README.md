# File-Optimization

## Opti
Opti is a small shell script to optimize files in place. Supported format are PDF, JPG and PNG.

## Instructions
* You must specify the target file or directory to be optimized.
* Valid files that cannot be optimized by this program are normally left untouched, their size will not increase.
* For PNG and JPG files, date exif are preserved by the optimization. However, creation date may vary depending on the OS.
* Date exif are not kept for PDF files.
* If you specify a directory, each subdirectory will be tested recursively and each compatible file will be optimized.
* When optimizing files, opti tries to apply lossless compression. Therefore, pti does not significantly change a file quality.

## Install
Installation script [install.sh](install.sh) will install needed dependencies, download [opti](opti.sh) shell script, add script to path and give the necessary rights to the script.
```sh
curl -O https://raw.githubusercontent.com/adrienls/File-Optimization/main/install.sh | sh
```

## Uninstall
```sh
rm -f "/home/$USER/.local/bin/opti"
```

## Dependencies
* [Ghostscript](https://www.ghostscript.com/)
* [OptiPNG](http://optipng.sourceforge.net/)
* [Jpegoptim](https://github.com/tjko/jpegoptim)

## Usage

```sh
# pdf, png or jpg file
opti filename.pdf

# Directory
opti directory-to-compress/
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Author
* [adrlsx](https://github.com/adrlsx)

## License
This project is licensed under the GNU AGPLv3 License - see the [LICENSE.md](LICENSE) file for details.

License chosen thanks to [choosealicense.com](https://choosealicense.com/).

