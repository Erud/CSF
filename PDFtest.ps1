$lib="C:\Users\erudakov\Documents\PS\Itext7.7.1.14\itext.kernel.dll"
$file = & 'C:\Users\erudakov\Documents\Document(1).pdf'
[System.Reflection.Assembly]::LoadFrom($lib)
$reader =  New-Object itext.kernel.pdf.PdfReader -ArgumentList $file
$PDFdocument = New-Object itext.kernel.pdf.PdfDocument($reader)