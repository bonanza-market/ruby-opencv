# -*- encoding: utf-8 -*-
# stub: ruby-opencv 0.0.13.20140330211753 ruby lib
# stub: ext/opencv/extconf.rb

Gem::Specification.new do |s|
  s.name = "bonanza-ruby-opencv"
  s.version = "0.0.13.20140330211753"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["lsxi", "ser1zw", "pcting"]
  s.date = "2014-03-30"
  s.description = "ruby-opencv is a wrapper of OpenCV for Ruby. It helps you to write computer vision programs (e.g. detecting faces from pictures) with Ruby."
  s.email = ["masakazu.yonekura@gmail.com", "azariahsawtikes@gmail.com", "pcting@gmail.com"]
  s.extensions = ["ext/opencv/extconf.rb"]
  s.extra_rdoc_files = ["DEVELOPERS_NOTE.md", "History.txt", "License.txt", "Manifest.txt", "README.md", "examples/facerec/readme.md"]
  s.files = [".gitignore", ".yardopts", "DEVELOPERS_NOTE.md", "Gemfile", "History.txt", "License.txt", "Manifest.txt", "README.md", "Rakefile", "config.yml", "examples/alpha_blend.rb", "examples/contours/bitmap-contours-with-labels.png", "examples/contours/bitmap-contours.png", "examples/contours/bounding-box-detect-canny.rb", "examples/contours/contour_retrieval_modes.rb", "examples/contours/rotated-boxes.jpg", "examples/convexhull.rb", "examples/face_detect.rb", "examples/facerec/create_csv.rb", "examples/facerec/facerec_eigenfaces.rb", "examples/facerec/facerec_fisherfaces.rb", "examples/facerec/facerec_lbph.rb", "examples/facerec/readme.md", "examples/find_obj.rb", "examples/houghcircle.rb", "examples/images/box.png", "examples/images/box_in_scene.png", "examples/images/inpaint.png", "examples/images/lena-256x256.jpg", "examples/images/lena-eyes.jpg", "examples/images/lenna-rotated.jpg", "examples/images/lenna.jpg", "examples/images/stuff.jpg", "examples/images/tiffany.jpg", "examples/inpaint.rb", "examples/match_kdtree.rb", "examples/match_template.rb", "examples/paint.rb", "examples/snake.rb", "ext/opencv/algorithm.cpp", "ext/opencv/algorithm.h", "ext/opencv/curve.cpp", "ext/opencv/curve.h", "ext/opencv/cvavgcomp.cpp", "ext/opencv/cvavgcomp.h", "ext/opencv/cvbox2d.cpp", "ext/opencv/cvbox2d.h", "ext/opencv/cvcapture.cpp", "ext/opencv/cvcapture.h", "ext/opencv/cvchain.cpp", "ext/opencv/cvchain.h", "ext/opencv/cvcircle32f.cpp", "ext/opencv/cvcircle32f.h", "ext/opencv/cvconnectedcomp.cpp", "ext/opencv/cvconnectedcomp.h", "ext/opencv/cvcontour.cpp", "ext/opencv/cvcontour.h", "ext/opencv/cvcontourtree.cpp", "ext/opencv/cvcontourtree.h", "ext/opencv/cvconvexitydefect.cpp", "ext/opencv/cvconvexitydefect.h", "ext/opencv/cverror.cpp", "ext/opencv/cverror.h", "ext/opencv/cvfeaturetree.cpp", "ext/opencv/cvfeaturetree.h", "ext/opencv/cvfont.cpp", "ext/opencv/cvfont.h", "ext/opencv/cvhaarclassifiercascade.cpp", "ext/opencv/cvhaarclassifiercascade.h", "ext/opencv/cvhistogram.cpp", "ext/opencv/cvhistogram.h", "ext/opencv/cvhumoments.cpp", "ext/opencv/cvhumoments.h", "ext/opencv/cvline.cpp", "ext/opencv/cvline.h", "ext/opencv/cvmat.cpp", "ext/opencv/cvmat.h", "ext/opencv/cvmemstorage.cpp", "ext/opencv/cvmemstorage.h", "ext/opencv/cvmoments.cpp", "ext/opencv/cvmoments.h", "ext/opencv/cvpoint.cpp", "ext/opencv/cvpoint.h", "ext/opencv/cvpoint2d32f.cpp", "ext/opencv/cvpoint2d32f.h", "ext/opencv/cvpoint3d32f.cpp", "ext/opencv/cvpoint3d32f.h", "ext/opencv/cvrect.cpp", "ext/opencv/cvrect.h", "ext/opencv/cvscalar.cpp", "ext/opencv/cvscalar.h", "ext/opencv/cvseq.cpp", "ext/opencv/cvseq.h", "ext/opencv/cvsize.cpp", "ext/opencv/cvsize.h", "ext/opencv/cvsize2d32f.cpp", "ext/opencv/cvsize2d32f.h", "ext/opencv/cvslice.cpp", "ext/opencv/cvslice.h", "ext/opencv/cvsurfparams.cpp", "ext/opencv/cvsurfparams.h", "ext/opencv/cvsurfpoint.cpp", "ext/opencv/cvsurfpoint.h", "ext/opencv/cvtermcriteria.cpp", "ext/opencv/cvtermcriteria.h", "ext/opencv/cvtwopoints.cpp", "ext/opencv/cvtwopoints.h", "ext/opencv/cvutils.cpp", "ext/opencv/cvutils.h", "ext/opencv/cvvideowriter.cpp", "ext/opencv/cvvideowriter.h", "ext/opencv/eigenfaces.cpp", "ext/opencv/eigenfaces.h", "ext/opencv/extconf.rb", "ext/opencv/facerecognizer.cpp", "ext/opencv/facerecognizer.h", "ext/opencv/fisherfaces.cpp", "ext/opencv/fisherfaces.h", "ext/opencv/gui.cpp", "ext/opencv/gui.h", "ext/opencv/iplconvkernel.cpp", "ext/opencv/iplconvkernel.h", "ext/opencv/iplimage.cpp", "ext/opencv/iplimage.h", "ext/opencv/lbph.cpp", "ext/opencv/lbph.h", "ext/opencv/mouseevent.cpp", "ext/opencv/mouseevent.h", "ext/opencv/opencv.cpp", "ext/opencv/opencv.h", "ext/opencv/pointset.cpp", "ext/opencv/pointset.h", "ext/opencv/trackbar.cpp", "ext/opencv/trackbar.h", "ext/opencv/window.cpp", "ext/opencv/window.h", "images/CvMat_sobel.png", "images/CvMat_sub_rect.png", "images/CvSeq_relationmap.png", "lib/opencv.rb", "lib/opencv/psyched_yaml.rb", "lib/opencv/version.rb", "ruby-opencv.gemspec", "test/eigenfaces_save.xml", "test/fisherfaces_save.xml", "test/helper.rb", "test/lbph_save.xml", "test/runner.rb", "test/samples/airplane.jpg", "test/samples/baboon.jpg", "test/samples/baboon200.jpg", "test/samples/baboon200_rotated.jpg", "test/samples/blank0.jpg", "test/samples/blank1.jpg", "test/samples/blank2.jpg", "test/samples/blank3.jpg", "test/samples/blank4.jpg", "test/samples/blank5.jpg", "test/samples/blank6.jpg", "test/samples/blank7.jpg", "test/samples/blank8.jpg", "test/samples/blank9.jpg", "test/samples/cat.jpg", "test/samples/chessboard.jpg", "test/samples/contours.jpg", "test/samples/fruits.jpg", "test/samples/haarcascade_frontalface_alt.xml.gz", "test/samples/inpaint-mask.bmp", "test/samples/lena-256x256.jpg", "test/samples/lena-32x32.jpg", "test/samples/lena-eyes.jpg", "test/samples/lena-inpaint.jpg", "test/samples/lena.jpg", "test/samples/lines.jpg", "test/samples/messy0.jpg", "test/samples/messy1.jpg", "test/samples/movie_sample.avi", "test/samples/one_way_train_0000.jpg", "test/samples/one_way_train_0001.jpg", "test/samples/partially_blank0.jpg", "test/samples/partially_blank1.jpg", "test/samples/smooth0.jpg", "test/samples/smooth1.jpg", "test/samples/smooth2.jpg", "test/samples/smooth3.jpg", "test/samples/smooth4.jpg", "test/samples/smooth5.jpg", "test/samples/smooth6.jpg", "test/samples/str-cv-rotated.jpg", "test/samples/str-cv.jpg", "test/samples/str-ov.jpg", "test/samples/stuff.jpg", "test/test_curve.rb", "test/test_cvavgcomp.rb", "test/test_cvbox2d.rb", "test/test_cvcapture.rb", "test/test_cvchain.rb", "test/test_cvcircle32f.rb", "test/test_cvconnectedcomp.rb", "test/test_cvcontour.rb", "test/test_cvcontourtree.rb", "test/test_cverror.rb", "test/test_cvfeaturetree.rb", "test/test_cvfont.rb", "test/test_cvhaarclassifiercascade.rb", "test/test_cvhistogram.rb", "test/test_cvhumoments.rb", "test/test_cvline.rb", "test/test_cvmat.rb", "test/test_cvmat_drawing.rb", "test/test_cvmat_dxt.rb", "test/test_cvmat_imageprocessing.rb", "test/test_cvmoments.rb", "test/test_cvpoint.rb", "test/test_cvpoint2d32f.rb", "test/test_cvpoint3d32f.rb", "test/test_cvrect.rb", "test/test_cvscalar.rb", "test/test_cvseq.rb", "test/test_cvsize.rb", "test/test_cvsize2d32f.rb", "test/test_cvslice.rb", "test/test_cvsurfparams.rb", "test/test_cvsurfpoint.rb", "test/test_cvtermcriteria.rb", "test/test_cvtwopoints.rb", "test/test_cvvideowriter.rb", "test/test_eigenfaces.rb", "test/test_fisherfaces.rb", "test/test_iplconvkernel.rb", "test/test_iplimage.rb", "test/test_lbph.rb", "test/test_mouseevent.rb", "test/test_opencv.rb", "test/test_pointset.rb", "test/test_preliminary.rb", "test/test_trackbar.rb", "test/test_window.rb", "yard_extension.rb"]
  s.homepage = "https://github.com/ruby-opencv/ruby-opencv/"
  s.licenses = ["The BSD License"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.2.2"
  s.summary = "OpenCV wrapper for Ruby"
  s.test_files = ["test/test_cvcontour.rb", "test/test_eigenfaces.rb", "test/test_cvmoments.rb", "test/test_cvseq.rb", "test/test_cvcontourtree.rb", "test/test_cvbox2d.rb", "test/test_iplimage.rb", "test/test_cvvideowriter.rb", "test/test_cvline.rb", "test/test_cvhumoments.rb", "test/test_cvfont.rb", "test/test_cvconnectedcomp.rb", "test/test_cvhistogram.rb", "test/test_trackbar.rb", "test/test_cvmat_imageprocessing.rb", "test/test_cvhaarclassifiercascade.rb", "test/test_cvcircle32f.rb", "test/test_cvcapture.rb", "test/test_cvmat_dxt.rb", "test/test_cvrect.rb", "test/test_iplconvkernel.rb", "test/test_cvsurfpoint.rb", "test/test_cvavgcomp.rb", "test/test_cvscalar.rb", "test/test_pointset.rb", "test/test_curve.rb", "test/test_cvtermcriteria.rb", "test/test_cvtwopoints.rb", "test/test_cvsurfparams.rb", "test/test_cvpoint2d32f.rb", "test/test_cvpoint3d32f.rb", "test/test_cvfeaturetree.rb", "test/test_mouseevent.rb", "test/test_cvchain.rb", "test/test_cvmat.rb", "test/test_fisherfaces.rb", "test/test_cverror.rb", "test/test_cvpoint.rb", "test/test_cvsize2d32f.rb", "test/test_preliminary.rb", "test/test_cvmat_drawing.rb", "test/test_lbph.rb", "test/test_cvsize.rb", "test/test_window.rb", "test/test_cvslice.rb", "test/test_opencv.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<rake-compiler>, ["~> 0"])
      s.add_development_dependency(%q<hoe-gemspec>, ["~> 0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.10"])
    else
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<rake-compiler>, ["~> 0"])
      s.add_dependency(%q<hoe-gemspec>, ["~> 0"])
      s.add_dependency(%q<hoe>, ["~> 3.10"])
    end
  else
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<rake-compiler>, ["~> 0"])
    s.add_dependency(%q<hoe-gemspec>, ["~> 0"])
    s.add_dependency(%q<hoe>, ["~> 3.10"])
  end
end
