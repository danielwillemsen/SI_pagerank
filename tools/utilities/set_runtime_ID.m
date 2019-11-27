function runtimeID = set_runtime_ID()
% set_runtime_ID asks for an ID to the user so that the execution run can be stored with a unique ID. If the user does not input a number, then it assignes a random number.

prompt = '\nDo you desire a runtime ID? \n(Click <Enter> for a random one) \n  >> ';
runtimeID = str2double(input(prompt,'s'));

if isnan(runtimeID)
    runtimeID  = randi(10000);
end

fprintf('\nMy runtime ID is %d\n',runtimeID);

end