# writecsv

A quick & (very) dirty CSV writer for Nim designed to complement the standard library's parsecsv module.

**Warning**: Experimental. Use at your own risk.

## Usage example

```nim
# type
#   CsvRow = seq[string]
#
#   CsvWriter* = object
#     headers*: CsvRow
#     rows*: seq[CsvRow]
#     separator, quote: char

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

## Limitations

Custom quote characters are not supported. Quotation marks (`"`) only.

## Known Issues

- Newlines cannot be be used within values in the input data. (Planned support)

## Todo

### Features

- [ ] Streaming output to file
- [ ] Switch for wrapping all fields in quotation marks (think Python's `csv.QUOTE_ALL`)
- [ ] Limit separators to comma (`,`), tab (`\t`), semi-colon (`;`), or pipe (`|`)
- [x] Error handling for quotation marks as separators
- [ ] Error handling in general

### RFC 4180 Compliance

- [ ] Line breaks within values ([Section 2, def. 6](https://www.rfc-editor.org/rfc/rfc4180#section-2))
- [x] Quotation marks within values ([Section 2, def. 7](https://www.rfc-editor.org/rfc/rfc4180#section-2))

