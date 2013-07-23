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
