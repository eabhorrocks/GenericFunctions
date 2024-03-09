function indexCell = downsampToMatch(varargin)

resolution=0;
nReps = 1;
validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);

done = false;
charFlag = false; % check if char inputt arg has happened yet
iarg=1;
while ~done
    if isnumeric(varargin{iarg}) % input data
        if charFlag
            error('data inputs must come before (Name,Value) pairs')
        end
        X{iarg} = varargin{iarg};

    elseif ischar(varargin{iarg}) % Name, Value pair
        charFlag=true;
        if strcmp(varargin{iarg},'resolution')
            resolution = varargin{iarg+1};
            iarg=iarg+1; % skip next arg
            if ~validScalarPosNum(resolution)
                error('''resolution'' must be a positive scalar')
            end

        elseif strcmp(varargin{iarg},'nReps')
            nReps = varargin{iarg+1};
            iarg=iarg+1; % skip next arg
            if ~(isreal(nReps) && rem(nReps,1)==0 && nReps>0)
                error('''nReps'' must be a positive integer')
            end

        else
            error(' Valid (Name,Value) pairs are ''resolution'' and ''nReps''');

        end
    end
    iarg=iarg+1;
    if iarg>numel(varargin)
        done=true;
    end

end

if resolution==0 % if no resolution provided, use histcounts default
    [~, edges] = histcounts([x,y]);
    resolution=edges(2)-edges(1);
end

minVal = min(cellfun(@min, X));
maxVal = max(cellfun(@max, X));

minValRound = floor(minVal) + floor( (minVal-floor(minVal))/resolution) * resolution;
maxValRound = floor(maxVal) + ceil( (maxVal-floor(maxVal))/resolution) * resolution;

for ii = 1:numel(X)
    Xcount(:,ii) = histcounts(X{ii},minValRound:resolution:maxValRound);
    Xdisc{:,ii} = discretize(X{ii},minValRound:resolution:maxValRound);
end

minCounts = min(Xcount,[],2);

indexCell = cell(numel(X),nReps);
for irep=1:nReps
    for ival = 1:numel(minCounts)
        nSamps = minCounts(ival);

        for ii=1:numel(X)
            allVals = find(Xdisc{:,ii}==ival);
            samp_idx = randsample(numel(allVals),nSamps);
            indexCell{ii,irep} = cat(1,indexCell{ii,irep},allVals(samp_idx));
        end
    end
end

end