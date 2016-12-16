function accuracy(scores, labels)
   -- Inputs: scores: a batch of scores (numImages x 1 x numClasses), 
   --         labels: batch of integer labels (numImages x 1) 
   -- Returns: fraction of hard predictions (argmaxs) taken from 
   --    scores that are correct.  
   local _, argmaxs = torch.max(scores, 2)
   return torch.sum(torch.eq(argmaxs:int(), labels)) / labels:numel()
end

function normalize(t)
   -- Input: t: n x m x ... batch of n tensors
   -- Returns: projection of each tensor in t onto the unit ball
   return t:cdiv(t:norm(2, 2):expandAs(t))
end

function avgDistance(t1, t2)
   -- Inputs: t1, t2, n x m x ... batch of n tensors 
   -- Returns: the average distance between tensors in t1 and t2
   return (t1 - t2):norm(2, 2):mean()
end

function fileExists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
