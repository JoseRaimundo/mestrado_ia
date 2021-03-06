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
t=linspace(0,10,100);
hold on;
sep = ['Sep. = ' num2str(boids(10).r_sep,'%d')];
ali = ['Ali. = ' num2str(boids(10).r_ali,'%d')];
coe = ['Coe. = ' num2str(boids(10).r_coh,'%d')];

h = zeros(3, 1);
h(1) = plot(NaN,NaN,'ok');
h(2) = plot(NaN,NaN,'ok');
h(3) = plot(NaN,NaN,'ok');
lgnd = legend(h, sep,ali,coe);
set(lgnd, 'Box', 'off');


flock.run(plane);


