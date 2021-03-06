function [optTheta1,optTheta2,FP] = Predictor(X,iniTheta1,iniTheta2,lambda)
  nof = size(X,1);
  M = size(X,2);
  m = 365;
  e = M-m;
  x = X(:,1);
  y = X(:,366);
  
  for i = 367:M
      x = [x,X(:,i-m)];
      y = [y,X(:,i)];
  endfor
  
  # Unrolling into Theta Vector
  thetaVec = [ iniTheta1(:); iniTheta2(:) ];
  
  # Minimize Cost Function to get OptTheta Vector
  options = optimset( 'GradObj', 'on', 'MaxIter', 1000000 );
  [optThetaVec, jMin, exitFlag ] = fminunc( @(thetaVec)(predictionCostFunction(thetaVec,nof,x,y,e,lambda)), thetaVec, options );

  # Reshaping Optimal Theta Vector into Matrices for Layer 1 and Layer 2  
  optTheta1 = reshape( optThetaVec( 1:(nof-1)*nof ), nof-1, nof );
  optTheta2 = reshape( optThetaVec( ( (nof-1)*nof )+1:(nof-1)*nof*2), nof-1, nof );
  
  # Apply Forward Propogation to make final Predictions in Nueral Network
  [a1,a2,FP] = forwardPropPredictor(x,optTheta1,optTheta2);
  
endfunction