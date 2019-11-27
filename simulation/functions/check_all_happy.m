function happy = check_all_happy(bsim, state_local_n)
%check_all_happy Checks whether all agents are in a local state that is desired
%
% Mario Coppola, 2018

happy = all(ismember(state_local_n, bsim.des));

end
