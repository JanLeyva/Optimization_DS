# Cluster-median assignment
# Jan leyva and Andreu Meca

# Number of points
param m; 
set M:={1..m};

# Euclidean distances matrix
param d{M,M};

# Number of clusters
param k;

# Matrix of the results
var x{M,M} binary;

# Cost function
minimize obj: sum{i in M, j in M} d[i,j] * x[i,j];

#Subject to:
# Constraint 1: every point belongs to one cluster 
subject to s1 {i in M}: sum{j in M} x[i,j]=1;
 
# Constraint 2: exactly k clusters
subject to s2 :sum{j in M} x[j,j]=k;

# Constraint 3: a point belong to a cluster-j if the cluster-j exist
subject to s3 {i in M, j in M}: x[j,j]>=x[i,j];