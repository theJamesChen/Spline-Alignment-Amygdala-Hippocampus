%% 1.2 Loading Landmarks
close all; clear all;
%Atlas
%Amygdala N = 20 x 3
lA_a = read_txt_landmarks('amygdala_01_landmarks.txt');
%hippocampus N = 38 x 3
lH_a = read_txt_landmarks('hippocampus_01_landmarks.txt');

%Target
%Amygdala N = 20 x 3
lA_t = read_txt_landmarks('amygdala_05_landmarks.txt');
%hippocampus N = 38 x 3
lH_t = read_txt_landmarks('hippocampus_05_landmarks.txt');

%% 1.3 Loading Surfaces

%Atlas
[fA_a, vA_a] = read_byu_surface('amygdala_01_surface.byu');
[fH_a, vH_a] = read_byu_surface('hippocampus_01_surface.byu');

%Target
[fA_t, vA_t] = read_byu_surface('amygdala_05_surface.byu');
[fH_t, vH_t] = read_byu_surface('hippocampus_05_surface.byu');

%% 1.5.1 Visualize Atlas and Target Landmarks and Surfaces

% view the landmarks using scatter3

hlA_a = scatter3(lA_a(:,1),lA_a(:,2),lA_a(:,3));
hold on;
hlH_a = scatter3(lH_a(:,1),lH_a(:,2),lH_a(:,3));
hlH_t = scatter3(lH_t(:,1),lH_t(:,2),lH_t(:,3));
hlA_t = scatter3(lA_t(:,1),lA_t(:,2),lA_t(:,3));
title('Atlas and Target Landmarks and Surfaces')

% view the surfaces using the patch command
hsA_a = patch('faces',fA_a,'vertices',vA_a);
hsH_a = patch('faces',fH_a,'vertices',vH_a);
hsA_t = patch('faces',fA_t,'vertices',vA_t);
hsH_t = patch('faces',fH_t,'vertices',vH_t);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')

% add a light to visualize 3D surfaces with shading
light

% find a nice orientation
view(64,26)

% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA_a,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH_a,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA_a,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH_a,'FaceColor','y','EdgeColor','none','FaceLighting','phong')

