# writecsv

A quick & (very) dirty CSV writer for Nim designed to complement the standard library's parsecsv module.

**Warning**: Definitely buggy. Use at your own risk.

## Usage example

```nim
# type
#   CsvWriter* = object
#     headers*: seq[string]
#     rows*: seq[seq[string]]
#     separator: char
#     quote: char = '\"'

import std/parsecsv
import writecsv

block:
  var
    p: parsecsv.CsvParser
    w: writecsv.CsvWriter

  p.open("./input.csv", separator = ',', quote = '"')
  defer: p.close()

  p.readHeaderRow()
  w.headers = p.headers # Optional: headers can safely be included in the `rows` property

  while p.readRow():
    w.rows.add(p.row) # Append parsed row to `rows` property

  w.writeRows("./output.tsv", separator = '\t') # Optional: `separator` arg. Defaults to ','
```

## Changelog

### 2022-12-28
#### Removed

- After some consideration, custom quote characters have been removed to meet the [RFC 4180](https://www.rfc-editor.org/rfc/rfc4180) guidelines.

## Limitations

Custom quote characters are not supported. Quotation marks (`"`) only.

## Known Issues

- Quotation marks cannot be used within values in the input data. (Planned support)
- Newlines cannot be be used within values in the input data. (Planned support)
- Using quotation marks as separators breaks everything. (Duh!)

## Todo

### Features

- [ ] Streaming output to file
- [ ] Switch for wrapping all fields in quotation marks (think Python's `csv.QUOTE_ALL`)
- [ ] Limit separators to comma (`,`), tab (`\t`) semi-colon (`;`) or pipe (`|`)
- [ ] Error handling for quotation marks as separators
- [ ] Error handling in general

### RFC 4180 Compliance

- [ ] Line breaks within values ([Section 2, def. 6](https://www.rfc-editor.org/rfc/rfc4180#section-2))
- [ ] Quotation marks within values ([Section 2, def. 7](https://www.rfc-editor.org/rfc/rfc4180#section-2))