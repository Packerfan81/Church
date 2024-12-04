require 'rqrcode'
begin
  # Define sample data for QR code generation
  child_name = "Ted Bundy"
  parent_name = "Jaye Engelhardt"
  contact = "7574706492"

  qr_code_data = "Child: #{child_name}, Parent: #{parent_name}, Contact: #{contact}"

  # Generate the QR code
  qrcode = RQRCode::QRCode.new(qr_code_data)

  # Convert QR code to SVG format
  svg = qrcode.as_svg(module_size: 4, standalone: true)

  # Write the SVG to a file
  File.open("qr_code_test.svg", "w") { |file| file.write(svg) }
  puts "QR Code generated successfully! Check the file: qr_code_test.svg"

rescue StandardError => e
  puts "QR Code generation failed: #{e.message}"
end