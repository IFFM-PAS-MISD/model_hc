// Gmsh project created on Tue Feb  2 11:02:07 2021
SetFactory("OpenCASCADE");
//+
Point(1) = {-0.250, -0.250, 0, 1.0};
//+
Point(2) = {0.250, -0.250, 0, 1.0};
//+
Point(3) = {0.250, 0.250, 0, 1.0};
//+
Point(4) = {-0.250, 0.250, 0, 1.0};
//+
Point(5) = {0.0, 0.0, 0, 1.0};
//+
Point(6) = {0.005, 0.0, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+q
Line(4) = {4, 1};
//+
Circle(5) = {0, -0, 0, 0.005, 0, 2*Pi};
//+
Curve Loop(1) = {4, 1, 2, 3};
//+
Curve Loop(2) = {5};
//+
Plane Surface(1) = {2};
//+
Plane Surface(2) = {1,2};
//+
Physical Surface("pzt") = {1};
//+
Physical Surface("host") = {2};
Mesh.MeshSizeMax = 0.02;
