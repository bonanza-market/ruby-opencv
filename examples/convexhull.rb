#!/usr/bin/env ruby
# convexhull.rb
# Draw contours and convexity defect points to captured image
require "rubygems"
require "opencv"
include OpenCV

window = GUI::Window.new("convexhull")
capture = CvCapture::open

accuracy = 1
t = window.set_trackbar("accuracy", 10, 1) { |v|
  accuracy = v
}

circle_options = { color: CvColor::Blue, line_type: :aa, thickness: -1 }

loop do
  image = capture.query

  # Calculate contours from a binary image
  gray = image.BGR2GRAY
  bin = gray.threshold(0x44, 0xFF, :binary)
  contours = bin.find_contours

  while contours
    # Draw contours
    poly = contours.approx(accuracy: accuracy)
    begin
      image.draw_contours!(poly, CvColor::Red, CvColor::Black, 2,
                           thickness: 2, line_type: :aa)
    end while (poly = poly.h_next)

    # Draw convexity defects
    hull = contours.convex_hull2(true, false)
    contours.convexity_defects(hull).each { |cd|
      image.circle!(cd.start, 3, circle_options)
      image.circle!(cd.depth_point, 3, circle_options)
      image.circle!(cd.end, 3, circle_options)
    }
    contours = contours.h_next
  end

  window.show image
  exit if GUI::wait_key(1)
end

