/************************************************************

   cvcontour.cpp -

   $Author: lsxi $

   Copyright (C) 2007 Masakazu Yonekura

************************************************************/
#include "cvcontour.h"
/*
 * Document-class: OpenCV::CvContour
 *
 * Contour
 *
 * @see CvMat#find_contours
 */
__NAMESPACE_BEGIN_OPENCV
__NAMESPACE_BEGIN_CVCONTOUR

#define APPROX_POLY_OPTION(op) rb_get_option_table(rb_klass, "APPROX_OPTION", op)
#define APPROX_POLY_METHOD(op) CVMETHOD("APPROX_POLY_METHOD", LOOKUP_HASH(op, "method"), CV_POLY_APPROX_DP)
#define APPROX_POLY_ACCURACY(op) NUM2DBL(LOOKUP_HASH(op, "accuracy"))
#define APPROX_POLY_RECURSIVE(op) TRUE_OR_FALSE(LOOKUP_HASH(op, "recursive"))

VALUE rb_allocate(VALUE klass);
void cvcontour_free(void *ptr);

VALUE rb_klass;

VALUE
rb_class()
{
  return rb_klass;
}

VALUE
rb_allocate(VALUE klass)
{
  return Data_Wrap_Struct(klass, mark_root_object, unregister_object, NULL);
}

/*
 * Constructor
 * @overload new(storage = nil)
 *   @param [CvMemStorage] storage Sequence location
 * @return [CvContour] self
 * @opencv_func cvCreateSeq
 */
