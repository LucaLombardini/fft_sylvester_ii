in_vect = linspace(0,15,16);
full_scale = 2^18 -1;

wvfrm1_time_int = round(first_ord_lpf(full_scale, in_vect, 1, 1, 0));
%wvfrm1_time_flt = first_ord_lpf(1, in_vect, 1, 1, 0);

wvfrm2_time_int = round(diracs_delta(full_scale, in_vect, 1, 0));
%wvfrm2_time_flt = diracs_delta(1, in_vect, 1, 0);

wvfrm3_time_int = round(const(full_scale, in_vect, 1));
%wvfrm3_time_flt = const(1, in_vect,1);

wvfrm4_time_int = round(step(full_scale, in_vect, 1, 8));
%wvfrm4_time_flt = round(1, in_vector, 0);

wvfrm5_time_int = round(ramp(full_scale, in_vect, 1, 0));
%wvfrm5_time_flt = ramp(1, in_vect, 1, 0);

pulsation = (2*pi/16)*4;
wvfrm6_time_int = round(cosine(full_scale, in_vect, 1, pulsation, 0));
%wvfrm6_time_flt = cosine(1, in_vect, 1, pulsation, 0);

wvfrm7_time_int = round(sine(full_scale, in_vect, 1, pulsation, 0));
%wvfrm7_time_flt = sine(1, in_vect, 1, pulsation, 0);

wvfrm8_time_int = round(door(full_scale, in_vect, 1, 4, 8));
%wvfrm8_time_flt = door(1, in_vect, 1, 4, 8);

wvfrm9_time_int = round(sinc_func(full_scale, in_vect, 1, 8));
%wvfrm9_time_flt = sinc_func(1, in_vect, 1, 8);

wvfrm10_time_int = round(gaussian(full_scale, in_vect, 1, 1, 8));
%wvfrm10_time_int = gaussian(1, in_vector, 1, 8);

fid = fopen("../sim/fft_samples_in.hex","w");

%amplitude swipe
for k = 0.1:0.1:1
    %time shift swipe
    for j = 1:1:16
        wvfrm1_time_int = round(first_ord_lpf(full_scale, in_vect, k, 1, 0));
        for item = 1:1:16
            fprintf(fid, "%.5X", real(wvfrm1_time_int(item)));
        end
        fprintf(fid, "\n");
        for item = 1:1:16
            fprintf(fid, "%.5X", imag(wvfrm1_time_int(item)));
        end
        fprintf(fid, "\n");
    end
end

function out = first_ord_lpf(fs, in, k, a, b)
    unistep = in >= b;
    tmp = exp(-a.*(in - b)).*unistep;
    scale = fs / max(tmp);
    out = (k*scale).*tmp;
end

function out = diracs_delta(fs, in, k, b)
    out = zeros(size(in));
    out(b+1) = k*fs;
end

function out = const(fs, in, k)
    out = ones(size(in)).*(k*fs);
end

function out = step(fs, in, k, b)
    out = (k*fs).*(in >= b);
end

function out = ramp(fs, in, k, b)
    tmp = (in - b);
    scale = (k*fs)/max(tmp);
    out = scale*tmp;
end

function out = cosine(fs, in, k, w, b)
    out = (fs * k)*cos((2*pi*w).*(in-b));
end

function out = sine(fs, in, k, w, b)
    out = (fs * k)*sin((2*pi*w).*(in-b));
end

function out = door(fs, in, k, b, c)
    window = in >= (c-b/2) & in <= (c+b/2);
    out = (fs * k * (1/b)).*window;
end

function out = sinc_func(fs, in, k, b)
    tmp = sinc(in - b);
    scale = fs / max(tmp);
    out = (scale * k).*tmp;
end

function out = gaussian(fs, in, k, t, b)
    tmp = exp(-((in - b).^2)./(2*t^2));
    scale = fs / (t*sqrt(2*pi));
    out = (scale * k).*tmp;
end