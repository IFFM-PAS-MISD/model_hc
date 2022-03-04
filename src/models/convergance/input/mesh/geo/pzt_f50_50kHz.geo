SetFactory("OpenCASCADE");
L = 0.400; W = 0.400;
xpzt_1 = 0.0; ypzt_1 = 0.000000;
xpzt_2 = 0.0; ypzt_2 = 0.000000;
xdmg_0 = 0e-3; ydmg_0 = 0e-3;
r_pzt = 5e-3;
r_dmg = 0e-3;
//+
Point(1) = {xpzt_1, ypzt_1, 0, 1.0};
//+
Point(2) = {xpzt_1+r_pzt*3^0.5/2, ypzt_1-r_pzt/2, 0, 1.0};
//+
Point(3) = {xpzt_1, ypzt_1+r_pzt, 0, 1.0};
//+
Point(4) = {xpzt_1-r_pzt*3^0.5/2, ypzt_1-r_pzt/2, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {1, 3};
//+
Line(3) = {1, 4};
//+
Circle(4) = {2, 1, 3};
//+
Circle(5) = {3, 1, 4};
//+
Circle(6) = {4, 1, 2};
//+
Curve Loop(1) = {1, 4, 2};
//+
Plane Surface(1) = {1};
//+
Curve Loop(2) = {2, 5, 3};
//+
Plane Surface(2) = {2};
//+
Curve Loop(3) = {3, 6, 1};
//+
Plane Surface(3) = {3};
//+
Transfinite Curve {1, 2, 3} = 2 Using Progression 1;
//+
Transfinite Curve {4, 5, 6} = 3 Using Progression 1;
