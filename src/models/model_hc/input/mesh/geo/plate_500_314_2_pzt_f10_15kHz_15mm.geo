SetFactory("OpenCASCADE");
L = 0.500; W = 0.314;
xpzt_1 = -0.080; ypzt_1 = 0.000000;
xpzt_2 = 0.080; ypzt_2 = 0.000000;
xdmg_0 = 0e-3; ydmg_0 = 0e-3;
r_pzt = 5e-3;
r_dmg = 15e-3;
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
Circle(17) = {xdmg_0, ydmg_0, 0, r_dmg, 0, 2*Pi};
//+
Curve Loop(6) = {11,12,14};
//+
Curve Loop(7) = {12,15,13};
//+
Curve Loop(8) = {13,16,11};
//+
Curve Loop(9) = {14,15,16};
//+
Curve Loop(10) = {17};
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
Plane Surface(7) = {10};
//+
Plane Surface(8) = {1,5,9,10};

//+
Physical Surface("pzt_1") = {1,2,3};
//+
Physical Surface("pzt_2") = {4,5,6};
//+
Physical Surface("damage") = {7};
//+
Physical Surface("host") = {8};
//+
Transfinite Curve {5, 6, 7,11, 12, 13} = 2 Using Progression 1;
//+
Transfinite Curve {8, 9, 10, 14, 15, 16} = 3 Using Progression 1;
//+
Transfinite Curve {1,3} = 7 Using Progression 1;
//+
Transfinite Curve {2,4} = 5 Using Progression 1;
//+
Transfinite Curve {17} = 17 Using Progression 1;
