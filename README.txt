This is a Matlab wrapper for OPCODE, which is a collision detection
or ray casting library for triangular 3D meshes.

OPCODE uses a couple of different aabb trees to store the mesh and this is
a pretty simple wrapper for one of the trees.

Nice thing about opcode is that it allows for deformable meshes,
meaning that you can update the mesh while it is stored in the tree,
which is much faster than what it takes to rebuild the aabb tree.

Input and output:

To make the tree:
tree = opcodemesh(v,f);
where
vertices v : 3 x nv
faces f : 3 x nf

To intersect:
[hit,d,trix,bary,Q] = tree.intersect(orig,dir);
where
starting points orig : 3 x nc
direction dir : 3 x nc
whether hit or not hit : nc x 1 logical
distance from orig to intersection point d : nc x 1
index into f of the intersection triangle trix : nc x 1
barycentric coordinates of the triangle that the rays intersected bary : 2 x nc
actual 3D coordinates of the intersection poitns Q : 3 x nc
If a ray misses, then you have 0's for trix and nan's for d,bary,Q at that index.

To get the actual 3D coords, you can also do
Qhit = repmat(1-B(2,:)-B(1,:),3,1).*v(:,f(1,T)) + ...
    repmat(B(1,:),3,1).*v(:,f(2,T)) + ...
    repmat(B(2,:),3,1).*v(:,f(3,T));
where B = bary(:,hit), T = trix(hit),
which gives you the coordinates at the intersected points.

To update the mesh with a new set of vertices (as in deform the mesh):
tree.update(vnew);
vnew : 3 x nv
vnew must be the same size and the original set of vertices.
The topology of the mesh cannot change.

To delete the tree (which is actually done automatically by Matlab when the variable is cleared):
tree.delete();

To compile, go to ./src_matlab
and run mexall.m
which compiles the mex code and copies it to ./matlab
(I compile it against everything in opcode, so it's a bit slow.)

To run the demo, go to ./matlab
and run opcodemeshdemo.m

OPCODE is in
http://www.lia.ufc.br/~gilvan/cd/
(which is a more portable version)
and
http://www.codercorner.com/Opcode.htm
(the original site)

Contains much appreciated code from
http://www.mathworks.com/matlabcentral/fileexchange/38964
for nicely wrapping C++ functions in a Matlab class.


Fixes from the previous version:
Fixed compile issues for Win64 by removing all of the assembly code.
You don't need to normalize the direction vectors anymore.
It also returns the actual points now instead of just the barycentric points.
