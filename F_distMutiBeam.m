function [ transFrequency, arrBeam] = F_distMutiBeam( bb, diameter )
    global beamNum
    R = diameter/2; %   覆盖区域的半径
%     areasNo = reshape(1:1:diameter*diameter, diameter, diameter);  %   小区编号； 
    arrBeam = zeros(diameter, diameter); 
    if beamNum == 2
        r = sqrt(5)/2*R;
        if bb == 1
            %   将位于点波束内的小区置1，波束外的小区置0；
            arrBeam(1: ceil(r+R/2), 1:ceil(2*R)) = 1;
            %   点波束内的小区编号（用一列表示）；
%             areasNo_beam = arrBeam .* areasNo(arrBeam .* areasNo~=0);  
            transFrequency = 161.975*1e6;
        end
        if bb == 2
%             arrBeam(floor(3/2*R-r): ceil(2*R), 1: ceil(2*R)) = 1;
            arrBeam((ceil(r+R/2)+1): ceil(2*R), 1: ceil(2*R)) = 1;
            transFrequency = 162.025*1e6;
        end
    end
    if beamNum == 4
        r = 1/sqrt(2)*R;
        if bb == 1      %   第一个点波束
            arrBeam(1: ceil((1+sqrt(2)/2)*r), 1:ceil((1+sqrt(2)/2)*r)) = 1;
            transFrequency = 161.975*1e6;   %   发送频率（HZ）
        end
        if bb ==2
%             arrBeam(1:ceil((1+sqrt(2)/2)*r), floor((3*sqrt(2)/2-1)*r):ceil(2*R)) = 1;
            arrBeam(1:ceil((1+sqrt(2)/2)*r), (ceil((1+sqrt(2)/2)*r)+1):ceil(2*R)) = 1;
            transFrequency = 162.025*1e6;   %   发送频率（HZ）
        end
        if bb == 3
%             arrBeam(floor((3*sqrt(2)/2-1)*r):ceil(2*R), floor((3*sqrt(2)/2-1)*r):ceil(2*R)) = 1;
            arrBeam((ceil((1+sqrt(2)/2)*r)+1):ceil(2*R), (ceil((1+sqrt(2)/2)*r)+1):ceil(2*R)) = 1;            
            transFrequency = 162.075*1e6;   %   发送频率（HZ）
        end
        if bb == 4
%             arrBeam(floor((3*sqrt(2)/2-1)*r):ceil(2*R), 1: ceil((1+sqrt(2)/2)*r)) = 1;
            arrBeam((ceil((1+sqrt(2)/2)*r)+1):ceil(2*R), 1:ceil((1+sqrt(2)/2)*r)) = 1;
            transFrequency = 161.925*1e6;   %   发送频率（HZ）
        end
    end
    if beamNum == 6             %    六波束模型存在问题，尚未解决。重叠区域部分的船发送频点问题
        r = 1/sqrt(3)*R;
        if bb == 1
            arrBeam(1:ceil(R+r-sqrt(3)/2*r), floor(R-3/2*r): ceil(sqrt(3)*r+r/2)) = 1;
            transFrequency = 161.975*1e6;   %   发送频率（HZ）
        end
        if bb == 2
            arrBeam(1: ceil(R+r-sqrt(3)/2*r), floor(sqrt(3)*r-r/2):ceil(R+3/2*r)) = 1;
            transFrequency = 162.025*1e6;
        end
        if bb == 3
            arrBeam(floor((sqrt(3)-1)*r): ceil((sqrt(3)+1)*r), floor(sqrt(3)*r):ceil(2*R)) = 1;
            transFrequency = 162.075*1e6;
        end
        if bb == 4
            arrBeam(floor(R-r+sqrt(3)/2*r): ceil(2*R), floor(sqrt(3)*r-r/2):ceil(R+3/2*r)) = 1;
            transFrequency = 162.125*1e6;
        end
        if bb == 5
            arrBeam(floor(R-r+sqrt(3)/2*r): ceil(2*R), floor(R-3/2*r):ceil(R+r/2)) = 1;
            transFrequency = 161.925*1e6;
        end
        if bb == 6
            arrBeam(floor(R-r): ceil(R+r), 1:ceil(R)) = 1;
            transFrequency = 161.875*1e6;
        end
    end
    if beamNum == 7
        r = 1/2*R;
        if bb == 1
%             arrBeam(1: ceil((R+r)/2), floor(r+sqrt(3)/3*((R+r)/2)):ceil(r-sqrt(3)/3*(R+r)/2+R)) = 1;
            arrBeam(1: ceil(R-r), 1:ceil(r-sqrt(3)/3*(R+r)/2+R)) = 1;
            transFrequency = 161.975*1e6;   %   发送频率（HZ）
        end
        if bb == 2
%             arrBeam(1: ceil((R+r)/2), floor(R-r+sqrt(3)/3*(R+r)/2):ceil(R+r+sqrt(3)/6*(R+r))) = 1;
            arrBeam(1: ceil(R-r), (ceil(r-sqrt(3)/3*(R+r)/2+R)+1):ceil(2*R)) = 1;
            transFrequency = 162.025*1e6;   %   发送频率（HZ）
        end
        if bb == 3
%             arrBeam(floor(R-r): ceil(R+r), floor(sqrt(3)/3*(R+r)-r+R):ceil(2*R)) = 1;
            arrBeam((ceil(R-r)+1): ceil(R+r), ceil(sqrt(3)/3*(R+r)-r+R):ceil(2*R)) = 1;
            transFrequency = 162.075*1e6;   %   发送频率（HZ）
        end
        if bb == 4
%             arrBeam(floor((3*R-r)/2): 2*R, floor(R-r+sqrt(3)/3*(R+r)/2):ceil(sqrt(3)/3*(R+r)/2+r+R)) = 1;
            arrBeam((ceil(R+r)+1): ceil(2*R), ceil(r-sqrt(3)/3*(R+r)/2+R):ceil(2*R)) = 1;
            transFrequency = 162.125*1e6;   %   发送频率（HZ）
        end
        if bb == 5
%             arrBeam(floor((3*R-r)/2): ceil(2*R), floor(r+sqrt(3)/3*(R+r)/2):ceil(r-sqrt(3)/3*(R+r)/2+R)) = 1;
            arrBeam((ceil(R+r)+1): ceil(2*R), 1:(ceil(r-sqrt(3)/3*(R+r)/2+R)-1)) = 1;
            transFrequency = 161.925*1e6;   %   发送频率（HZ）
        end
        if bb == 6
%             arrBeam(floor(R-r): ceil(R+r), 1:ceil(R-sqrt(3)/3*(R+r)+r)) = 1;
            arrBeam((ceil(R-r)+1): ceil(R+r), 1:ceil(R-sqrt(3)/3*(R+r)+r)) = 1;
            transFrequency = 161.875*1e6;   %   发送频率（HZ）
        end
        if bb == 7
%             arrBeam(floor(R-r): ceil(R+r), floor(R-r): ceil(R+r)) = 1;
            arrBeam((ceil(R-r)+1): ceil(R+r), (ceil(R-sqrt(3)/3*(R+r)+r)+1): (ceil(sqrt(3)/3*(R+r)-r+R)-1)) = 1;
            transFrequency = 161.825*1e6;   %   发送频率（HZ）
        end
    end
end

