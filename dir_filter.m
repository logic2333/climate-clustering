function tf = dir_filter(strc)
    tf = false;
    if ~isempty(strc.date) && strc.isdir
        if contains(strc.name, 'som') || contains(strc.name, 'medoids')
            tf = true;
        end
        if contains(strc.name, '_no')
            tf = false;
        end
    end    

end