# TODO (Features, Tests et al.)

* If a file is not an RPM, every attempt to read anything should misreably
  fail.
* Add control logic to verify if a file exists before creating a new RPM in
  Rupture::RPM#load
* describe RPM::Lead it fails nicely when architecture is unknown -> def arch
  return @@arch_map[@archnum] || "unknown"
* Recognize all architectures
* Edge case: verify correct idenfitication of `noarch`
* Recognize all the OSes (maybe also add `osnum` method?)
* How to fail when os is not recognized?
* Document references to RPM spec docs and source code
* Document Rupture::RPM::Lead (summarize structure and purpose from rpm file
  format document)
* Return nil or "" as md5 if no signature found (this means not creating the
  signature if lead says no). Consider also this: if a signature is found and
  md5 is not present, then mandatory rules are not violated. Finally, I'm not
  sure it's so optional to include a signature; I suspect it's mandatory
  (perhaps because md5 is mandatory?).
* Document Rupture::RPM::Signature::Index::Entry class (in particular, how the
  meaning of the `count` field changes with data type
* Store#get error handling. Pass nil, out of bound address, non-numerical
  address
* Use actual size contained in the signature to calculate checksum?
* Remember that signature is not mandatory in RPM!
* It looks like size is also a form of signature, in the sense that RPM uses
  the stored value to check actual size of header + payload (or did I
  understood wrong?) -> make integrity + auth verification check everything at
  once?.
* I18N ???
* Improve Index robustness against null values of store and entries, and for
  missing tags -> decide what to return

# Roadmap

* Pick the entry type table. For each type, pick a meaningful (mandatory may be
* easy - see below) header tag (like
  name, file list, etc.) to derive a feature to be implemented. At the end,
  (almost) all types should be correctly handled
* Decide a sensible behaviour for missing mandatory tags. Then, pick all
  mandatory header tags and build a feature for them if not already covered
  with previous method.
* Decide how to handle optional tags (return nil?)
