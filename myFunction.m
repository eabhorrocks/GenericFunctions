function myFunction(varargin)
    % Create an instance of the inputParser class.
    p = inputParser;

    % Define validation functions
    validateResolution = @(x) isnumeric(x) && isscalar(x) && x > 0;

    % Add optional 'Name' 'Value' pair for resolution
    addParameter(p, 'resolution', 1, validateResolution);

    % Check if there are any 'Name' 'Value' pairs
    if mod(length(varargin), 2) ~= 0
        error('Name-Value pairs must be in pairs');
    end

    % Parse the 'Name' 'Value' pairs
    for i = 1:2:length(varargin)
        if ischar(varargin{i})
            addParameter(p, varargin{i}, varargin{i+1});
        else
            error('Expected a string scalar or character vector for the parameter name.');
        end
    end

    % Parse the inputs without the 'Name' 'Value' pairs
    parse(p, varargin{~cellfun(@ischar, varargin)});

    % Access the parsed resolution
    resolution = p.Results.resolution;
    disp(['Resolution: ', num2str(resolution)]);

    % Access and process other parsed inputs
    for i = 1:length(varargin)
        if ~ischar(varargin{i})
            arg = varargin{i};
            disp(['Argument ', num2str(i), ': ', num2str(arg)]);
        end
    end
end
