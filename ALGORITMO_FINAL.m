clc
clear
Kc=6;
ti=0.95;
td=0.2375;
%Funcion de transferencia (Válvula - Planta)
G=tf(1,conv([1/3 1],[1 1]));
%Funcion de transferencia (Sensor)
H=tf(1,[1/2 1]);
 %Lazo Cerrado
   %Gc=feedback(k*G,H);
C=tf(Kc*[ti*td ti 1],[ti 0]);
Gc=feedback(C*G,H);
[c1,tc1]=step(Gc);
plot([tc1(1) tc1(end)],[1 1],tc1,c1,'linewidth',3);
hold on
% CALCULO DEL ERROR
s_e=ones(1,length(tc1));
ea=abs(c1-s_e');
IAE=trapz(tc1,ea)

h=0.01;
iter=30;

    Kc=Kc-h*Kc;
    ti=ti-h*ti;
    td=td-h*td;
   %Funcion de transferencia (Válvula - Planta)
    G=tf(1,conv([1/3 1],[1 1]));
    %Funcion de transferencia (Sensor)
    H=tf(1,[1/2 1]);
    %Lazo Cerrado
   %Gc=feedback(k*G,H);
    C=tf(Kc*[ti*td ti 1],[ti 0]);
    Gc=feedback(C*G,H);
    [c1,tc1]=step(Gc);
    s_e=ones(1,length(tc1));
    % CALCULO DEL ERROR
    ea=abs(c1-s_e');
    IAE_act=trapz(tc1,ea)
    v=0;
    if IAE_act> IAE
        for i=1:iter
            Kc=Kc+h*Kc;
            ti=ti+h*ti;
            td=td+h*td;
       %Funcion de transferencia (Válvula - Planta)
G=tf(1,conv([1/3 1],[1 1]));
%Funcion de transferencia (Sensor)
H=tf(1,[1/2 1]);
 %Lazo Cerrado
   %Gc=feedback(k*G,H);
C=tf(Kc*[ti*td ti 1],[ti 0]);
Gc=feedback(C*G,H);
[c1,tc1]=step(Gc);
            s_e=ones(1,length(tc1));
            % CALCULO DEL ERROR
            ea=abs(c1-s_e');
            IAE_act=trapz(tc1,ea);
%             ERROR= IAE_act
%             ERROR2=IAE
%             if IAE_act>IAE
%             break
%             end
%             IAE=IAE_act
%             v=v+1;
%             ERROR= IAE_act
            %IAE= IAE_act
        end
            
    elseif IAE_act<=IAE
        for i=1: iter
                   Kc=Kc-h*Kc;
                    ti=ti-h*ti;
                    td=td-h*td;
                    G=tf([2],conv([2 1],[5 1]));
                    G.iodelay=1;
                    C=tf(Kc*[ti*td ti 1],[ti 0]);
                    [c1,tc1]=step((C*G)/(1+C*G));
                    s_e=ones(1,length(tc1));
                    % CALCULO DEL ERROR
                    ea=abs(c1-s_e');
                    IAE_act=trapz(tc1,ea); 
%                    ERROR=IAE_act
%                                 ERROR= IAE_act
%             ERROR2=IAE
%                     if IAE_act<ERROR
%                 break
%             end
%            
%                     IAE=IAE_act;
        end

    end
Kc
ti
td
IAE_act

Kc2=Kc;
ti2=ti;
td2=td;

%Funcion de transferencia (Válvula - Planta)
G=tf(1,conv([1/3 1],[1 1]));
%Funcion de transferencia (Sensor)
H=tf(1,[1/2 1]);
 %Lazo Cerrado
   %Gc=feedback(k*G,H);
C=tf(Kc2*[ti2*td2 ti2 1],[ti2 0]);
Gc=feedback(C*G,H);
[c2,tc2]=step(Gc);
plot([tc2(1) tc2(end)],[1 1],tc2,c2,'linewidth',3);
hold on
% CALCULO DEL ERROR
s_e=ones(1,length(tc2));
ea2=abs(c2-s_e');
IAE_final=trapz(tc2,ea2)
