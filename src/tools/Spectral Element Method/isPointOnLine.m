function R = isPointOnLine(P1, P2, Q, EndPoints)
% Is point Q=[x3,y3] on line through P1=[x1,y1] and P2=[x2,y2]
% Normal along the line:
P12 = P2 - P1;
L12 = diag(sqrt(P12 * P12'));
N   = bsxfun(@rdivide, P12 ,L12);
% Line from P1 to Q:
PQ = bsxfun(@minus, Q,P1);
% Norm of distance vector: LPQ = N x PQ
Dist = abs(N(:,1) .* PQ(:,2) - N(:,2) .* PQ(:,1));
% Consider rounding errors:
Limit = 500 * eps(single(max(abs(cat(2, P1, P2, repmat(Q,length(L12),1))),[],2)));
R     = (Dist < Limit);
% Consider end points if any 4th input is used:
if any(R) && nargin == 4
  % Projection of the vector from P1 to Q on the line:
  L = diag(PQ * N.');  % DOT product
  R(R==1) = (L(R==1) >= 0.0 & L(R==1) <= L12(R==1));
end