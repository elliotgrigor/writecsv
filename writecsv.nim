import std/strutils

type
  CsvWriter* = object
    headers*: seq[string]
    rows*: seq[seq[string]]
    separator: char
    quote: char

proc escapeHeaders(self: var CsvWriter) =
  #[ Headers don't need to be set.
     Can be part of the `rows` sequence and still work ]#
  for i, header in self.headers:
    if header.contains(self.separator):
      self.headers[i] = self.quote & header & self.quote

proc escapeRow(self: CsvWriter, row: seq[string]): seq[string] =
  result = row

  for i, val in result:
    if val.contains(self.separator):
      result[i] = self.quote & val & self.quote

proc getLineEnding(self: CsvWriter): string =
  case hostOS:
    of "windows":
      result = "\r\n"
    of "macosx":
      result = "\r"
    else:
      result = "\n"

proc writeRows*(self: var CsvWriter, filePath: string,
                separator: char = ',', quote: char = '\"') =
  #[ Generate the full file contents in a string, then dump to file ]#
  self.separator = separator
  self.quote = quote

  var fileContent: string

  # Only format headers if they exist
  if self.headers.len > 0:
    # Surround in `quote` any value which includes a `separator`
    self.escapeHeaders()

    # Append header row string + newline (based on OS)
    fileContent &= strutils.join(self.headers, $self.separator)
    fileContent &= self.getLineEnding()

  for i, row in self.rows:
    # Same process as escapeHeaders, but for rows instead
    let escapedRow = self.escapeRow(row)
    # Append data row string
    fileContent &= strutils.join(escapedRow, $self.separator)

    # Avoid trailing newline
    if i < self.rows.high:
      # Append newline (based on OS) after data row
      fileContent &= self.getLineEnding()

  writeFile(filePath, fileContent)