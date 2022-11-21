function DHT4 = encodeDHTheader(  )

%
%frequencies of dc luminance symbols, first element is table id
global dc_luminance_nrcodes;
    dc_luminance_nrcodes=[0 0 1 5 1 1 1 1 1 1 0 0 0 0 0 0 0];

    %encoded values
    global dc_luminance_values;
    dc_luminance_values=[0 1 2 3 4 5 6 7 8 9 10 11];

    %frequencies of dc chrominance symbols, first element is table id
    global dc_chrominance_nrcodes;
    dc_chrominance_nrcodes=[1 0 3 1 1 1 1 1 1 1 1 1 0 0 0 0 0];
    %encoded values
    global dc_chrominance_values;
    dc_chrominance_values=[0 1 2 3 4 5 6 7 8 9 10 11];
%frequencies of ac luminance symbols, first element is table id
    global ac_luminance_nrcodes;
    ac_luminance_nrcodes=[16 0 2 1 3 3 2 4 3 5 5 4 4 0 0 1 125];
   %encoded values
    global ac_luminance_values;
    ac_luminance_values = [
          1 2 3 0 4 17 5 18 33 49 65 6 19 81 97 7 ...
          34 113 20 50 129 145 161 8 35 66 177 193 ...
          21 82 209 240 36 51 98 114 130 9 10 22 23 ...
          24 25 26 37 38 39 40 41 42 52 53 54 55 56 ...
          57 58 67 68 69 70 71 72 73 74 83 84 85 86 87 ...
          88 89 90 99 100 101 102 103 104 105 106 115 ...
          116 117 118 119 120 121 122 131 132 133 134 ...
          135 136 137 138 146 147 148 149 150 151 152 ...
          153 154 162 163 164 165 166 167 168 169 170 ...
          178 179 180 181 182 183 184 185 186 194 195 ...
          196 197 198 199 200 201 202 210 211 212 213 ...
          214 215 216 217 218 225 226 227 228 229 230 ...
          231 232 233 234 241 242 243 244 245 246 247 248 249 250 ];
%frequencies of ac chrominance symbols, first element is table id
    global ac_chrominance_nrcodes;  
    ac_chrominance_nrcodes=[17 0 2 1 2 4 4 3 4 7 5 4 4 0 1 2 119];
   %encoded values
    global ac_chrominance_values;
    ac_chrominance_values = [
          0 1 2 3 17 4 5 33 49 6 18 65 81 7 97 ...
          113 19 34 50 129 8 20 66 145 161 177 ...
          193 9 35 51 82 240 21 98 114 209 10 22 ...
          36 52 225 37 241 23 24 25 26 38 39 40 ...
          41 42 53 54 55 56 57 58 67 68 69 70 71 ...
          72 73 74 83 84 85 86 87 88 89 90 99 100 ...
          101 102 103 104 105 106 115 116 117 118 ...
          119 120 121 122 130 131 132 133 134 135 ...
          136 137 138 146 147 148 149 150 151 152 ...
          153 154 162 163 164 165 166 167 168 169 ...
          170 178 179 180 181 182 183 184 185 186 ...
          194 195 196 197 198 199 200 201 202 210 ...
          211 212 213 214 215 216 217 218 226 227 ...
          228 229 230 231 232 233 234 242 243 244 ...
          245 246 247 248 249 250];

global bits;
    bits{1} = dc_luminance_nrcodes;
    bits{2} = ac_luminance_nrcodes;
    bits{3} = dc_chrominance_nrcodes;
    bits{4} = ac_chrominance_nrcodes;
    
    global values;
    values{1} = dc_luminance_values;
    values{2} = ac_luminance_values;
    values{3} = dc_chrominance_values;
    values{4} = ac_chrominance_values;
    
    

length = 2;
    index = 4;
    oldindex = 4;
    DHT4 = zeros(1, 4);
    DHT4(1) = hex2dec('FF');
    DHT4(2) = hex2dec('C4');
    for i=1:4
        bytes = 0;
        DHT1(index - oldindex + 1) = bits{i}(0+1);
        index = index + 1;
        for j = 2:17
            temp = bits{i}(j);
            DHT1(index - oldindex + 1) = temp;
            index = index + 1;
            bytes = bytes + temp;
        end
        intermediateindex = index;
        for j = 1:bytes
            DHT2(index - intermediateindex + 1) = values{i}(j);
            index = index + 1;
        end
        DHT3(1:oldindex) = DHT4(1:oldindex);
        DHT3(oldindex+1:oldindex+17) = DHT1(1:17);
        DHT3(oldindex+17+1:oldindex+17+bytes) = DHT2(1:bytes);
        DHT4 = DHT3;
        oldindex = index;
    end
    DHT4(3) = bitand(bitshift(index - 2, -8), hex2dec('FF'));
    DHT4(4) = bitand(index - 2, hex2dec('FF'));

end

