%%------------------------------------------------------------------------
%% UNIVERSIDAD INTERNACIONAL DE LA RIOJA
%% M�ster en Ingenier�a Matem�tica y Computaci�n
%% AUTOR: Santiago Alexander Rojas Porras
%%----------------------------------------------------------------
function [Kc2,ti2,td2,IAE_act]=Optimizacion(G,H,Kc,ti,td)
%% DATOS DE ENTRADA
% G: Convoluci�n de la Planta y la V�lvula
% H: Funci�n de Transferencia del Sensor
% Kc: Constante ProporcionaL
% ti: Constante Integral
% td: Constante Derivativa
%% Desarrollo de la Funci�n
C=tf(Kc*[ti*td ti 1],[ti 0]); % C�lcula la Funci�n de Transferencia
Gc=feedback(C*G,H); % Realiza la Operaci�n de Retroalimentaci�n
[c1,tc1]=step(Gc);
plot([tc1(1) tc1(end)],[1 1],tc1,c1,'linewidth',3); % Gr�fica la Respuesta del controlador con los Parametros Iniciales
hold on

%% C�lculo de la Integral del Error Inicial
s_e=ones(1,length(tc1));
ea=abs(c1-s_e');
IAE=trapz(tc1,ea)

%% Tama�o del Paso Y N�mero de Iteraciones
    h=0.01; % Tama�o del Paso
    iter=40; % N�mero de Iteraciones

%% Primer Paso 
    Kc=Kc-h*Kc;
    ti=ti-h*ti;
    td=td-h*td;
    C=tf(Kc*[ti*td ti 1],[ti 0]);
    Gc=feedback(C*G,H);
    [c1,tc1]=step(Gc);
    s_e=ones(1,length(tc1));
    %% C�lculo del Error con el primer Paso
    ea=abs(c1-s_e');
    IAE_act=trapz(tc1,ea);
    %% Condicional
    if IAE_act < IAE
        %% C�lculo de los Par�metros por Reducci�n
        for i=1:iter
            Kc=Kc-h*Kc;
            ti=ti-h*ti;
            td=td-h*td;
            C=tf(Kc*[ti*td ti 1],[ti 0]);
            Gc=feedback(C*G,H);
            [c1,tc1]=step(Gc);
            s_e=ones(1,length(tc1));
            %% C�lculo del Error Actual
            ea=abs(c1-s_e');
            IAE_act=trapz(tc1,ea);
        end
            
    elseif IAE_act>IAE
        %% C�lculo de los Par�metros por Aumento
        for i=1: iter
                   Kc=Kc+h*Kc;
                   ti=ti+h*ti;
                   td=td+h*td;
                   C=tf(Kc*[ti*td ti 1],[ti 0]);
                   Gc=feedback(C*G,H);
                   [c1,tc1]=step(Gc);
                   s_e=ones(1,length(tc1));
                    %% C�lculo del Error Actual
                    ea=abs(c1-s_e');
                    IAE_act=trapz(tc1,ea); 
        end
    end
    %% Obtenci�n de los P�rametros �ptimizados
    Kc2=Kc;
    ti2=ti;
    td2=td;
    C2=tf(Kc2*[ti2*td2 ti2 1],[ti2 0]);
    Gc2=feedback(C2*G,H);
    [c2,tc2]=step(Gc2);
    % Gr�fica de la Respuesta con P�rametros Optimizados
    plot(tc2,c2,'linewidth',3)
    legend('Se�al de Referencia','PID Par�metros Inciales','PID par�metros Optimizados')
    hold on
    grid on
    xlabel('t')
    ylabel('y(t)')
    title('Respuesta Final')
    
end


