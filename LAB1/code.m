clc; clear;

% Simulation parameters
num_bits = 1e3; % Number of bits
SNR_range = -20:2:20; % SNR range in dB
num_iterations = 100; % Number of iterations for averaging BER

% Initialize BER vector
BER = zeros(size(SNR_range));

for snr_index = 1:length(SNR_range)
    SNR = 10^(SNR_range(snr_index)/10); % Convert SNR from dB to linear scale
    noise_var = 1/SNR; % Noise variance
    
    num_errors = 0; % Initialize error count
    
    for iter = 1:num_iterations
        % Generate random binary data vector
        bits = randi([0,1], 1, num_bits);
        
        % Calculate transmitted signal power
        signal_power = sum(bits.^2)/num_bits;
        
        % Generate noise
        noise = sqrt(noise_var)*randn(1, num_bits);
        
        % Received sequence
        Rx_sequence = bits + noise;
        
        % Decision: simple thresholding
        detected_bits = Rx_sequence > 0.5;
        
        % Count number of errors
        num_errors = num_errors + sum(detected_bits ~= bits);
    end
    
    % Calculate Bit Error Rate (BER)
    BER(snr_index) = num_errors / (num_bits * num_iterations);
end

% Plot BER curve
figure;
plot(SNR_range, BER, 'x-k', 'Color', 'b', 'LineWidth', 1); % Set curve color to green
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('Bit Error Rate vs. SNR');
grid on; % Add grid for better visualization

% Specify y-axis ticks with smaller steps
yticks(0:0.05:1); % Adjust as needed

% Calculation of transmitted signal power
disp(['Transmitted Signal Power: ' num2str(signal_power)]);

% Comment on equation (1)
disp('Comment on Equation (1): Dividing by the square root of SNR is done to normalize the noise variance.');

% Find SNR where the system is nearly without error
[min_BER, min_BER_index] = min(BER);
SNR_nearly_without_error = SNR_range(min_BER_index);
disp(['SNR where the system is nearly without error: ' num2str(SNR_nearly_without_error) ' dB']);
