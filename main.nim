import os, strutils, sequtils

proc flatten[T](arrs: seq[seq[T]]): seq[T] =
    result = @[]
    for arr in arrs:
        result &= arr

if os.paramCount() < 1:
    echo "Error: please specify lines to wrap."
    quit(1)

let title = stdin.readLine.split(',')
let col = title.len

var rows: seq[seq[string]] = @[]
for line in stdin.lines:
    rows &= line.split(',')

let wrapLine = os.paramStr(1).parseInt()
let wholecol = (rows.len + wrapLine - 1) div wrapLine
var amari = rows.len mod wrapLine
if amari == 0: amari = rows.len

echo r"\begin{tabular}{|" & 'r'.repeat(wholecol * col) & r"|}"
echo r"\hline"
echo title.repeat(wholecol).flatten.map(proc (x: string): string = "\\thn{" & x & "}").join(" & ") & " \\\\"
echo("\\hhline{|" & "=".repeat(col*wholecol) & "|}")

for i in 0..<wrapLine:
    var tmparray: seq[string] = @[]
    for j in 0..<(wholecol-1):
        tmparray &= rows[j*wrapLine + i]
    if i < amari:
        tmparray &= rows[(wholecol-1)*wrapLine + i]
    else:
        tmparray &= @[""].repeat(col).flatten
    echo((tmparray.map do (x: string) -> string:
        if x != "": "$" & x & "$" else: "\\mbox{}"
        ).join(" & ") & " \\\\")

echo r"\hline"
echo r"\end{tabular}"
