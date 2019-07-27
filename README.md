# Spline alignment of amygdala and hippocampus


## 1 Aligning medial temporal lobe anatomy with splines

The alignment will be performed in two stages. First, a 3×3 linear transformation matrix will be estimated and applied to the data. Then a spline based transformation will be estimated and applied to the linearly
transformed data.

## 1.1 The data

There are 8 pieces of data, landmarks and triangulated surfaces for atlas and target hippocampus and amygdala.  
1. Atlas landmarks: *amygdala_01_landmarks.txt, hippocampus_01_landmarks.txt*  
2. Atlas surfaces: *amygdala_01_surface.byu, hippocampus_01_surface.byu*  
3. Target landmarks: *amygdala_05_landmarks.txt,hippocampus_05_landmarks.txt*  
4. Target surfaces: *amygdala_05_surface.byu,hippocampus_05_surface.byu*  


## 1.2 Loading landmarks

Use *read_txt_landmarks.m* with the filename as an input to read landmarks
into a matlab array. The size of the array will be N by 3, for N = 20 for amygdala, and N = 38 for hippocampus. There are a total of 58 landmarks for each the pair of structures.

## 1.3 Loading surfaces

Use *read_byu_surface.m* with the filename as an input to read vertices and faces
matlab arrays. This will output a vertex array, containing a one 3D vertex per row. In addition, it will contain a face array, containing 3 integers per row. Each of these integers corresponds to a row of the vertex array, and describes how they should be connected to form triangles.

## 1.4 Spline and linearly transformed landmarks and surfaces

Results are in Generated Images folder with code in *hip_amyg.m*


