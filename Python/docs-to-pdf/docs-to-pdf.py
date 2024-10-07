import os
from docx2pdf import convert

def docx_zu_pdf(eingabe_ordner, ausgabe_ordner):
    # Überprüfen, ob der Ausgabeordner existiert, wenn nicht, erstellen
    if not os.path.exists(ausgabe_ordner):
        os.makedirs(ausgabe_ordner)

    # Durchsuchen des Eingabeordners nach .docx-Dateien
    for dateiname in os.listdir(eingabe_ordner):
        if dateiname.endswith('.docx'):
            eingabe_pfad = os.path.join(eingabe_ordner, dateiname)
            ausgabe_pfad = os.path.join(ausgabe_ordner, dateiname.replace('.docx', '.pdf'))
            
            print(f"Konvertiere {dateiname} zu PDF...")
            convert(eingabe_pfad, ausgabe_pfad)
            print(f"{dateiname} wurde erfolgreich konvertiert.")

# Beispielaufruf
eingabe_ordner = 'C:\\Users\\soniiit\\Downloads\\Word'
ausgabe_ordner = 'C:\\Users\\soniiit\\Downloads\\PDF'
docx_zu_pdf(eingabe_ordner, ausgabe_ordner)
