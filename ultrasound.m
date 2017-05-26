%Taken from the manual RV20
Gain=66; % (dB) max 79.9 dB
Delay=3; % (us)

nb_periods=2;  % nb of periods of the emitted sine wave
Ne=64; % nb of array elements
f0=3; % array central frequency (MHz)
esf=80; % emitting sampling frequency (MHz)
amplitude=0.99; % amplitude of emission

nb_samples=9600;
focus_distance=.05; %in meters


travel_distance = .1;
speed_of_sound = 1484;  %m/s in water
travel_time = travel_distance / speed_of_sound;

delay_unit = (1 / (esf * 10^6));
channel_delays = zeros(64);
channel_delays = beamforming(focus_distance, speed_of_sound);
channel_delays = round(channel_delays / delay_unit);
% for i=1:Ne;
%     channel_delays(i) = round (i);
% end; clear i;
delay_max = max(channel_delays);


LecoeurUS('Init_USB'); % init USB
%LecoeurUS('Init',1,64,1); % full init
Nt = round(nb_periods*esf/f0);
t = (0:1:Nt-1)/esf;
s0 = amplitude*sin(2*pi*f0*t)';
% s0=[zeros(1,1); s0; zeros(1,1);]; % first and last points set to 0
Nt=length(s0);
for i=1:Ne;
%   once the wave has finished, just put out zeros (don't do anything)
  post_delay = delay_max - channel_delays(i);
  delayed_s0 = [zeros(1, 1); zeros(1, channel_delays(i))'; s0; zeros(1, post_delay)'; zeros(1,1);];
  wave(:,i) = amplitude*delayed_s0;
% wave(:, i) = amplitude*[zeros(1, 1); s0; zeros(1, 1);];
end; clear i;

figure(1); imagesc(wave);title('emitted wave'); xlabel('channel'); ylabel('sample');
% LecoeurUS('LoadEmSeq',0,Ne,wave); % loads plane waveform in bank 0
% 
% Nboards=Ne/8; % nb of boards
% address=0; % acquisition starting address
% bsf=80; % base sampling freq. (MHz)
% rsf=80; % receiver sampling freq. (MHz)
% 
% 
% for j=1:Ne; 
%     LecoeurUS('Gain',Gain,j);
% end; clear j;
% 
% LecoeurUS('Upload_Seq_Program',hex2dec('C000')+1,0); % trigger out, loop=1
% LecoeurUS('Upload_Seq_Duration', nb_samples+Delay*bsf*2);
% 
% for i=1:Nboards;
%   LecoeurUS('Upload_Seq_Num_Width',i,nb_samples);
%   LecoeurUS('Upload_Seq_Pulser_Seq',i,0); % using bank 0
%   LecoeurUS('Upload_Seq_Num_Delay',i,Delay*bsf);
% end;clear i;
% 
% LecoeurUS('Exe_Sequencer',address, 0); % execution
% 
% 
% 
% 
% for j=1:Ne;
%   RF(:,j)=LecoeurUS('Read_Memory',nb_samples,j,address,0);
% end;
% figure(3);imagesc(abs(hilbert(RF)));title('acquisition using micro-sequencer');
% xlabel('channel'); ylabel('sample');
% clear;
