require 'prawn'

class NameTagGenerator
  # Generate a name tag PDF for the checked-in child
  def self.generate(child)
    Prawn::Document.generate("#{child.full_name}_name_tag.pdf", page_size: [252, 165]) do |pdf| # 3.5"x2.35" in points
      pdf.font_size 12
      pdf.bounding_box([0, pdf.bounds.top], width: pdf.bounds.width, height: pdf.bounds.height) do
        pdf.text "Child Name: #{child.full_name}", size: 16, style: :bold, align: :center
        pdf.move_down 10
        pdf.text "Parent Name: #{child.parent.full_name}", size: 12
        pdf.text "Parent Phone: #{child.parent.phone_number}", size: 12
        pdf.text "Classroom: #{child.classroom&.name || 'Not Assigned'}", size: 12
        pdf.move_down 5
        pdf.text "Special Medical Needs:", style: :bold, size: 12
        pdf.text child.special_medical_needs.presence || 'None', size: 10, indent_paragraphs: 10
        pdf.move_down 5
        pdf.text "Emergency Contact:", style: :bold, size: 12
        pdf.text child.emergency_contact.presence || 'None', size: 10, indent_paragraphs: 10
      end

      # Draw a border for the name tag
      pdf.stroke_bounds
    end
  end
end