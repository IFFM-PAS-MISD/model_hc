SetFactory("OpenCASCADE");
L = 0.600; W = 0.600;
xpzt_1 = -0.150; ypzt_1 = 0.000000;
xpzt_2 = 0.150; ypzt_2 = 0.000000;
xdmg_0 = 0e-3; ydmg_0 = 0e-3;
r_pzt = 5e-3;
r_dmg = 0e-3;
//+
Point(1) = {-L/2, -W/2, 0, 1.0};
//+
Point(2) = {L/2, -W/2, 0, 1.0};
//+
Point(3) = {L/2, W/2, 0, 1.0};
//+
Point(4) = {-L/2, W/2, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 1};
//+
Point(5) = {xpzt_1, ypzt_1, 0, 1.0};
//+
Point(6) = {xpzt_1+r_pzt*3^0.5/2, ypzt_1-r_pzt/2, 0, 1.0};
//+
Point(7) = {xpzt_1, ypzt_1+r_pzt, 0, 1.0};
//+
Point(8) = {xpzt_1-r_pzt*3^0.5/2, ypzt_1-r_pzt/2, 0, 1.0};
//+
Line(5) = {5, 6};
//+
Line(6) = {5, 7};
//+
Line(7) = {5, 8};
//+
Circle(8) = {6, 5, 7};
//+
Circle(9) = {7, 5, 8};
//+
Circle(10) = {8, 5, 6};
//+
Point(9) = {xpzt_2, ypzt_2, 0, 1.0};
//+
Point(10) = {xpzt_2-r_pzt*3^0.5/2, ypzt_2-r_pzt/2, 0, 1.0};
//+
Point(11) = {xpzt_2, ypzt_2+r_pzt, 0, 1.0};
//+
Point(12) = {xpzt_2+r_pzt*3^0.5/2, ypzt_1-r_pzt/2, 0, 1.0};
//+
Line(11) = {9, 10};
//+
Line(12) = {9, 11};
//+
Line(13) = {9, 12};
//+
Circle(14) = {10, 9, 11};
//+
Circle(15) = {11, 9, 12};
//+
Circle(16) = {12, 9, 10};
//+
Curve Loop(1) = {4, 1, 2, 3};
//+
Curve Loop(2) = {5,8,6};
//+
Curve Loop(3) = {6,9,7};
//+
Curve Loop(4) = {7,10,5};
//+
Curve Loop(5) = {8,9,10};
//+
Curve Loop(6) = {11,16,13};
//+
Curve Loop(7) = {13,15,12};
//+
Curve Loop(8) = {12,14,11};
//+
Curve Loop(9) = {16,15,14};
//+
Plane Surface(1) = {2};
//+
Plane Surface(2) = {3};
//+
Plane Surface(3) = {4};
//+
Plane Surface(4) = {6};
//+
Plane Surface(5) = {7};
//+
Plane Surface(6) = {8};

//+
Plane Surface(7) = {1,5,9};

//+
Physical Surface("pzt_1") = {1,2,3};
//+
Physical Surface("pzt_2") = {4,5,6};
//+
Physical Surface("host") = {7};
//+
Transfinite Curve {5, 6, 7,11, 12, 13} = 2 Using Progression 1;
//+
Transfinite Curve {8, 9, 10, 14, 15, 16} = 3 Using Progression 1;
//+
Transfinite Curve {1,2,3,4} = 9 Using Progression 1;
