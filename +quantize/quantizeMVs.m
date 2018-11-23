function qdata = quantizeMVs(data)

if (size(data,1)>1)
    data = reshape(data,1,[]);
end

qdata = data+33;

clearvars -except qdata;

end