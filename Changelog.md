# Changelog

* Other fields being read from header structure:
  * version number
  * release string
  * target os name
  * target architecture
  * license name
  * payload format
  * payload compressor
  * payload flags
  * build host
  * build time
  * packager info
  * vendor info
  * package URL
  * package source RPM file name
  * package group name
  * package summary
  * package description
* More information given about installed files: file size

## 0.0.2

* First pieces of metadata fetched from RPM header structure:
  * package name
  * list of installed files
  * installed package size
* Major design improvements

## 0.0.1

* Read information from RPM lead section
* Read MD5 checksum information from RPM signature structure
* Perform basic (non-crypto) package integrity verification
