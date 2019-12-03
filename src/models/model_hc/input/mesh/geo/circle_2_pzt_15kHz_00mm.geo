SetFactory("OpenCASCADE");
L = 0.500000; W = 0.314000;
xpzt_1 = -0.0900; ypzt_1 = 0.000000;
xpzt_2 = 0.0900; ypzt_2 = 0.000000;
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
Circle(5) = {xpzt_1, ypzt_1, 0, r_pzt, 0, 2*Pi};
//+
Circle(6) = {xpzt_2, ypzt_2, 0, r_pzt, 0, 2*Pi};
//+
Curve Loop(1) = {4, 1, 2, 3};
//+
Curve Loop(2) = {5};
//+
Curve Loop(3) = {6};
//+
Curve Loop(4) = {5};
//+
Curve Loop(5) = {6};
//+
Plane Surface(1) = {4};
//+
Plane Surface(2) = {5};
//+
Plane Surface(3) = {1,2,3,4};
//+
Point(8) = {xpzt_1, ypzt_1, 0, 1.0};
//+
Point{8} In Surface {1};// mesh node at centre of pzt_1
//+
Point(9) = {xpzt_2, ypzt_2, 0, 1.0};
//+
Point{9} In Surface {2};// mesh node at centre of pzt_2
//+
Physical Surface("pzt_1") = {1};
//+
Physical Surface("pzt_2") = {2};
//+
Physical Surface("host") = {3};
//+
Transfinite Curve {5, 6} = 9 Using Progression 1;
