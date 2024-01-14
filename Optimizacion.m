%%------------------------------------------------------------------------
%% UNIVERSIDAD INTERNACIONAL DE LA RIOJA
%% Máster en Ingeniería Matemática y Computación
%% AUTOR: Santiago Alexander Rojas Porras
%%----------------------------------------------------------------
function [Kc2,ti2,td2,IAE_act]=Optimizacion(G,H,Kc,ti,td)
%% DATOS DE ENTRADA
% G: Convolución de la Planta y la Válvula
% H: Función de Transferencia del Sensor
% Kc: Constante ProporcionaL
% ti: Constante Integral
% td: Constante Derivativa
%% Desarrollo de la Función
C=tf(Kc*[ti*td ti 1],[ti 0]); % Cálcula la Función de Transferencia
Gc=feedback(C*G,H); % Realiza la Operación de Retroalimentación
[c1,tc1]=step(Gc);
plot([tc1(1) tc1(end)],[1 1],tc1,c1,'linewidth',3); % Gráfica la Respuesta del controlador con los Parametros Iniciales
hold on

%% Cálculo de la Integral del Error Inicial
s_e=ones(1,length(tc1));
ea=abs(c1-s_e');
IAE=trapz(tc1,ea)

%% Tamaño del Paso Y Número de Iteraciones
    h=0.01; % Tamaño del Paso
    iter=40; % Número de Iteraciones

%% Primer Paso 
    Kc=Kc-h*Kc;
    ti=ti-h*ti;
    td=td-h*td;
    C=tf(Kc*[ti*td ti 1],[ti 0]);
    Gc=feedback(C*G,H);
    [c1,tc1]=step(Gc);
    s_e=ones(1,length(tc1));
    %% Cálculo del Error con el primer Paso
    ea=abs(c1-s_e');
    IAE_act=trapz(tc1,ea);
    %% Condicional
    if IAE_act < IAE
        %% Cálculo de los Parámetros por Reducción
        for i=1:iter
            Kc=Kc-h*Kc;
            ti=ti-h*ti;
            td=td-h*td;
            C=tf(Kc*[ti*td ti 1],[ti 0]);
            Gc=feedback(C*G,H);
            [c1,tc1]=step(Gc);
            s_e=ones(1,length(tc1));
            %% Cálculo del Error Actual
            ea=abs(c1-s_e');
            IAE_act=trapz(tc1,ea);
        end
            
    elseif IAE_act>IAE
        %% Cálculo de los Parámetros por Aumento
        for i=1: iter
                   Kc=Kc+h*Kc;
                   ti=ti+h*ti;
                   td=td+h*td;
                   C=tf(Kc*[ti*td ti 1],[ti 0]);
                   Gc=feedback(C*G,H);
                   [c1,tc1]=step(Gc);
                   s_e=ones(1,length(tc1));
                    %% Cálculo del Error Actual
                    ea=abs(c1-s_e');
                    IAE_act=trapz(tc1,ea); 
        end
    end
    %% Obtención de los Párametros Óptimizados
    Kc2=Kc;
    ti2=ti;
    td2=td;
    C2=tf(Kc2*[ti2*td2 ti2 1],[ti2 0]);
    Gc2=feedback(C2*G,H);
    [c2,tc2]=step(Gc2);
    % Gráfica de la Respuesta con Párametros Optimizados
    plot(tc2,c2,'linewidth',3)
    legend('Señal de Referencia','PID Parámetros Inciales','PID parámetros Optimizados')
    hold on
    grid on
    xlabel('t')
    ylabel('y(t)')
    title('Respuesta Final')
    
end


