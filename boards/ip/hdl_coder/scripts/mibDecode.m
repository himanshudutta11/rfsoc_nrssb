function [mibStruct, ncellid, ssbIndex, bchCRC] = mibDecode(ssbgrid, NID2, Lmax)
% Copyright 2023 The MathWorks, Inc.

    % Extract the received SSS symbols from the SS/PBCH block
    sssIndices = nrSSSIndices;
    sssRx = nrExtractResources(sssIndices,ssbgrid);
    
    % Generate candidate SSS sequences to correlate against
    Ncandidates = 336;
    candidates  = zeros(127,Ncandidates);
    
    for c=1:Ncandidates
        candidates(:,c) = nrSSS(3*(c-1)+NID2);
    end
    
    % The SSS reference sequences each have energy of 127.
    % Normalize the result as if the SSS sequences had unit energy.
    correlation = abs(sssRx.'*candidates / sqrt(127)).^2;
    
    [~,kmax] = max(correlation);
    NID1 = kmax-1;
    ncellid = (3*NID1) + NID2;
    
    % Calculate PBCH DM-RS indices
    dmrsIndices = nrPBCHDMRSIndices(ncellid);
    
    % Perform channel estimation using DM-RS symbols for each possible DM-RS
    % sequence and estimate the SNR
    dmrsEst = zeros(1,8);
    for ibar_SSB = 0:7
        refGrid = zeros([240 4]);
        refGrid(dmrsIndices) = nrPBCHDMRS(ncellid,ibar_SSB);
        [hest,nest] = nrChannelEstimate(ssbgrid,refGrid,'AveragingWindow',[0 1]);
        dmrsEst(ibar_SSB+1) = 10*log10(mean(abs(hest(:).^2)) / nest);
    end
    
    % Record ibar_SSB for the highest SNR
    ibar_SSB = find(dmrsEst==max(dmrsEst)) - 1;
    
    nrbSSB = 20;
    refGrid = zeros([nrbSSB*12 4]);
    refGrid(dmrsIndices) = nrPBCHDMRS(ncellid,ibar_SSB);
    refGrid(sssIndices) = nrSSS(ncellid);
    [hest,nest,hestInfo] = nrChannelEstimate(ssbgrid,refGrid,'AveragingWindow',[0 1]);
    
    % Extract the received PBCH symbols from the SS/PBCH block
    [pbchIndices,pbchIndicesInfo] = nrPBCHIndices(ncellid);
    pbchRx = nrExtractResources(pbchIndices,ssbgrid);
    
    % Configure 'v' for PBCH scrambling according to TS 38.211 Section 7.3.3.1
    % 'v' is also the 2 LSBs of the SS/PBCH block index for L_max=4, or the 3
    % LSBs for L_max=8 or 64.
    if Lmax == 4
        v = mod(ibar_SSB,4);
    else
        v = ibar_SSB;
    end
    
    % PBCH equalization and CSI calculation
    pbchHest = nrExtractResources(pbchIndices,hest);
    [pbchEq,csi] = nrEqualizeMMSE(pbchRx,pbchHest,nest);
    Qm = pbchIndicesInfo.G / pbchIndicesInfo.Gd;
    csi = repmat(csi.',Qm,1);
    csi = reshape(csi,[],1);
    
    % PBCH demodulation
    pbchBits = nrPBCHDecode(pbchEq,ncellid,v,nest);
    pbchBits = pbchBits .* csi;
    polarListLength = 8;
    [bchPayload,bchCRC] = nrBCHDecode(pbchBits,polarListLength,Lmax,ncellid);
    [mibStruct,hrf,ssbIndex] = mibParse(bchPayload,v,Lmax);
    
end

%% mibParse subfunction
% Parses the PBCH payload to get MIB parameters
function [mib,hrf,ssbIndex] = mibParse(pbchPayload,v,Lmax)
    trblk = pbchPayload(1:24); %BCCH-BCH-Message
    sfn4lsb = pbchPayload(25:28); %SFN 4 LSBs
    hrf = pbchPayload(29); %HRF 
    
    if Lmax == 64
        commonSCSs = [60 120];
        KssbMsb = 0;
        ssbIndex3Msb = (bit2int(pbchPayload(30:32),3)' * 8);
    else
        commonSCSs = [15 30];
        KssbMsb = pbchPayload(30);
        ssbIndex3Msb = 0;
    end

    mib.NFrame = bit2int([trblk(2:7); sfn4lsb] ,length([trblk(2:7); sfn4lsb]))';
    mib.SubcarrierSpacingCommon = commonSCSs(trblk(8) + 1);
    mib.k_SSB = KssbMsb * 16 + bit2int(trblk(9:12),4)';%length(trblk(9:12))=4
    mib.DMRSTypeAPosition = 2 + trblk(13);
    mib.PDCCHConfigSIB1 = bit2int(trblk(14:21),8)';%length(trblk(14:21))=8
    mib.CellBarred = trblk(22);
    mib.IntraFreqReselection = trblk(23);
    
    ssbIndex = ssbIndex3Msb + v;
end