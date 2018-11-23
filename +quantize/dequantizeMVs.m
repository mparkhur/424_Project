function data = dequantizeMVs(qdata)

if (size(qdata,1)>1)
    qdata = reshape(qdata,1,[]);
end

data = qdata-33;

clearvars -except data;

end