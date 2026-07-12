import os

from PyPDF2 import PdfMerger, PdfReader, PdfWriter


def merge_pdfs(folder_path, output_name="merged.pdf"):
    merger = PdfMerger()
    for file_name in sorted(os.listdir(folder_path)):
        if file_name.endswith(".pdf"):
            merger.append(os.path.join(folder_path, file_name))
    merger.write(output_name)
    merger.close()
    print(f"Merged PDFs into {output_name}")


def split_pdf(input_path, output_folder="split"):
    os.makedirs(output_folder, exist_ok=True)
    reader = PdfReader(input_path)
    for index, page in enumerate(reader.pages, start=1):
        writer = PdfWriter()
        writer.add_page(page)
        with open(os.path.join(output_folder, f"page_{index}.pdf"), "wb") as handle:
            writer.write(handle)
    print(f"Split {len(reader.pages)} pages into {output_folder}")


merge_pdfs("./pdfs")
# split_pdf("input.pdf")
