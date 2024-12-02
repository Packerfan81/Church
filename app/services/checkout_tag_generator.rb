# /app/services/CheckoutTagGenerator
require 'prawn'

class CheckoutTagGenerator
  def initialize(child)
    @child = child
  end

  def generate
    Prawn::Document.new(page_size: [252, 162], page_layout: :landscape) do |pdf|
      # Set font and styles
      pdf.font "Helvetica"

      # Draw a border for the tag
      pdf.stroke_color "000000"
      pdf.line_width = 1
      pdf.stroke_rectangle [pdf.bounds.left, pdf.bounds.top], pdf.bounds.width, pdf.bounds.height

      # Add Child's Name
      pdf.move_down 10
      pdf.text @child.full_name, size: 20, style: :bold, align: :center

      # Add Parent's Contact Info
      pdf.move_down 20
      pdf.text "Parent: #{@child.parent.full_name}", size: 14, align: :left
      pdf.text "Contact: #{@child.parent.phone_number}", size: 14, align: :left

      # Add a notice
      pdf.move_down 30
      pdf.text "You must present this tag to check out your child.", size: 12, style: :italic, align: :center

      pdf.render
    end
  end
end