VALUE
rb_initialize(int argc, VALUE *argv, VALUE self)
{
  VALUE storage;
  rb_scan_args(argc, argv, "01", &storage);

  if (NIL_P(storage))
    storage = cCvMemStorage::new_object(0);
  else
    storage = CHECK_CVMEMSTORAGE(storage);

  try {
    DATA_PTR(self) = (CvContour*)cvCreateSeq(CV_SEQ_ELTYPE_POINT, sizeof(CvContour),
					     sizeof(CvPoint), CVMEMSTORAGE(storage));
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  cCvSeq::register_elem_class(self, cCvPoint::rb_class());
  register_root_object(CVSEQ(self), storage);

  return self;
}

/*
 * Returns bounding box of the contour
 * @overload rect
 * @return [CvRect] Bounding box of the contour
 */
VALUE
rb_rect(VALUE self)
{
  return cCvRect::new_object(CVCONTOUR(self)->rect);
}

/*
 * Returns color of the contour
 * @overload color
 * @return [Number] Color of the contour
 */
VALUE
rb_color(VALUE self)
{
  return INT2NUM(CVCONTOUR(self)->color);
}

/*
 * Set color of the contour
 * @overload color=value
 *   @param value [Number] Color of the contour
 */
VALUE
rb_set_color(VALUE self, VALUE color)
{
  CVCONTOUR(self)->color = NUM2INT(color);
  return self;
}

/*
 * Returns reserved region values of the contour
 * @overload reserved
 * @return [Array<Number>] Reserved region values of the contour
 */
VALUE
rb_reserved(VALUE self)
{
  return rb_ary_new3(3,
		     INT2NUM(CVCONTOUR(self)->reserved[0]),
		     INT2NUM(CVCONTOUR(self)->reserved[1]),
		     INT2NUM(CVCONTOUR(self)->reserved[2]));
}

/*
 * Approximates polygonal curves with desired precision
 * @overload approx_poly(options)
 *   @param options [Hash] Parameters
 *   @option options [Symbol] :method Approximation method (default :dp)
 *     * :dp - Douglas-Peucker algorithm.
 *   @option options [Number] :accuracy Parameter specifying the approximation accuracy.
 *     This is the maximum distance between the original curve and its approximation.
 *   @option options [Boolean] :recursive Recursion flag. If true, the function approximates
 *     all the contours accessible from curve by h_next and v_next links.
 * @return [CvContour] Result of the approximation
 * @return [nil] Approximation faied
 * @opencv_func cvApproxPoly
 */
VALUE
rb_approx_poly(int argc, VALUE *argv, VALUE self)
{
  VALUE approx_poly_option;
  rb_scan_args(argc, argv, "01", &approx_poly_option);  
  approx_poly_option = APPROX_POLY_OPTION(approx_poly_option);
  VALUE storage = cCvMemStorage::new_object();
  CvSeq *contour = cvApproxPoly(CVCONTOUR(self), sizeof(CvContour), CVMEMSTORAGE(storage),
				APPROX_POLY_METHOD(approx_poly_option),
				APPROX_POLY_ACCURACY(approx_poly_option),
				APPROX_POLY_RECURSIVE(approx_poly_option));

  if (contour && contour->total > 0) {
    return cCvSeq::new_sequence(cCvContour::rb_class(), contour, cCvPoint::rb_class(), storage);
  }
  return Qnil;
}

/*
 * Calculates up-right bounding rectangle of point set.
 * @overload bounding_rect
 * @return [CvRect] Bounding rectangle
 * @opencv_func cvBoundingRect
 */
VALUE
rb_bounding_rect(VALUE self)
{
  CvRect rect;
  try {
    rect = cvBoundingRect(CVCONTOUR(self), 1);
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  return cCvRect::new_object(rect);
}

/*
 * Creates hierarchical representation of contour
 * @overload create_tree(threshold = 0.0)
 *   @param threshold [Number] If <= 0, the method creates full binary tree representation.
 *     If > 0, the method creates representation with the precision threshold.
 * @return [CvContourTree] Hierarchical representation of the contour
 * @opencv_func cvCreateContourTree
 */
VALUE
rb_create_tree(int argc, VALUE *argv, VALUE self)
{
  VALUE threshold, storage;
  rb_scan_args(argc, argv, "01", &threshold);
  storage = cCvMemStorage::new_object();
  CvContourTree *tree = NULL;
  try {
    tree = cvCreateContourTree(CVSEQ(self), CVMEMSTORAGE(storage), IF_DBL(threshold, 0.0));
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  return cCvSeq::new_sequence(cCvContourTree::rb_class(), (CvSeq*)tree, cCvPoint::rb_class(), storage);
}

/*
 * Performs a point-in-contour test.
 * The method determines whether the point is inside a contour, outside,
 * or lies on an edge (or coincides with a vertex).
 * @overload in?(point)
 *   @param point [CvPoint2D32f] Point tested against the contour
 * @return [Boolean] If the point is inside, returns true. If outside, returns false.
 *   If lies on an edge, returns nil.
 * @opencv_func cvPointPolygonTest
 */
VALUE
rb_in_q(VALUE self, VALUE point)
{
  double n = 0;
  try {
    n = cvPointPolygonTest(CVARR(self), VALUE_TO_CVPOINT2D32F(point), 0);
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  return n == 0 ? Qnil : n > 0 ? Qtrue : Qfalse;
}

/*
 * Calculates distance between a point and the nearest contour edgex
 * @overload measure_distance(point)
 *   @param point [CvPoint2D32f] Point tested against the contour
 * @return Signed distance between the point and the nearest contour edge
 * @opencv_func cvPointPolygonTest
 */
VALUE
rb_measure_distance(VALUE self, VALUE point)
{
  double distance = 0;
  try {
    distance = cvPointPolygonTest(CVARR(self), VALUE_TO_CVPOINT2D32F(point), 1);
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  return rb_float_new(distance);
}

/*
 * Determines whether the point is inside a contour, outside, or lies on an edge (or coinsides with a vertex).
 * @overload point_polygon_test(point, measure_dist)
 *   @param point [CvPoint2D32f] Point tested against the contour
 *   @param measure_dist [Boolean] If true, the method estimates the signed distance from the point to
 *      the nearest contour edge. Otherwise, the function only checks if the point is inside a contour or not.
 * @return [Number] When measure_dist = false, the return value is +1, -1 and 0, respectively.
 *   When measure_dist = true, it is a signed distance between the point and the nearest contour edge.
 * @opencv_func cvPointPolygonTest
 */
VALUE
rb_point_polygon_test(VALUE self, VALUE point, VALUE measure_dist)
{
  int measure_dist_flag;

  if (measure_dist == Qtrue)
    measure_dist_flag = 1;
  else if (measure_dist == Qfalse)
    measure_dist_flag = 0;
  else
    measure_dist_flag = NUM2INT(measure_dist);

  double dist = Qnil;
  try {
    dist = cvPointPolygonTest(CVARR(self), VALUE_TO_CVPOINT2D32F(point), measure_dist_flag);
  }
  catch (cv::Exception& e) {
    raise_cverror(e);
  }
  
  /* cvPointPolygonTest returns 100, -100 or 0 when measure_dist = 0 */
  if ((!measure_dist_flag) && ((int)dist) != 0)
    dist = (dist > 0) ? 1 : -1;

  return rb_float_new(dist);
}

VALUE new_object()
{  
  VALUE object = rb_allocate(rb_klass);
  rb_initialize(0, NULL, object);
  return object;
}


void
init_ruby_class()
{
#if 0
  // For documentation using YARD
  VALUE opencv = rb_define_module("OpenCV");
  VALUE cvseq = rb_define_class_under(opencv, "CvSeq");
  VALUE curve = rb_define_module_under(opencv, "Curve");
  VALUE pointset = rb_define_module_under(opencv, "PointSet");
#endif

  if (rb_klass)
    return;

  VALUE opencv = rb_module_opencv();
  VALUE cvseq = cCvSeq::rb_class();
  VALUE curve = mCurve::rb_module();
  VALUE pointset = mPointSet::rb_module();

  rb_klass = rb_define_class_under(opencv, "CvContour", cvseq);
  rb_include_module(rb_klass, curve);
  rb_include_module(rb_klass, pointset);

  rb_define_alloc_func(rb_klass, rb_allocate);

  VALUE approx_option = rb_hash_new();
  rb_define_const(rb_klass, "APPROX_OPTION", approx_option);
  rb_hash_aset(approx_option, ID2SYM(rb_intern("method")), INT2FIX(CV_POLY_APPROX_DP));
  rb_hash_aset(approx_option, ID2SYM(rb_intern("accuracy")), rb_float_new(1.0));
  rb_hash_aset(approx_option, ID2SYM(rb_intern("recursive")), Qfalse);
  
  rb_define_method(rb_klass, "initialize", RUBY_METHOD_FUNC(rb_initialize), -1);
  rb_define_method(rb_klass, "rect", RUBY_METHOD_FUNC(rb_rect), 0);
  rb_define_method(rb_klass, "color", RUBY_METHOD_FUNC(rb_color), 0);
  rb_define_method(rb_klass, "color=", RUBY_METHOD_FUNC(rb_set_color), 1);
  rb_define_method(rb_klass, "reserved", RUBY_METHOD_FUNC(rb_reserved), 0);
  rb_define_method(rb_klass, "approx_poly", RUBY_METHOD_FUNC(rb_approx_poly), -1);
  rb_define_alias(rb_klass, "approx", "approx_poly");
  rb_define_method(rb_klass, "bounding_rect", RUBY_METHOD_FUNC(rb_bounding_rect), 0);
  rb_define_method(rb_klass, "create_tree", RUBY_METHOD_FUNC(rb_create_tree), -1);
  rb_define_method(rb_klass, "in?", RUBY_METHOD_FUNC(rb_in_q), 1);
  rb_define_method(rb_klass, "measure_distance", RUBY_METHOD_FUNC(rb_measure_distance), 1);
  rb_define_method(rb_klass, "point_polygon_test", RUBY_METHOD_FUNC(rb_point_polygon_test), 2);
}

__NAMESPACE_END_CVCONTOUR
__NAMESPACE_END_OPENCV

