% simple boids simulation
boids_count=15;
boids=Boid.empty;
for i=1:boids_count
    if i < 3 
        boids(i)=Boid(rand*640/3,rand*360/3, 1);
    elseif i >= 3 && i < 6
        boids(i)=Boid(rand*640/3,rand*360/3, 2);
    else
        boids(i)=Boid(rand*640/3,rand*360/3, 0);
    end;
end



flock=Flock(boids,[640/3 360/3]);
f = figure;
plane = Plane(f,[640/3 360/3],boids);
flock.run(plane);

