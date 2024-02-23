clear all;
close all;
clc;

data = load('iddata-15.mat');

uId = data.id.InputData;
yId = data.id.OutputData;

uVal = data.val.InputData;
yVal = data.val.OutputData;

subplot 211
plot(uId);
title("Identification Input Data")
subplot 212
plot(yId)
title("Identification Output Data")

figure

subplot 211
plot(uVal)
title("Validation Input Data")
subplot 212
plot(yVal)
title("Validation Output Data")

na = 1;
nb = 2;
m = 3;

phi = [];

for i = 1:length(uId)
    phia = [];
    phib = [];
    for j = 1:na
        if i-j>0
            phia = [phia yId(i-j)];
        else
            phia = [phia 0];
        end
    end

    for j = 1:nb
        if i-j>0
            phib = [phib uId(i-j)];
        else
            phib = [phib 0];
        end
    end

    phi = [phi; phia phib];

end
Phi = [];
for I = 1:length(phi)
     Phi = [Phi; Poly(phi(I,:),m)];
end


% Prediction
theta = Phi \ yId;
yhatId = Phi* theta;

subplot 121
hold on
plot(yhatId,'r')
plot(yId,'k')
grid;shg
hold off
title('Pred id')

phipred = [];
for i = 1:length(uVal)
    phia = [];
    phib = [];
    for j = 1:na
        if i-j>0
            phia = [phia yVal(i-j)];
        else
            phia = [phia 0];
        end
    end

    for j = 1:nb
        if i-j>0
            phib = [phib uVal(i-j)];
        else
            phib = [phib 0];
        end
    end

    phipred = [phipred; phia phib];

end
Phi = [];
for I = 1:length(phi)
     Phi = [Phi; Poly(phipred(I,:),m)];
end

yhat = Phi * theta;

MSE = 0;
for i = 1:length(yhat)
    MSE = MSE + (yhat(i)-yVal(i)).^2;
end
mse = 1/length(yhat) * MSE;


subplot 122
hold on
plot(yhat,'r')
plot(yVal,'k')
hold off
grid;shg
legend('Yhat','Yval')
title('Prediction, MSE = ', mse)

figure
subplot 121 
hold on
plot(yhatId,'m')
plot(yId,'g')
grid;shg
hold off
title('Sim id')

% Simulation
ytilde = [];
phisim = [];
for i = 1:length(uVal)
    phia = [];
    phib = [];
    for j = 1:na
        if i-j>0
            phia = [phia -ytilde(i-j)];
        else
            phia = [phia 0];
        end
    end

    for j = 1:nb
        if i-j>0
            phib = [phib uVal(i-j)];
        else
            phib = [phib 0];
        end
    end

    phisim = [phisim; phia phib];
    ytilde = [ytilde Phi*theta];
end
Phi = [];
for I = 1:length(phi)
     Phi = [Phi; Poly(phisim(I,:),m)];
end

thetaH = linsolve(Phi,yVal);
yHat2 = Phi * thetaH;

MSE2 = 0;
for i = 1:length(yHat2)
    MSE2 = MSE2 + (yHat2(i)-yVal(i)).^2;
end
mse2 = 1/length(yHat2) * MSE2;

subplot 122
hold on
plot(yHat2,'m')
plot(yVal,'g')
hold off
grid;shg
legend('Yhat2-sim','YVal')
title('Simulation, MSE = ', mse2)