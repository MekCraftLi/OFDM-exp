function comp_data = phase_compensation(eq_data, pilot_syms, params)
arguments
    eq_data double
    pilot_syms double
    params (1,1) OfdmParams
end

phase_est = angle(sum(pilot_syms, 1));
phase_comp = exp(-1i * phase_est);
comp_data = eq_data .* repmat(phase_comp, size(eq_data, 1), 1);
end
