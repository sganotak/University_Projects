function [ DC_L,DC_C,AC_L,AC_C ] = decodeDHTheader( dht )
%input
%dht=the dht header
%output
%DC_L=Decoded DC Luminance Huffman Table
%DC_C=Decoded DC Chrominance Huffman Table
%AC_L=Decoded AC Luminance Huffman Table
%AC_C=Decoded AC Chrominance Huffman Table
index=1;

while index<length(dht)
    if dht(index)==0 %DC Luminance table
        dc_luminance_nrcodes=dht(index:index+16);% DC_L frequencies
        index=index+17; 
        dc_luminance_values=dht(index:index+11); %DC_L values
        index=index+12;
    elseif dht(index)==1 %DC Chrominance table
        dc_chrominance_nrcodes=dht(index:index+16);% DC_C frequencies
        index=index+17;
        dc_chrominance_values=dht(index:index+11);%DC_C values
        index=index+12;
    elseif dht(index)==16 %AC Luminance Table
        ac_luminance_nrcodes=dht(index:index+16);% AC_L frequencies
        index=index+17; 
        ac_luminance_values=dht(index:index+161);% AC_L values
        index=index+162;
    elseif dht(index)==17 %AC Chrominance Table
        ac_chrominance_nrcodes=dht(index:index+16);%AC_C frequencies
        index=index+17; 
        ac_chrominance_values=dht(index:index+161);%AC_C values
        index=index+162;
    end
end

%Find Huffman size values for DC table 1
p = 0;
    for l = 1:16
        for i = 1:dc_chrominance_nrcodes(l+1)
            huffsize(p+1) = l;
            p = p + 1;
        end
    end

    huffsize(p+1) = 0;
    lastp = p;

    %Decode the symbol sequence for DC table 1
    code = 0;
    si = huffsize(0+1);
    p = 0;
    while huffsize(p+1) ~= 0
        while huffsize(p+1) == si                
            huffcode(p+1) = code;
            p = p + 1;
            code = code + 1;
        end
        code = bitshift(code, 1);
        si = si + 1;
    end

    %Join Huffman size+decoded symbols on single matrix
    for p = 0:lastp-1
        DC_matrix1(dc_chrominance_values(p+1)+1, 0+1) = huffcode(p+1);
        DC_matrix1(dc_chrominance_values(p+1)+1, 1+1) = huffsize(p+1);
    end

    %Repeat above procdedure for AC chrominance table
    p = 0;
    for l = 1:16
        for i = 1:ac_chrominance_nrcodes(l+1)
            huffsize(p+1) = l;
            p=p+1;
        end
    end
    huffsize(p+1) = 0;
    lastp = p;

    code = 0;
    si = huffsize(0+1);
    p = 0;
    while huffsize(p+1) ~= 0
        while huffsize(p+1) == si
            huffcode(p+1) = code;
            p=p+1;
            code=code+1;
        end
        code = bitshift(code, 1);
        si=si+1;
    end 

    for p = 0:lastp-1
        AC_matrix1(ac_chrominance_values(p+1)+1, 0+1) = huffcode(p+1);
        AC_matrix1(ac_chrominance_values(p+1)+1, 1+1) = huffsize(p+1);
    end

    %Repeat for DC luminance table
    p = 0;
    for l = 1:16
        for i = 1:dc_luminance_nrcodes(l+1)
            huffsize(p+1) = l;
            p = p + 1;
        end
    end
    huffsize(p+1) = 0;
    lastp = p;

    code = 0;
    si = huffsize(0+1);
    p = 0;
    while huffsize(p+1) ~= 0
        while huffsize(p+1) == si
            huffcode(p+1) = code;
            p = p + 1;
            code = code + 1;
        end
        code  = bitshift(code, 1);
        si = si + 1;
    end

    for p = 0:lastp-1
        DC_matrix0(dc_luminance_values(p+1)+1, 0+1) = huffcode(p+1);
        DC_matrix0(dc_luminance_values(p+1)+1, 1+1) = huffsize(p+1);
    end


    %Repeat for AC luminance table
    p = 0;
    for l = 1:16
        for i = 1:ac_luminance_nrcodes(l+1)
            huffsize(p+1) = l;
            p = p + 1;
        end
    end
    huffsize(p+1) = 0;
    lastp = p;

    code = 0;
    si = huffsize(0+1);
    p = 0;
    while huffsize(p+1) ~= 0
        while huffsize(p+1) == si
            huffcode(p+1) = code;
            p = p + 1;
            code = code+1;
        end
        code = bitshift(code, 1);
        si = si + 1;
    end
    for q = 0:lastp-1
        AC_matrix0(ac_luminance_values(q+1)+1, 0+1) = huffcode(q+1);
        AC_matrix0(ac_luminance_values(q+1)+1, 1+1) = huffsize(q+1);
    end

    DC_matrix(0+1, :, :) = DC_matrix0;
    DC_matrix(1+1, :, :) = DC_matrix1;
    AC_matrix(0+1, :, :) = AC_matrix0;
    AC_matrix(1+1, :, :) = AC_matrix1;
    
    %remove zero entries from AC tables
   AC_matrix0( ~any(AC_matrix0,2), : ) = [];
    AC_matrix1( ~any(AC_matrix1,2), : ) = [];
    
    %initialize tables
    DC_L=cell(length(DC_matrix0),1);
    DC_C=cell(length(DC_matrix1),1);
    AC_L=cell(length(AC_matrix0),1);
    AC_C=cell(length(AC_matrix1),1);
    
    %Create final Huffman code tables from value+size
    for i=1:length(DC_L) %DC Tables
    DC_L{i}=dec2bin(DC_matrix0(i,1),DC_matrix0(i,2));
    DC_C{i}=dec2bin(DC_matrix1(i,1),DC_matrix1(i,2));
    end
    
    for i=1:length(AC_L) %AC Tables
    AC_L{i}=dec2bin(AC_matrix0(i,1),AC_matrix0(i,2));
    AC_C{i}=dec2bin(AC_matrix1(i,1),AC_matrix1(i,2));
    end


end

