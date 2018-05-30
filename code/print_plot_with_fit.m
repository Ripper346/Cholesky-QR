function print_plot_with_fit(x, t_cpu, t_gpu, fit_type)
% Print cpu and gpu results. 
% Optionally can print also a fit function for each result.
% Input:
% x - array of x axis
% t_cpu - array of cpu time results
% t_gpu - array of gpu time results
% [fit_type] - type for curve fitting compatible with https://it.mathworks.com/help/curvefit/fittype.html
    if nargin < 4
        drawfit = false;
    else
        drawfit = true;
    end
    figure;
    hold on;
    colors = [ ...
        0.858 0 0.725; ... % purple
        0 0.858 0.843; ... % cyan
        0.858 0.019 0; ... % red
        0.074 0.043 0.576; ... % blue
        0.839, 0.592, 0; ... %orange
        0.105 0.576 0.043; ... % green
    ];
    for i = 1:size(t_cpu, 2)
        plot_t_cpu(i) = plot(x, t_cpu(:, i), '.', 'Color', colors(i, :));
        if drawfit
            f = plot(fit((x)', t_cpu(:, i), fit_type));
            set(f, 'Color', colors(i, :));
        end
    end
    for i = 1:size(t_gpu, 2)
        plot_t_gpu(i) = plot(x, t_gpu(:, i), 'o', 'Color', colors(i, :));
        if drawfit
            f = plot(fit((x)', t_gpu(:, i), fit_type));
            set(f, 'Color', colors(i, :));
            set(f, 'LineStyle', '--');
        end
    end
    title('Performance comparison');
    xlabel('Number of rows');
    ylabel('Time [s]');
    legend([plot_t_cpu plot_t_gpu], ...
        {'native QR [CPU]', ...
        'CholQR [CPU]', ...
        'CGS [CPU]', ...
        'MGS [CPU]', ...
        'SVQR [CPU]', ...
        'CAQR [CPU]', ...
        'native QR [GPU]', ...
        'CholQR [GPU]', ...
        'CGS [GPU]', ...
        'MGS [GPU]', ...
        'SVQR [GPU]', ...
        'CAQR [GPU]' ...
    });
    set(gca, 'yscale', 'log')
    hold off;
end