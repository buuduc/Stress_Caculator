clc
clear all
fprintf('----------------------------------\n')
%%nhap input cua bai toan
stress=[10 15 0; 15 0 0;0 0 -25] % Tensor ung suat
n=[0 0 -sqrt(3)/2] % ma tran nghieng cua mat phang
poisson=0.2
E=2e9
% kiem tra ben theo thuyet ben Mohr
sigma_n=10^3
sigma_k=sigma_n/10
%kiem tra ben theo thuyet ben von Mises
sigma=15000
%%
fprintf('----------------------------------\n')
fprintf('----------------------------------\n')

%% Bat dau giai
n=n';
fprintf('vec to ung suat tren mat nghieng: \n')
px=stress(1,:)*n;
py=stress(2,:)*n;
pz=stress(3,:)*n;
fprintf('T1: %d   T2: %d   T3: %d \n \n ',double(px),double(py),double(pz))
fprintf('Ung suat phap tren mat nghieng \n')
phap=px*n(1)+py*n(2)+pz*n(3);
disp(phap)
fprintf('Ung suat tiep tren mat nghieng \n')
tiep=sqrt(px^2+py^2+pz^2-phap^2);
disp(tiep)
fprintf('----------------------------------\n')
fprintf('1.cac ung suat chinh \n ')
fprintf('- Cac bat bien cua tensor ung suat: \n')
t1= det(stress([1,3],[1,3]));
t2=det(stress([1,2],[1,2]));
t3=det(stress([2,3],[2,3]));
% stress([1,3],[1,3]);
% stress([2,3],[2,3]);
% stress([1,2],[1,2]);
I1=stress(1,1)+stress(2,2)+stress(3,3);
I2=t1+t2+t3;
I3=det(stress);
fprintf('I1= %d    I2= %d    I3= %d  \n \n',round(I1,2),round(I2,2),round(I3,2))
fprintf('- Cac ung suat chinh tinh tu phuong trinh bac ba: \n')
sigma=sort(round(roots([1 -I1 +I2 -I3]),2),'descend')';
disp(sigma)
fprintf('2. Cac phuong chinh: \n')
syms x y z
for k=1:3
    fprintf('- Phuong chinh thu %d: \n He phuong trinh co dang: \n',k)
    f=stress-eye(3).*sigma(k);
    disp(round(f,2));
%     [row, col]=find(f==0);
%     f(mode(row),:)=[];
    f1=f(1,1)*x+f(1,2)*y+f(1,3)*z==0;
    f2=f(2,1)*x+f(2,2)*y+f(2,3)*z==0;
    f3=f(3,1)*x+f(3,2)*y+f(3,3)*z==0;
    f4=x^2+y^2+z^2==1;
%     disp(f1);
%     disp(f2);
%     disp(f3);
%     disp(f4);
    result=solve([f1,f2+f3,f4],[x y z]);
    fprintf('giai he phuong trinh tren ta duoc phuong chinh thu %d \n',k)
    disp(round(double([result.x result.y result.z]),2))
end
fprintf('----------------------------------\n')
fprintf('Vong tron Mohr ung suat: \n')
a=sigma(1);
b=sigma(2);
c=sigma(3);
fprintf('C1: ( %d ,%d ), R1= %d  \n',round((b+c)/2,2),0,(b-c)/2)
fprintf('C2: ( %d ,%d ), R2= %d  \n',round((a+c)/2,2),0,(a-c)/2)
fprintf('C3: ( %d ,%d ), R3= %d  \n',round((b+a)/2,2),0,(a-b)/2)
fprintf('----------------------------------\n')
fprintf('ung suat phap trung binh: \n')
p=(1/3)*(sigma(1)+sigma(2)+sigma(3));
disp(p);
fprintf('tensor ung suat cau (ung suat thuy tinh)\n')
cau=diag([p p p]);
disp(round(cau,2))
fprintf('tensor ung suat lech \n')
lech=stress-cau;
disp(lech)
fprintf('----------------------------------\n')
fprintf('cac ung suat chinh cua tensor ung suat lech: \n')
fprintf('S1 : %d  S2: %d  S3: %d \n',round([a-p b-p c-p],2))
fprintf('----------------------------------\n')
tuongduong=a-(sigma_k/sigma_n)*c;
fprintf('ung suat tuong duong theo thuyet ben Mohr: \n')
disp(tuongduong)
fprintf('Gioi han ben cua vat lieu:\n')
fprintf('- Gioi han ben keo: %d \n- Gioi han ben nen: %d \n',sigma_k,sigma_n)
if tuongduong <= sigma_k
    fprintf('=> Diem thoa ben \n')
else
    fprintf('=> Diem khong thoa ben \n')
end
fprintf('----------------------------------\n')
fprintf('Gioi han ben tuong duong cua he theo thuyet ben von-Mises la \n')
sigma_td=sqrt(a^2+b^2+c^2-a*b-b*c-a*c);
fprintf('sigma_tuongduong= %d \n',sigma_td)
if sigma_td <= sigma
    fprintf('=> Diem thoa ben \n')
else
    fprintf('=> Diem khong thoa ben \n')
end
fprintf('----------------------------------\n')
fprintf('Bien dang dai theo cac phuong chinh: \n')
E1=(1/E)*(a-poisson*(b+c));
E2=(1/E)*(b-poisson*(a+c));
E3=(1/E)*(c-poisson*(a+b));
fprintf('E1: %d  E2: %d  E3: %d \n \n',[E1 E2 E3])
Ex=(1/E)*(stress(1,1)-poisson*(stress(2,2)+stress(3,3)));
Ey=(1/E)*(stress(2,2)-poisson*(stress(1,1)+stress(3,3)));
Ez=(1/E)*(stress(3,3)-poisson*(stress(1,1)+stress(2,2)));
fprintf('Bien dang dai theo cac phuong x, y, z: \n ')
fprintf('Ex: %d  Ey: %d  Ez: %d \n \n',[Ex Ey Ez])
fprintf('Bien dang the tich: \n')
fprintf('Ev : %d \n' ,Ex+Ey+Ez)

