function Ut_P = local2global(Ut_P,Ut,I_G,I_L)
             I_L = reshape(I_L,[],1);
             I_G = reshape(I_G,[],1);
        if isempty(Ut)
            Ut_P = [];
        else
            Ut_P(I_L) = Ut(I_G);
        end