set(hlA_t,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH_t,'MarkerFaceColor','g','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA_t,'FaceColor','r','EdgeColor','none','FaceLighting','phong')
set(hsH_t,'FaceColor','g','EdgeColor','none','FaceLighting','phong')

% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
L = legend([hsA_a hsH_a hsA_t hsH_t],{'Amygdala Atlas','Hippocampus Atlas', 'Amygdala Target', 'Hippocampus Target'});
set(L, 'Position', [0.781, .07, .131, .115])

% save the figure
%set(gcf,'PaperPositionMode','auto')
%saveas(gcf,'1.5.1AtlasAndTargetLandmarkSurfaces.png')

%% 1.5.2 Calculate a Linear Alignment Matrix

%Concatenate Amygdala and Hippocampus Landmarks
lAtlas = [lA_a; lH_a]; %58x3
lTarget = [lA_t; lH_t]; %58x3

%Create multidimensional array
X = zeros(3,9,size(lAtlas,1));
Y = zeros(3,1,size(lTarget,1));
%Rewrite each landmark as (xi yi 0 0; 0 0 xi yi)
for i = 1:size(lAtlas,1)
   X(:,:,i) = [lAtlas(i,:) 0 0 0 0 0 0; 0 0 0 lAtlas(i,:) 0 0 0; 0 0 0 0 0 0 lAtlas(i,:)];
   Y(:,:,i) = lTarget(i,:)';
end

term1 = zeros(9,9);
term2 = zeros(9,1);
%Calculate sum(Xi'Xi) = term1
for i = 1:size(X,3)
   term1 = term1 + X(:,:,i)' * X(:,:,i);   
end

%Calculate sum(Xi'Yi) = term2
for i = 1:size(X,3)
   term2 = term2 + X(:,:,i)' * Y(:,:,i);   
end

%Invert term1
term1 = term1^(-1);
%Multiply
a = term1 * term2;
%Rewrite a into A
A = [a(1) a(2) a(3); a(4) a(5) a(6); a(7) a(8) a(9)];

%% 1.5.3 Transform Atlas Landmarks and Atlas Surface Vertices

%Transform the landmarks and surface vertices
lA_a_xformed = (A * lA_a')';
lH_a_xformed = (A * lH_a')';
vA_a_xformed = (A * vA_a')';
vH_a_xformed = (A * vH_a')';

concatenate_linearxform = [lA_a_xformed;lH_a_xformed];

%Print sum of square error between pairs of landmarks before and after this linear alignment
E_beforexform = sum(sum((lAtlas - lTarget).^2));
E_afterxform = sum(sum((concatenate_linearxform - lTarget).^2));

% view the landmarks using scatter3
figure;
hlA_a_xformed = scatter3(lA_a_xformed(:,1),lA_a_xformed(:,2),lA_a_xformed(:,3));
hold on;
hlH_a_xformed = scatter3(lH_a_xformed(:,1),lH_a_xformed(:,2),lH_a_xformed(:,3));
hlH_t = scatter3(lH_t(:,1),lH_t(:,2),lH_t(:,3));
hlA_t = scatter3(lA_t(:,1),lA_t(:,2),lA_t(:,3));
title('Linearly Transformed Atlas and Target Landmarks and Surfaces')

% view the surfaces using the patch command
hsA_a_xformed = patch('faces',fA_a,'vertices',vA_a_xformed);
hsH_a_xformed = patch('faces',fH_a,'vertices',vH_a_xformed);
hsA_t = patch('faces',fA_t,'vertices',vA_t);
hsH_t = patch('faces',fH_t,'vertices',vH_t);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')

% add a light to visualize 3D surfaces with shading
light

% find a nice orientation
view(64,26)

% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA_a_xformed,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH_a_xformed,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA_a_xformed,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH_a_xformed,'FaceColor','y','EdgeColor','none','FaceLighting','phong')

set(hlA_t,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hlH_t,'MarkerFaceColor','g','MarkerEdgeColor','k','LineWidth',2,'sizedata',50)
set(hsA_t,'FaceColor','r','EdgeColor','none','FaceLighting','phong')
set(hsH_t,'FaceColor','g','EdgeColor','none','FaceLighting','phong')

% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
L = legend([hsA_a_xformed hsH_a_xformed hsA_t hsH_t],{'xFormed Amygdala Atlas','xFormed Hippocampus Atlas', 'Amygdala Target', 'Hippocampus Target'});
set(L, 'Position', [0.729, .049, .167, .113])

% save the figure
%set(gcf,'PaperPositionMode','auto')
%saveas(gcf,'1.5.3xFormedAtlasAndTargetLandmarkSurfaces.png')

%% 1.5.4 Spline Based Transformation

sigma = 5;
C = (-1/(2*sigma*sigma));

kernel = zeros(58,58);

for i = 1:58
   for j = 1:58
       kernel(i,j) = exp(C*norm(concatenate_linearxform(i,:) - concatenate_linearxform(j,:))^2);
   end
end

%invKt = inv(kernel);

difference = zeros(58,3);
for i = 1:58
    difference(i,:) = lTarget(i,:) - concatenate_linearxform(i,:); 
end

%Calculate p = invKt * (phix - x)
p = kernel\difference;

%Calculate v = kernel * p
%v has a x, y, z component
v = kernel * p;

%Add v to atlas landmarks. Split into amygdala and hippocampus
lA_a_splinexformed = lA_a_xformed + v(1:20,:);
lH_a_splinexformed = lH_a_xformed + v(21:58,:);

%% 1.5.5 Spline Transform Atlas Landmarks and Atlas Surface Vertices

%Spline Transform Atlas Surface Vertices
numElementsSurface = size(vA_a_xformed,1) + size(vH_a_xformed,1);
concatenate_surfacelinearxform = [vA_a_xformed;vH_a_xformed];
concatenate_splinexform = [lA_a_splinexformed;lH_a_splinexformed];

%Print sum of square error between pairs of landmarks after
%spline transformation
E_spline = sum(sum((concatenate_splinexform - lTarget).^2));

%Each vertex has three components as well
v_surface = zeros(numElementsSurface,3);
for j = 1:numElementsSurface
    v1 = 0;
    v2 = 0;
    v3 = 0;
    for i=1:58
        e_term = exp(C*norm(concatenate_surfacelinearxform(j,:) - concatenate_linearxform(i,:))^2);
        v1 = v1 + e_term*p(i,1);
        v2 = v2 + e_term*p(i,2);
        v3 = v3 + e_term*p(i,3);
    end
    concatenate_surfacelinearxform(j,1)=concatenate_surfacelinearxform(j,1)+v1;
    concatenate_surfacelinearxform(j,2)=concatenate_surfacelinearxform(j,2)+v2;
    concatenate_surfacelinearxform(j,3)=concatenate_surfacelinearxform(j,3)+v3;
end

%Split into amygdala and hippocampus
vA_a_splinexformed = concatenate_surfacelinearxform(1:347,:);
vH_a_splinexformed = concatenate_surfacelinearxform(348:972,:);

% view the landmarks using scatter3
figure;
hlA_a_splinexformed = scatter3(lA_a_splinexformed(:,1),lA_a_splinexformed(:,2),lA_a_splinexformed(:,3));
hold on;
hlH_a_splinexformed = scatter3(lH_a_splinexformed(:,1),lH_a_splinexformed(:,2),lH_a_splinexformed(:,3));
hlH_t = scatter3(lH_t(:,1),lH_t(:,2),lH_t(:,3));
hlA_t = scatter3(lA_t(:,1),lA_t(:,2),lA_t(:,3));
title('Spline Transformed Atlas and Target Landmarks and Surfaces')

% view the surfaces using the patch command
hsA_a_splinexformed = patch('faces',fA_a,'vertices',vA_a_splinexformed);
hsH_a_splinexformed = patch('faces',fH_a,'vertices',vH_a_splinexformed);
hsA_t = patch('faces',fA_t,'vertices',vA_t);
hsH_t = patch('faces',fH_t,'vertices',vH_t);

% fix the axes so x-y-z do not rescale independently
axis image
xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')

% add a light to visualize 3D surfaces with shading
light

% find a nice orientation
view(64,26)

% color the data to make it more interpretable
% feel free to display it any way you think is best
set(hlA_a_splinexformed,'MarkerFaceColor','c','MarkerEdgeColor','k','LineWidth',2,'sizedata',60)
set(hlH_a_splinexformed,'MarkerFaceColor','y','MarkerEdgeColor','k','LineWidth',2,'sizedata',60)
set(hsA_a_splinexformed,'FaceColor','c','EdgeColor','none','FaceLighting','phong')
set(hsH_a_splinexformed,'FaceColor','y','EdgeColor','none','FaceLighting','phong')

set(hlA_t,'MarkerFaceColor','r','sizedata',10)
set(hlH_t,'MarkerFaceColor','g','sizedata',10)
set(hsA_t,'FaceColor','r','EdgeColor','none','FaceLighting','phong')
set(hsH_t,'FaceColor','g','EdgeColor','none','FaceLighting','phong')

% more formatting to make the figure pretty
set(gca,'LineWidth',2,'Box','on','FontSize',12)
L = legend([hsA_a_splinexformed hsH_a_splinexformed hsA_t hsH_t],{'Spline xFormed Amygdala Atlas','Spline xFormed Hippocampus Atlas', 'Amygdala Target', 'Hippocampus Target'});
set(L, 'Position', [0.696, .024, .197, .111])

 % save the figure
set(gcf,'PaperPositionMode','auto')
saveas(gcf,'1.5.5SplinexFormedAtlasandTargetLandmarkSurfaces.png')
