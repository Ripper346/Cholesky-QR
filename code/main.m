function main(start, n, step)
% Print a check of correctness on a sample matrix 5x5 and execute the whole
% test. By default it starts with a matrix 50x30 to one 10Kx30 with
% increasing rows by 50. The results are stored in a file and then it shows 
% a chart with the results.
% Input:
% [start] - minimum row of the matrix
% [n] - number of rounds to perform
% [step] - number of rows increasing for each round
    testCorrectnessCPU();
    testCorrectnessGPU();
    
    start_time = string(datetime('now', 'Format', 'yyyy-MM-dd''T''HH.mm'));
    if nargin < 3
        step = 50;
    end
    if nargin < 2
        n = 200;
    end
    if nargin < 1
        start = 50;
    elseif start < 30
        error('Number of initial rows must be larger or equal than 30 columns');
    end
    t_cpu = zeros(n, 6);
    t_gpu = zeros(n, 6);
    rows = start:step:n * step + start - step;
    
    for i = 1:n
        fprintf('Computing round %d of %d...\n', i, n);
        X = randi(rows(i) * 2, rows(i), 30);
        f = @() qr(X);
        t_cpu_1 = timeit(f, 2);
        f = @() cholqr(X);
        t_cpu_2 = timeit(f, 2);
        f = @() gs_cl(X);
        t_cpu_3 = timeit(f, 2);
        f = @() gs_mod(X);
        t_cpu_4 = timeit(f, 2);
        f = @() svqr(X);
        t_cpu_5 = timeit(f, 2);
        f = @() caqr(X);
        t_cpu_6 = timeit(f, 2);
        
        reset(gpuDevice(1));
        X_gpu = gpuArray(X);
        f = @() qr(X_gpu);
        t_gpu_1 = gputimeit(f, 2);
        f = @() cholqr(X_gpu);
        t_gpu_2 = gputimeit(f, 2);
        f = @() gs_cl(X_gpu);
        t_gpu_3 = gputimeit(f, 2);
        f = @() gs_mod(X_gpu);
        t_gpu_4 = gputimeit(f, 2);
        f = @() svqr(X_gpu);
        t_gpu_5 = gputimeit(f, 2);
        f = @() caqr(X_gpu);
        t_gpu_6 = gputimeit(f, 2);
        t_cpu(i, :) = [t_cpu_1 t_cpu_2 t_cpu_3 t_cpu_4 t_cpu_5 t_cpu_6];
        t_gpu(i, :) = [t_gpu_1 t_gpu_2 t_gpu_3 t_gpu_4 t_gpu_5 t_gpu_6];
        save(strcat('Results_', string(start), 'to', string(n * step + start - step), ...
            'step', string(step), '_', start_time, '.mat'), 'rows', 't_cpu', 't_gpu');
    end
    
    print_plot_with_fit(rows, t_cpu, t_gpu);
end

function testCorrectnessCPU
    n = 5;
    X = randi(n * 2, n);
    fprintf('Generated\n');
    test(X);
end

function testCorrectnessGPU
    n = 5;
    X = randi(n * 2, n, 'gpuArray');
    fprintf('Generated\n');
    test(X);
end
    
function test(X)
    X_CPU = gather(X);
    [Q_native, R_native] = qr(X);
    if gather(round(Q_native * R_native)) == X_CPU
        fprintf('Correct QR\n');
    end
    [Q_cholqr, R_cholqr] = cholqr(X);
    if gather(round(Q_cholqr * R_cholqr)) == X_CPU
        fprintf('Correct check on cholqr\n');
    end
    [Q_cgs, R_cgs] = gs_cl(X);
    if gather(round(Q_cgs * R_cgs)) == X_CPU
        fprintf('Correct check on cgs\n');
    end
    [Q_mgs, R_mgs] = gs_mod(X);
    if gather(round(Q_mgs * R_mgs)) == X_CPU
        fprintf('Correct check on mgs\n');
    end
    [Q_svqr, R_svqr] = svqr(X);
    if gather(round(Q_svqr * R_svqr)) == X_CPU
        fprintf('Correct check on svqr\n');
    end
    [Q_caqr, R_caqr] = caqr(X);
    if gather(round(Q_caqr * R_caqr)) == X_CPU
        fprintf('Correct check on caqr\n');
    end
end
