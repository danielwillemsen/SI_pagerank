function d = pass_proof(p)
%pass_proof just outputs user info on whether the proof was passed or not

d = all(p);

if d
    fprintf('\n \t\t ... passed proof');
else
    fprintf('\n \t\t ... failed proof');
end

end

