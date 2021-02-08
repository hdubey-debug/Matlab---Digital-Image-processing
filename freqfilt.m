%Author: Harsh Dubey
%Citation: Worked with Lin Zeng and Gagan, shared ideas about concept and
%code

function output1 = freqfilt(varargin)
%User Input.
I = 'I';B = 'B';LPF = 'LPF';HPF = 'HPF';
Image=varargin{1};filter=varargin{2};type=varargin{3};cutoffFreq=varargin{4};count=size(varargin);
%check for count
    if(count(:,2)==5)
        if(varargin{5}>=1)
        order=varargin{5};alpha=0;%if 5th cell == number>1 then order = cell 5
        else
        order=0;alpha=varargin{5};%else order is 0 and alpha is cell
        end
    elseif (count(:,2)==6)%count = 6 then order = 5 an dalpha = 6
    order=varargin{5};
    alpha=varargin{6};
    else
        order=0;alpha=0;%else order and alpha = 0
    end
    output1 = actualFilter(Image,filter,type,cutoffFreq,order,alpha);%read user input

    function output = actualFilter(Image,filter,type,cutoffFreq,order,alpha)%perform filtering 

    %%ILPF  
    if (strcmp(filter,'LPF')&&strcmp(type,'I'))%if user wants ILPF
        
%DR. Helder's code     
%1024by1024 ILPF
ilpf = zeros(1024);
for i = 256:768
    for j = 256:768
        if( sqrt( (i-512)^2 + (j-512)^2) ) < (cutoffFreq*512) 
            ilpf(i,j) = 1;
        end
    end
end
%DR. Helder's code     
    %Zero Padding
    for a = 512:1024
    for b = 512:1024
    Image(a,b) = 0;
    end
    end
    
    %DR. Helder'code
    Orignal_FFT=log10(1+abs(((fftshift(fft2(Image))))));
    figure;
    imagesc(Orignal_FFT);colormap(gray(2048));
    title('FFT original image'), axis square
    
    figure;
    mesh(ilpf);
    title('Ideal Lowpass Filter transfer function'),axis square;
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 );
    figure;imagesc(ilpf);title('Ideal Lowpass Filter frequency domain'),colormap(gray(2048));
    axis square;
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 );
    OutIdealLPF = real(ifft2((abs(fftshift(fftshift(fft2(Image)).*ilpf))).*(exp(1i.*angle(fft2(Image))))));
    
    figure,
    imagesc(OutIdealLPF),colormap(gray(2048)),
    title('Ideal LPF with zero padding and without cropping'), axis square;
    %DR. Helder's Code
    
    %Multiplyign in frequency domain for thsi filter
    OutIdealLPF = real(ifft2((abs(fftshift(fftshift(fft2(Image)).*ilpf))).*(exp(1i.*angle(fft2(Image))))));
    output = OutIdealLPF;
    ngirlFilter=log10(1+abs(((fftshift(fft2(output))))));%to enchance the low end of values
    
    figure;
    imagesc(ngirlFilter);colormap(gray(2048));%display teh FFT
    title('FFT of image'), axis square;
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 );
    OutIdealLPF(513:1024,:) = [] ;%Cropping from 1024 to 513
    OutIdealLPF(:,513:1024) = [] ;output = OutIdealLPF;%Cropping from 1024 to 513
    figure;
    imagesc(output),colormap(gray(2048)),
    title('Ideal LPF of the image'), axis square;
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 );
    
    %Butherworth LPF
    elseif (strcmp(filter,'LPF')&&strcmp(type,'B'))
  %DR. Helder's code 
    Blpf = zeros(1024);
for i = 1:1024
    for j = 1:1024
        Blpf(i,j) = 1/ (1 + ((sqrt( (i-512)^2 + (j-512)^2))/(cutoffFreq*512))^(2*order) ); 
    end
end
   %DR. Helder's code
    %Doing Zero padding
    for a = 512:1024
    for b = 512:1024
        Image(a,b) = 0;
    end
    end
   
    %Multiplying in frequency domain
    BLPF_out = real(ifft2((fftshift(fftshift(fft2(Image)).*Blpf))));
    
    %DR. Helder's code
    figure, imagesc(Blpf),colormap(gray(2048)),title('Butterworth Lowpass Filter frequency domain'),axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 )
    text(150,55,['Filter Order = ', num2str(order)],'Color','yellow','FontSize',14 )
    
    output = BLPF_out;
    
    ngirlFilter=log10(1+abs(((fftshift(fft2(output))))));
    figure;imagesc(ngirlFilter);colormap(gray(2048));title('FFT of Butterworth'), axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 )
    text(150,55,['Filter Order = ', num2str(order)],'Color','yellow','FontSize',14 )
    %Croppign Image
    BLPF_out(513:1024,:) = [] ;
    BLPF_out(:,513:1024) = [] ;
    output = BLPF_out;
    
    figure;imagesc(output),colormap(gray(2048)),title('Butterworth Lowpass Filtered image'), axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 )
    text(150,55,['Filter Order = ', num2str(order)],'Color','yellow','FontSize',14 )
    %DR. Helder's code
    
    %%IHPF
    %DR. Helder's code
    elseif (strcmp(filter,'HPF')&&strcmp(type,'I'))
    ilpf = ones(1024);
