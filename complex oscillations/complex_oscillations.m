% se vizualizeaza interferenta
clear; close all; clc; % igiena
m1=1; m2=m1; % masele caracteristice portiunilor (1) si (2) ale mediului
k1=100000; k2=k1; % constantele elastice corespunzatoare portiunilor (1) si (2)
P=500; % numarul momentelor de timp
N=100; % numarul oscilatorilor (numarul elementelor de pozitie)
N1=40; % numarul oscilatorilor din portiunea (1)
m=m2*ones(1,N); % m2 peste tot; apoi suprascriu cu m1 in regiunea (1)
m(1:N1)=m1; % definitia masei cu o discontinuitate de la N1 la N1+1
k=k2*ones(1,N);
k(1:N1)=k1; % definitia masei cu o discontinuitate de la N1 la N1+1
t0=0;
T10=2*pi*sqrt(m1/k1); T20=2*pi*sqrt(m2/k2); % perioade caracteristice portiunilor
Tmax=max(T10,T20);
tf=15*Tmax; % timpul final
t=linspace(t0,tf,P); dt=t(2)-t(1); % sirul momentelor de timp si pasul temporal
eta_trecut=zeros(1,N); % conditie initiala pentru recurenta (primul moment)
eta_prezent=eta_trecut; % conditie initiala (al doilea moment)
eta_viitor=eta_prezent; % prealocare pentru eta
A=1; % micrometri; amplitudinea perturbatiei
eta_stanga=zeros(1,P); % conditie la frontiera stanga
%eta_stanga(t<T10)=A*sin(2*pi*t(t<T10)/T10);
eta_stanga(t<T10/4)=A;
eta_dreapta=zeros(1,P); % conditie la frontiera dreapta
eta_dreapta(t<T10/4)=-A;
figure(1);
for i=2:P-1 % ciclul de timp
    hold off;
    plot(1:N,eta_prezent,'-r'); hold on;
    xlabel('Pozitia'); ylabel('Elongatia'); grid;
    axis([0 N+1 -A +A]);
    Film(i)=getframe; % getframe();
    for j=2:N-1
        eta_viitor(j)=2*eta_prezent(j)-eta_trecut(j)+dt^2/m(j)*...
            (k(j)*(eta_prezent(j+1)-eta_prezent(j))+k(j-1)*(eta_prezent(j-1)-eta_prezent(j)));
    end
    eta_viitor(1)=2*eta_prezent(1)-eta_trecut(1)+dt^2/m1*...
            (k1*(eta_prezent(2)-eta_prezent(1))+k1*(eta_stanga(i)-eta_prezent(1)));
    eta_viitor(N)=2*eta_prezent(N)-eta_trecut(N)+dt^2/m2*...
            (k2*(eta_dreapta(i)-eta_prezent(N))+k2*(eta_prezent(N-1)-eta_prezent(N)));
    eta_trecut=eta_prezent; eta_prezent=eta_viitor;    
end