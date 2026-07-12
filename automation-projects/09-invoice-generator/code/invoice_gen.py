from datetime import datetime

from fpdf import FPDF

CUSTOMER_NAME = "John Doe"
CUSTOMER_ADDRESS = "123 Main Street"
ITEMS = [
    {"description": "Web Development", "quantity": 1, "price": 500},
    {"description": "Hosting", "quantity": 1, "price": 99},
]

pdf = FPDF()
pdf.add_page()
pdf.set_font("Arial", size=12)
pdf.cell(0, 10, f"Invoice Date: {datetime.now().strftime('%Y-%m-%d')}", ln=True)
pdf.cell(0, 10, f"Bill To: {CUSTOMER_NAME}", ln=True)
pdf.cell(0, 10, CUSTOMER_ADDRESS, ln=True)
pdf.ln(10)
pdf.set_font("Arial", "B", 12)
pdf.cell(80, 10, "Description", border=1)
pdf.cell(30, 10, "Qty", border=1, align="C")
pdf.cell(30, 10, "Price", border=1, align="C")
pdf.cell(30, 10, "Total", border=1, align="C")
pdf.ln()
pdf.set_font("Arial", size=12)
for item in ITEMS:
    total = item["quantity"] * item["price"]
    pdf.cell(80, 10, item["description"], border=1)
    pdf.cell(30, 10, str(item["quantity"]), border=1, align="C")
    pdf.cell(30, 10, f"${item['price']}", border=1, align="C")
    pdf.cell(30, 10, f"${total}", border=1, align="C")
    pdf.ln()
pdf.output("invoice.pdf")
print("Invoice saved as invoice.pdf")
