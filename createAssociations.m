function [delays, dex, crossScores, xcorVal] = ...
    createAssociations(app,detectionsRef, detections,idx,file_listTable, hydDelay)

ref_chan = str2num(app.ReferenceChannelDropDown.Value);
fs = app.fs;
noisePadLength =   app.NoisePadLengthEditField.Value; % seconds on either side of the even to pad

% convert noise buffer from seconds to samples
noisebuffpts = round(noisePadLength * fs);
% get max delay
max_delay = max(hydDelay);
% to acquire the data needed for all calculations to follow
event_pad = max(noisebuffpts, max_delay);

% duration is always 2 sec for NN output
totalpts = ceil(2 * fs) + (2 * event_pad);

%% use the extent of the event to bandlimit
flo = detectionsRef.LowFreq_Hz_(idx);
fhi = detectionsRef.HighFreq_Hz_(idx);

num_chan=max(detections.Channel)-min(detections.Channel)+1;
delays = nan(1, max(detections.Channel));
dex = delays;
crossScores = dex;
arrivalArray = dex;

% convert noise buffer from seconds to samples
noisebuffpts = round(noisePadLength * fs);
callStartSamp = round(detectionsRef.BeginTime_s_(idx)*fs);
callStopSamp=   round(detectionsRef.EndTime_s_(idx)*fs);

% Pull out the part of the soundstream assoicated with the padding time
aa = (((callStopSamp+event_pad)/fs)>detections.BeginTime_s_ & detections.Channel~=ref_chan);
aa1 = (detections.EndTime_s_>((callStartSamp-event_pad)/fs)& detections.Channel~=ref_chan);

inxCheck=find(aa.*aa1);

% If there are any detections in the region load
if ~isempty(inxCheck)
    
    % Following KAC
    % I. Get RL of reference event
    %   1) get event plus BG noise pad
    %   2) separate event chunk from BG noise chunk
    %   3) calculate event STFT
    %   4) calculate noise STFT to get NSE
    %   5) de-noise event STFT
    %   6) calculate RL from de-noised event STFT
    
    % KAC code runs associations for primary and all secondary channels.
    % Returns best correlation and correlations scores for all (regardless
    % of whether there was a detection)
    [xcorVal] = KACRevisedXcorr(app, file_listTable,hydDelay, noisebuffpts, ...
        ref_chan, num_chan, flo, fhi, callStartSamp, callStopSamp, fs);
    
    
    % Get the matching calls
    detectionsSub = detections(inxCheck,:);
    chanDetections = unique(detectionsSub.Channel);
    
    % Compare the association times with the detections on the secondary
    % channels. If there is a detection within 0.75 sec of the association
    % time (from KAC) consider the detection associated wtihe the primary
    % call.
    for jj =1:length(chanDetections)
        
        % Which channel?
        currChan = chanDetections(jj);
        
        % pull all detections on the secondary channel
        detRel =detectionsSub(detectionsSub.Channel==currChan,:);
        
        
        % compare the max cross correlation time to the detection output to
        % determine if it's associated with another detection
        expectedPeak = xcorVal.event_time(currChan);
        
        % if any of the detections on that channel are within 0.75 sec of
        % he expected peak, then add them
         [timeDiff, indexDiff] =  min(abs(expectedPeak-detRel.BeginTime_s_));
        
        
        % If the observed time is within the max delay, then update
        if timeDiff<1.5
            delays(currChan)=xcorVal.event_time(currChan)-callStartSamp/fs;
            crossScores(currChan)=xcorVal.all_pk_xcorr_norm(currChan);
            dex(currChan)=detRel.Selection(indexDiff);
        end
        
        
    end
    
    
else
    xcorVal=[];
    
end



dex(:,ref_chan)=detectionsRef.Selection(idx);



end