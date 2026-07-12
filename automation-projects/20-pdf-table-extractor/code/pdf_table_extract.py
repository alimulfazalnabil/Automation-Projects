import tabula

PDF_FILE = "report.pdf"
OUTPUT_FILE = "tables.csv"

try:
    tables = tabula.read_pdf(PDF_FILE, pages="all", multiple_tables=True)
    if tables:
        tables[0].to_csv(OUTPUT_FILE, index=False)
        print(f"Saved first table to {OUTPUT_FILE}")
    else:
        print("No tables found in the PDF")
except Exception as exc:
    print(f"Failed to extract tables: {exc}")
