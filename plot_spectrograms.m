%This script generates aligned spectrograms without the decimated data
%This may be potentially slow, but since is only calculating the
%spectrogram for small parts of the data it might be ok

%%%%%
%%% prepare matlab
%%%%%
%set(gcf,'Visible','off');
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultaxesfontSize',8)
set(gcf,'color','w');
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read the data files
root_path = ['/home/leon/Data/Penn/Oct_1'];
time_stamps_file = [root_path '/data_click'];
data_file = [root_path '/data'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load data file
fid = fopen(time_stamps_file,'r');
fseek(fid, 0, 'bof');
clickTime = fread(fid, Inf, 'uint64', 4);
fclose(fid);
 
fid = fopen(data_file,'r');
fseek(fid, 8, 'bof');
force = fread(fid, Inf, 'float', 8+4*19);
 
fseek(fid, 8+4*4, 'bof');
ch1 = fread(fid, Inf, 'float', 4*19+8);
fseek(fid, 8+5*4, 'bof');
ch2 = fread(fid, Inf, 'float', 4*19+8);
 
fseek(fid, 8+10*4, 'bof');
ch7 = fread(fid, Inf, 'float', 4*19+8);
fseek(fid, 8+11*4, 'bof');
ch8 = fread(fid, Inf, 'float', 4*19+8);
 
fclose(fid);
 
hFig = figure(1);
 
%set(gcf,'PaperPositionMode','auto');
set(hFig, 'Position', [0 0 1024 860]);
 
samplingRate = 25000;
 
hold off 
 
for i=1:30,
	plot((-samplingRate*1.5:samplingRate*2.0)/samplingRate,force(clickTime(i)-samplingRate*1.5:clickTime(i)+samplingRate*2));
	hold on
end
 
%myaa([4 2],'force.png');
 
hold off
 
figure
 
[S,F,T,P] = spectrogram(ch2(clickTime(1)-samplingRate*1.5:clickTime(1)+samplingRate*2.0)-ch1(clickTime(1)-samplingRate*1.5:clickTime(1)+samplingRate*2.0), hann(samplingRate/4), samplingRate/4-5, samplingRate/4, samplingRate);
M = P/30.0;
 
for i=2:30,
    i
    [S,F,T,P] = spectrogram(ch2(clickTime(i)-samplingRate*1.5:clickTime(i)+samplingRate*2.0)-ch1(clickTime(1)-samplingRate*1.5:clickTime(1)+samplingRate*2.0), hann(samplingRate/4), samplingRate/4-5, samplingRate/4, samplingRate);
    M = M + P/30.0;
end
imagesc(T, F, 20*log10(M))
axis xy, colormap(jet), ylabel('Frequency')
colormap(flipud(jet))
 
imagesc(T-1.5, F, 20*log10(M))
axis xy, colormap(flipud(jet)), ylabel('Frequency (Hz)'),xlabel('Time (seconds)')
hold on
plot([0 0], [0 max(F)], '-.k')
colorbar