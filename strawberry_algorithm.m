function [P] = strawberry_algorithm(LB, UB, population_size, generation_number, number_of_units, a, b, c, r, beta, demand)
    varSize = number_of_units;
    nPop = population_size;
    nGen = generation_number;
    nMax = 3; % maximum number of runners to generate
    penalty = r;
    temp = [];
    for i = 1:nPop
        for j = 1:varSize
            P(i,j) = LB(j) + rand()*(UB(j) - LB(j)); % initial population generation
        end
    end
    for gen = 1:nGen
        for i = 1:nPop
            N(i) = 0.5*(tanh(4*calcfit(P(i,:), a, b, c, penalty, demand) - 2) + 1);
        end
        [val, indx] = sort(N, 'descend');
        new_Pop = P(indx,:);
        clear P
        P = new_Pop;
        clear new_Pop val indx
        phi_pop = P;
        for i = 1:nPop
            nr = ceil(nMax*N(i)*rand());
            for t = 1:nr
                for j = 1:varSize
                    d(t,j) = 2*(1 - N(i))*0.5*(rand() - 0.5);
                end
            end
            for t = 1:nr
                for j = 1:varSize
                    new_runner(t,j) = P(i,j) + (UB(j) - LB(j))*d(t,j);
                end
            end
            for t = 1:nr
                for j = 1:varSize
                    if new_runner(t,j)<LB(j)
                        new_runner(t,j)=LB(j) + rand()*(UB(j) - LB(j));
                    elseif new_runner(t,j)>UB(j)
                        new_runner(t,j)=LB(j) + rand()*(UB(j) - LB(j));
                    end
                end
            end
            phi_pop = vertcat(phi_pop, new_runner);
        end
        for s = 1:length(phi_pop(:,1))
            N2(s) = 0.5*(tanh(4*calcfit(phi_pop(s,:), a, b, c, penalty, demand) - 2) + 1);
        end
        [vall, indxx] = sort(N2, 'descend');
        new_Pop = phi_pop(indxx,:);
        clear P N2 phi_pop N
        P = new_Pop(1:nPop,:);
        clear new_Pop vall indxx
        penalty = penalty*beta; % penalty
        temp = [temp, calccost(P(1,:), a, b, c, penalty, demand)];
    end
    plot(1:nGen, temp(1:end), 'r-');
    xlabel('Iterations', 'fontsize', 20);
    ylabel('Cost', 'fontsize', 20);
end