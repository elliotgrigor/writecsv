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
#     quote: char

import std/parsecsv
import writecsv # assuming writecsv.nim is a sibling file

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

  # Optional: `separator` & `quote` args. Defaults to ',' & '\"', respectfully
  w.writeRows("./output.csv", separator = '\t', quote = '\"')
```

## Limitations

Must escape any string-identifying character for the quote argument. `\"` `\'`

## Known Issues

There's a scenario where, in the CSV input, if one or more separator characters exist in a value *and* it contains a quote character utilised by the CSV writer as part of the value, it will double the quote characters in the output.

#### An example speaks a thousand words.

```
# input.csv (quotes as part of the value)
id,name,quote
1,'Smith, John','"Foobar"'
2,'Doe, Jane','"Hello, World!"'
3,'Bloggs, Joe','"Quick brown fox"'
```

Parsing the above input using apostrophes `'` as quote characters and commas `,` as separators will result in the following CSV writer output (if writing using the same separator `,` and value character `"`).

```
# output.csv
id,name,quote
1,"Smith, John","Foobar"          <-- not equivalent
2,"Doe, Jane",""Hello, World!""   <-- broken
3,"Bloggs, Joe","Quick brown fox" <-- not equivalent
```
