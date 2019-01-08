% Draw epipolar lines, from the essential matrix.

clear all
close all
 
I1 = imread('I1.tif');
I2 = imread('I2.tif');

% intrinsic camera parameters
K = [ 300  0  150;   
      0  300  150;
      0  0   1];
 
load E
load u1
load u2
     
% Display images
subplot(1,2,1), imshow(I1, []), title('View 1');
for i=1:length(u1)
    rectangle('Position', [u1(1,i)-4 u1(2,i)-4 8 8], 'EdgeColor', 'r');
    text(u1(1,i)+4, u1(2,i)+4, sprintf('%d', i), 'Color', 'r');
end
subplot(1,2,2), imshow(I2, []), title('View 2');
for i=1:length(u2)
    rectangle('Position', [u2(1,i)-4 u2(2,i)-4 8 8], 'EdgeColor', 'g');
    text(u2(1,i)+4, u2(2,i)+4, sprintf('%d', i), 'Color', 'g');
end
 
pause

p1 = inv(K) * u1;        % get normalized image coordinates
p2 = inv(K) * u2;        % get normalized image coordinates

% Draw epipolar lines on image 1
for i=1:length(p2)   
    subplot(1,2,1), imshow(I1,[]);
    % The product l=E*p2 is the equation of the epipolar line corresponding
    % to p2, in the first image.  Here, l=(a,b,c), and the equation of the
    % line is ax + by + c = 0.
    l = E * p2(:,i);
    
    % Calculate residual error.  The product p1'*E*p2 should = 0.  The
    % difference is the residual.
    res = p1(:,i)' * E * p2(:,i);
    fprintf('Residual is %f to point %d\n', res, i);
    
    % Let's find two points on this line. First set x=-1 and solve
    % for y, then set x=1 and solve for y. 
    pLine0 = [-1; (-l(3)-l(1)*(-1))/l(2); 1];
    pLine1 = [1; (-l(3)-l(1))/l(2); 1];
    
    % Convert from normalized to unnormalized coords
    pLine0 = K * pLine0;
    pLine1 = K * pLine1;
    
    line([pLine0(1) pLine1(1)], [pLine0(2) pLine1(2)], 'Color', 'r');
    
    subplot(1,2,2), imshow(I2,[]);
    rectangle('Position', [u2(1,i)-4 u2(2,i)-4 8 8], 'EdgeColor', 'g');
    text(u2(1,i)+4, u2(2,i)+4, sprintf('%d', i), 'Color', 'g');
    
    pause;
end

% Draw epipolar lines on image 2
for i=1:length(p1)   
    subplot(1,2,2), imshow(I2, []);
    % The product l=E'*p1 is the equation of the epipolar line corresponding
    % to p1, in the second image.  Here, l=(a,b,c), and the equation of the
    % line is ax + by + c = 0.
    l = E' * p1(:,i);
    
    % Let's find two points on this line. First set x=-1 and solve
    % for y, then set x=1 and solve for y. 
    pLine0 = [-1; (-l(3)-l(1)*(-1))/l(2); 1];
    pLine1 = [1; (-l(3)-l(1))/l(2); 1];
    
    % Convert from normalized to unnormalized coords
    pLine0 = K * pLine0;
    pLine1 = K * pLine1;
    
    line([pLine0(1) pLine1(1)], [pLine0(2) pLine1(2)], 'Color', 'r');
    
    subplot(1,2,1), imshow(I1,[]);
    rectangle('Position', [u1(1,i)-4 u1(2,i)-4 8 8], 'EdgeColor', 'r');
    text(u1(1,i)+4, u1(2,i)+4, sprintf('%d', i), 'Color', 'r');
    
    pause;
end
