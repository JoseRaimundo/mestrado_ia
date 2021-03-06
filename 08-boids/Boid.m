classdef Boid
    
    %% Classe boid
    properties
        position
        velocity
        acceleration
        r
        max_force
        max_speed
        r_coh
        r_sep
        r_ali
        r_pre
        tipo
        medo
    end
    
    
    methods
        
        %% Função de criação dos boids
        function obj = Boid(position_x,  position_y, special)
            obj.acceleration = [0 0];
            
            angle = (2*pi).*rand;
            obj.velocity = [cos(angle), sin(angle)];
            
            obj.position = [position_x, position_y];
            obj.r = 1;
            obj.max_speed = 2;
            obj.max_force = 0.1;
            obj.r_coh = 50;
            obj.r_sep = 10;
            obj.r_ali = 20;
            obj.r_pre = 30;
            obj.tipo = 0;
            obj.medo = 30;
            if special == 1
                obj.max_force = 1;
                obj.max_speed = 2.2;
                 obj.r_coh = 30;
                obj.r_ali = 10;
                 obj.r_sep = 7;
                obj.medo = 0.5;
                obj.tipo = 1;
            elseif special == 2
                obj.r_coh = 30;
                obj.r_sep = 30;
                obj.r_ali = 30;
                obj.r_pre = 30;
                obj.tipo = 2;
                obj.medo = 0.5;
            end;
             
        end
        
         
        %% Funcao de calculo da aceleracao
        function obj = apply_force(obj, sep_force, coh_force,  ali_force)
            obj.acceleration = obj.acceleration+sep_force+coh_force+ali_force;
        end
        
        %% Função ancora
        function obj = flock(obj,boids)
            if obj.tipo ~= 2
                sep = obj.seperate(boids);
                ali = obj.align(boids);
                coh = obj.cohesion(boids);
                col = obj.colision(boids);
                predador = obj.predador(boids);

                predador = predador.*5;
                col = col.*5;
                sep = (sep.*5) + predador;
                ali = ali.*5;
                coh = (coh.*5) + col;
                obj=obj.apply_force(sep,coh,ali);
            end
        end
        
        %% Funcao para determinar as bordas
        function obj = borders(obj, lattice_size)
            if obj.position(1) < -obj.r
                obj.position(1)=lattice_size(1)+obj.r;
            end
            
            if obj.position(2) < -obj.r
                obj.position(2)=lattice_size(2)+obj.r;
            end
            
            if obj.position(1) > lattice_size(1) + obj.r
                obj.position(1)=-obj.r;
            end
            
            if obj.position(2) > lattice_size(2) + obj.r
                obj.position(2)=-obj.r;
            end
        end
        
        
                
        %% Funcao para atualizar os boids
        function obj = update(obj)
            if obj.tipo ~= 2
                obj.velocity = obj.velocity + obj.acceleration;
                obj.velocity = obj.velocity./norm(obj.velocity).*obj.max_speed;
                obj.position = obj.position + obj.velocity;
                obj.acceleration = [0 0];
            end
        end        
        
        %% Função para identificar a distância entre os vizinhos
        function [steer] = seek(obj, target)
            desired = target - obj.position;
            desired = norm(desired);
            desired = desired*obj.max_speed;
            
            steer = desired-obj.velocity;
            steer = steer./norm(steer).*obj.max_force;
        end
        
        %% Funcao para calcular a colisao
        function [steer] = colision(obj, boids)
            steer = [0,0];
            count = 0;
            
            for i=1:1:length(boids)
                d(i) =  norm(obj.position - boids(i).position);
            end
                
            for i=1:1:length(boids)
                if boids(i).tipo == 2
                    if d(i) < 10
                        difference = obj.position - boids(i).position ;
                        difference = difference./norm(difference);
                        difference = difference./d(i);
                        steer = steer + difference ;
                        count = count+1; 
                    end

                    if count > 0
                        steer = steer./count;
                    end

                    if norm(steer) > 0
                        steer = steer./norm(steer).*obj.max_speed ;
                        steer = steer + obj.velocity;
                        steer = steer./norm(steer).*obj.max_force  - boids(i).medo;
                    end  
                end
            end
        end
        
        %% Funcao para calcular o predador
        function [steer] = predador(obj, boids)
            steer = [0,0];
            count = 0;
            
            for i=1:1:length(boids)
                d(i) =  norm(obj.position - boids(i).position);
            end
            
            for i=1:1:length(boids)
                if boids(i).tipo == 1 && obj.tipo ~= 1
                    if d(i) < 10
                        difference = obj.position - boids(i).position ;
                        difference = difference./norm(difference);
                        difference = difference./d(i)
                        steer = steer + difference ;
                        count = count+1; 
                    end

                    if count > 0
                        steer = steer./count;
                    end

                    if norm(steer) > 0
                        steer = steer./norm(steer).*obj.max_speed ;
                        steer = steer + obj.velocity;
                        steer = steer./norm(steer).*obj.max_force  - boids(i).medo;
                    end  
                end
            end
        end
        
        
        %% Funcao para calcular a separacao
        function [steer] = seperate(obj, boids)
            desired_separation = obj.r_sep;
            steer = [0,0];
            count = 0;
            for i=1:1:length(boids)
                d(i) =  norm(obj.position - boids(i).position);
            end
            
            for i=1:1:length(boids)
                medo = 0;
                if boids(i).tipo == 2
                    medo = obj.medo;
                    obj.r_coh = 0.1;
                end
                
                if d(i) > 0 && d(i) <  desired_separation
                    difference = obj.position - boids(i).position;
                   
                    
                    difference = difference./norm(difference);
                    difference = difference./d(i);
                    steer = steer + difference ;
                                        
                    count = count+1; 
                end
             
                
                if count > 0
                    steer = steer./count - medo;
                end
                
                
                
                if norm(steer) > 0
                    steer = steer./norm(steer).*obj.max_speed;
                    steer = steer - obj.velocity;
                    steer = steer./norm(steer).*obj.max_force;
                end
            end
        end
        
        
        %% Funcao para calcular o alinhamento
        function steer = align(obj, boids)
            neighbor_dist = obj.r_ali;
            sum = [0 0];
            count = 0;
            steer = [0 0];
            
            for i=1:1:length(boids)
                d(i) =  norm(obj.position - boids(i).position);
            end
            
            for i=1:1:length(boids)
                medo = 0;
                if boids(i).tipo == 2
%                     medo = obj.medo;
                    medo = 0;
                end
                if d(i)>0 && d(i) < neighbor_dist 
                    sum=sum+boids(i).position - medo;
                    count=count+1;
                end
            end
            
            if count > 0
                sum=sum./count;
                sum=sum./norm(sum).*obj.max_speed;
                steer=sum-obj.velocity;
                steer=steer./norm(steer).*obj.max_force;
            end
        end
        
        
        %% Funcao para calcular a coesao
        function steer = cohesion(obj, boids)
            neighbor_dist = obj.r_coh;
            sum = [0 0];
            count = 0;
            steer = [0 0];
            
            for i=1:1:length(boids)
                d(i) =  norm(obj.position - boids(i).position);
            end
            
            for i=1:1:length(boids)
                medo = 0;
                if boids(i).tipo == 2
                    medo = boids(i).tipo;
                end
                if d(i)>0 && d(i) < neighbor_dist
                    sum=sum+boids(i).position + medo;
                    count=count+1;
                end
            end
            
            if count > 0
                sum=sum./count;
                steer = obj.seek(sum);
            end
        end
    end
end

