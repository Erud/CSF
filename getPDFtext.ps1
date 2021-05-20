Add-Type -Path .\PowerShellPDF\itextsharp.dll
$reader = New-Object iTextSharp.text.pdf.pdfreader -ArgumentList "C:\Users\erudakov\Documents\document(1).pdf"        

for ($page = 1; $page -le $reader.NumberOfPages; $page++)
{
    $strategy = new-object  'iTextSharp.text.pdf.parser.SimpleTextExtractionStrategy'            
    $currentText = [iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($reader, $page, $strategy);
    [string[]]$Text += [system.text.Encoding]::UTF8.GetString([System.Text.ASCIIEncoding]::Convert( [system.text.encoding]::default  , [system.text.encoding]::UTF8, [system.text.Encoding]::Default.GetBytes($currentText)));      
}
$Reader.Close();