for i = 256:768
    for j = 256:768
        if( sqrt( (i-512)^2 + (j-512)^2) ) < (cutoffFreq*512) 
            ilpf(i,j) = alpha;
        end
    end
end
  %DR. Helder's code      
    for i = 512:1024
    for j = 512:1024
        Image(i,j) = 0;
    end
    end
    
    %FFT of orignal Image
    Orignal_FFT=log10(1+abs(((fftshift(fft2(Image))))));
    figure;imagesc(Orignal_FFT);colormap(gray(2048));title('FFT of the original image'), axis square
    
    figure,imagesc(ilpf),colormap(gray(2048)),title('Ideal Highpass Filter transfer function'),axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 );
    text(150,55,['alpha = ', num2str(alpha)],'Color','yellow','FontSize',14 )
   
    %Outputing Real values for LPF
    LPF_Output = real(ifft2((abs(fftshift(fftshift(fft2(Image)).*ilpf))).*(exp(1i*angle(fft2(Image))))));
    %Plot
    figure,imagesc(LPF_Output),colormap(gray(2048)),title('Ideal HP filered image'), axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 )
    text(150,55,['alpha = ', num2str(alpha)],'Color','yellow','FontSize',14 )
    output = LPF_Output;
    
    %n-girl processing
    ngirlFilter=log10(1+abs(((fftshift(fft2(output))))));
    figure;imagesc(ngirlFilter);colormap(gray(2048));title('FFT of the IHP Filtered image '), axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 );
    text(150,55,['alpha = ', num2str(alpha)],'Color','yellow','FontSize',14 )
    LPF_Output(513:1024,:) = [] ;%Crop the image becasue zero paddng
    LPF_Output(:,513:1024) = [] ;%Crop the image becasue zero paddng
    figure,imagesc(LPF_Output),
    colormap(gray(2048)),
    title('Ideal HP filtered image'), axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 );
    text(150,55,['alpha = ', num2str(alpha)],'Color','yellow','FontSize',14 )
    output=LPF_Output;

    %%BHPF
    elseif (strcmp(filter,'HPF')&&strcmp(type,'B'))
%1024by1024 BHPF
%Taken from Dr. Helder's code
    Blpf = ones(1024);
    if (0<alpha && alpha<1)
for i = 1:1024
    for j = 1:1024
        
        Blpf(i,j) = 1/ (1 + ((cutoffFreq*512)/(sqrt( (i-512)^2 + (j-512)^2)))^(2*order) );    
        if (0<Blpf(i,j)&&Blpf(i,j)<1)
        Blpf(i,j)=alpha+Blpf(i,j);
        else
        Blpf(i,j) = 1/ (1 + ((cutoffFreq*512)/(sqrt( (i-512)^2 + (j-512)^2)))^(2*order) );  
        end
    end
end
    else
       for i = 1:1024
    for j = 1:1024
        Blpf(i,j) = 1/ (1 + ((cutoffFreq*512)/(sqrt( (i-512)^2 + (j-512)^2)))^(2*order) ); 
    end
       end
    end
    %Dr. Helder's code
    Blpf(512,512)= 1;
    %Zero padding
    for a = 512:1024
    for b = 512:1024
        Image(a,b) = 0;
    end
    end
   
    %Multipying in frequency domain
    BLPF_out = real(ifft2((abs(fftshift(fftshift(fft2(Image)).*Blpf))).*((exp(1i*angle(fft2(Image)))))));
    %Dr. Helder's code
    figure, 
    imagesc(Blpf),colormap(gray(2048)),
    title('Butterworth Highpass Filter'),axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 )
    text(150,55,['Filter Order = ', num2str(order)],'Color','yellow','FontSize',14 )
    text(150,85,['alpha = ', num2str(alpha)],'Color','yellow','FontSize',14 )
    
    figure,imagesc(BLPF_out),colormap(gray(2048)),title('Butterworth Highpass Filtered image'), axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 )
    text(150,55,['Filter Order = ', num2str(order)],'Color','yellow','FontSize',14 )
    text(150,85,['alpha = ', num2str(alpha)],'Color','yellow','FontSize',14 )
    output = BLPF_out;
    %Dr. Helder's code
    %display in log scale
    ngirlFilter=log10(1+abs(((fftshift(fft2(output))))));
    figure;
    imagesc(ngirlFilter);colormap(gray(2048));
    title('FFT of the BHP Filtered image'), axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 );
    text(150,55,['Filter Order = ', num2str(order)],'Color','yellow','FontSize',14 );
    text(150,85,['alpha = ', num2str(alpha)],'Color','yellow','FontSize',14 );
    BLPF_out(513:1024,:) = [] ;
    BLPF_out(:,513:1024) = [] ;
    output=BLPF_out;
    figure;imagesc(output),
    colormap(gray(2048)),
    title('Butterworth Highpass Filter of the image'), axis square
    text(150,25,['Cutoff Frequency = ', num2str(cutoffFreq)],'Color','yellow','FontSize',14 )
    text(150,55,['Filter Order = ', num2str(order)],'Color','yellow','FontSize',14 )
    text(150,85,['alpha = ', num2str(alpha)],'Color','yellow','FontSize',14 )
    
    end
    end
end