% climate_chart(gca, ori_data_map{37, 1}.monthly, 'Vancouver', 'green');

function climate_chart(ax, monthly, city, color, subt)
    title(ax, city, 'Color', color);
    subtitle(subt);
    colororder({'red', 'blue'});
    yyaxis(ax, 'left');
    x = 0.5:1:11.5;
    e = errorbar(x, monthly{'mean_temperature', :}, ...
        monthly{'mean_temperature', :} - monthly{'min_temperature', :}, ...
        monthly{'max_temperature', :} - monthly{'mean_temperature', :});
    e.Color = 'red';
    ylim([-30 30]);
    yyaxis(ax, 'right');
    pr = bar(x, monthly{'precipitation', :}, 'blue');
    pr.FaceAlpha = 0.5;
    hold(ax, 'on');
    pet = bar(x, monthly{'potential_evapotranspiration', :}, 'yellow');
    pet.FaceAlpha = 0.5;
    ylim([0 500]);
end

