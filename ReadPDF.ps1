$file = "C:\Users\erudakov\Documents\document(1).pdf"
    Add-Type -Path "C:\Users\erudakov\Documents\PS\iTextSharp\itextsharp.dll"
    $pdf = New-Object iTextSharp.text.pdf.pdfreader -ArgumentList $file
    for ($page = 1; $page -le $pdf.NumberOfPages; $page++){
        $texto=[iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($pdf,$page)
        Write-Output $texto
    }    
    $pdf.Close()


    #