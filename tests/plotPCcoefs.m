clustID = clustID+1;
iSp = find(rez.st3(:,2)==clustID);

plot(rez.cProjPC(iSp+1,1,1), rez.cProjPC(iSp+1,1,2), '.')