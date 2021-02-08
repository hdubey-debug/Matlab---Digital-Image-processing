%Author: Harsh Dubey
%Citation: Worked with Lin Zeng and Gagan, shared ideas about concept and
%code

close all 
clear all
orignal_campus=loadrasteruint16('campus.img',512,512);close;
figure;imagesc(orignal_campus);colormap(gray(2048));title('Orignal image of campus');
figure;
histogram(orignal_campus);
title('Histogram of orignal campus image');%for comparision purposes

%User Input
I = 'I';B = 'B';LPF = 'LPF';HPF = 'HPF';

orignal_campus=double(orignal_campus);

%low pass 1/4 and 1/8
Ideal_Low=freqfilt(orignal_campus,LPF,I,1/4);%Enter Values here
Ideal_Low_rmse = sqrt(immse(Ideal_Low, orignal_campus));
Ideal_Low_2=freqfilt(orignal_campus,LPF,I,1/8);%I just added this to make our analysis easy 
Ideal_Low_rsme2 = sqrt(immse(Ideal_Low_2, orignal_campus));

%butterworth low 2 and 4
butter_low=freqfilt(orignal_campus,LPF,B,1/4,2);%Enter Values here
butter_low_rsme = sqrt(immse(butter_low, orignal_campus));
butter_low_2=freqfilt(orignal_campus,LPF,B,1/4,4);%I just added this to make our analysis easy 
butter_low_2_rsme = sqrt(immse(butter_low_2, orignal_campus));

%ideal high
ideal_high =freqfilt(orignal_campus,HPF,I,1/4,0);%Enter Values here
ideal_high_rsme = sqrt(immse(ideal_high, orignal_campus));
ideal_high2=freqfilt(orignal_campus,HPF,I,1/4,0.15);%I just added this to make our analysis easy 
ideal_high2_rmse = sqrt(immse(ideal_high2, orignal_campus));

%butterworth high
butter_high=freqfilt(orignal_campus,HPF,B,1/4,4,0);%Enter Values here
butter_high_rsme = sqrt(immse(butter_high, orignal_campus));
butter_high_2=freqfilt(orignal_campus,HPF,B,1/4,4,0.15);%I just added this to make our analysis easy 
butter_high_2rmse = sqrt(immse(butter_high_2, orignal_campus));





    