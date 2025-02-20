function [ty y] = shortest_path(t,low,high)

% Finds the shortest path bounded two curves,
% using the Dijkstra algorithm.
%
% Written by Y. Levron, Technion
%
% INPUTS:
% t    - time values, row vector
% low  - lower bound, row vector
% high - is the upper bound, row vector
%
% OUTPUTS
% ty   - time values
% y    - shortest path

%% check for data integrity and running time
N = length(t);
if ((size(t,1)~=1)||(size(t,2)~=N)|| ...
    (size(low,1)~=1)||(size(low,2)~=N)|| ...   
    (size(high,1)~=1)||(size(high,2)~=N))
        'Error - all vectors must be row vectors of the same length'
        return
end
ind = find(low>high);
if ~isempty(ind)
    'Error - low bound larger than upper bound';
    return;
end
if (N>1000)
    'Error - expected running time is too long'
    return
end
%%%%%%%%  end - data integrity   %%%%%%%%%%%%%%

very_small_number = ...
    0.001*min( [abs(low(2:end)-low(1:(end-1))) abs(high(2:end)-high(1:(end-1)))]);

mindt = abs(    t(2:end) - t(1:(end-1))   );

if (mindt < very_small_number)
    'Error - problem is purely scaled.'
    return
end

% construct the distant matrix, between each pair of points.
dist2 = (-1)*ones(2*N);
for uu = 1:(2*N),

    if (uu<=N)
        t1 = t(uu);
        y1 = low(uu);
    else
        t1 = t(uu-N);
        y1 = high(uu-N);
    end

    for vv = uu:(2*N),
        if (uu==vv)
            dist2(uu,vv) = 0;
            continue;
        end

        if (vv<=N)
            t2 = t(vv);
            y2 = low(vv);
        else
            t2 = t(vv-N);
            y2 = high(vv-N);
        end

        % find the line connecting (t1,y1) -> (t2,y2)
        if (t1<=t2)
            ind_line = find((t1<=t).*(t<=t2));
        else
            ind_line = find((t2<=t).*(t<=t1));
        end
        
        if (t1==t2)
            dist2(uu,vv) = abs(y2-y1);
        else
            t_line = t(ind_line);
            a_line = (y2-y1)/(t2-t1);

            b_line = y1 - a_line*t1;
            y_line = a_line*t_line + b_line;

            ind = find((y_line>(high(ind_line)+very_small_number))+(y_line<(low(ind_line)-very_small_number)  ));
            if (isempty(ind))
                dist2(uu,vv) = ((t2-t1)^2 + (y2-y1)^2)^0.5;
            else
                dist2(uu,vv) = inf;
            end
        end
    end
end

% duplicate the other side of the matrix:
for vv = 1:(2*N),
    for uu = vv:(2*N),
        dist2(uu,vv) = dist2(vv,uu);
    end
end
        
%%%%%%%%%% end matrix construction %%%%%%%%%%%%%%


%%%%%%%  run the Dijkstra algorithm  %%%%%%%
dist = inf*ones(1,2*N);
previous = NaN*ones(1,2*N);
dist(1) = 0;
Q = 1:(2*N);

while (~isempty(Q))
    min_dist_Q = min(dist(Q));
    u_Q = find(dist(Q)==min_dist_Q); u_Q=u_Q(1);
    u = Q(u_Q);
    
    if (isinf(dist(u)))
        'Error - destination is unreachable'
        u
        ty = NaN; y = NaN;
        return;
    end
    Q = Q(find(Q~=u));
    if (u == N)
        break;
    end
    
    alt = dist(u) + dist2(u,Q);
    ii = find(alt<dist(Q));  
    dist(Q(ii)) = alt(ii);
    previous(Q(ii)) = u;
end;
%%%%%%% end Dijkstra algorithm %%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Build the shorest path %%%%%%%%%%
s = [];
u = N;
while (~isnan(u)) 
    s = [u s];
    u = previous(u);
end
%%%%%%% end shorest path %%%%%%%%%%

%%%%%%% translate vertixes to function  %%%%%%%%
ty = [];
y = [];
for ii = 1:length(s)
    u = s(ii);
    
    if (u<=N)
        t1 = t(u);
        y1 = low(u);
    else
        t1 = t(u-N);
        y1 = high(u-N);
    end
    
    ty = [ty t1];
    y = [y y1];
end
%%%%%%% end translate  %%%%%%%%%%%

return
