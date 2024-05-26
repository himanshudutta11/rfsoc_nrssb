function correlationCoefs = getCorrelationCoeffs(Nfft)
% Copyright 2023 The MathWorks, Inc.

    correlationCoefs(:,1) = conj(flipud(timeDomainPSS_5G(0,Nfft)));
    correlationCoefs(:,2) = conj(flipud(timeDomainPSS_5G(1,Nfft)));
    correlationCoefs(:,3) = conj(flipud(timeDomainPSS_5G(2,Nfft)));

end

function p = timeDomainPSS_5G(NCellID,FFTLength)
    % Generate time-domain PSS sequence for 5G NR
    % Inputs:
    %    NCellID: Cell ID (0...1007)
    %       nFFT: FFT length (128...4096)
    % Outputs:
    %    p: Column vector of time domain samples containing PSS.
    
    %   Copyright 2019 The MathWorks, Inc.
    
    validateattributes(NCellID,{'numeric'},{'scalar','>=',0,'<=',1007},'timeDomainPSS','NCellID');
    validateattributes(FFTLength,{'numeric'},{'scalar','>=',128,'<=',4096},'timeDomainPSS','FFTLength');
    
    ifftGrid                          = zeros(FFTLength,1);
    gridOffset                        = -(240-FFTLength)/2;
    ifftGrid(nrPSSIndices+gridOffset) = nrPSS(NCellID);
    
    % Create time domain sequence
    p = ifft(fftshift(ifftGrid));
    
    % Normalize so that sequence has unit energy.
    p = p/sqrt(p'*p);
    
end