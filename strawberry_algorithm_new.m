function [P] = strawberry_algorithm_new(LB, UB, population_size, generation_number, norm_hist, gray_levels, alpha, thresh)
    varSize = 2*thresh;
    nPop = population_size;
    nGen = generation_number;
    nMax = 3; % maximum number of runners to generate
    %penalty = r;
    temp = [];
    for i = 1:nPop
        for j = 1:varSize
            P(i,j) = LB(j) + rand()*(UB(j) - LB(j)); % initial population generation
        end
    end
    for gen = 1:nGen
        for i = 1:nPop
            P(i,:) = sort(P(i,:));
            Popul{1,1} = P(i,1:2:end);
            Popul{1,2} = P(i,2:2:end);
            P_cost(i) = type2fuzzy(Popul, norm_hist, gray_levels, alpha, thresh);
            clear Popul
        end
        max_cost = max(P_cost);
        for i = 1:nPop
            N(i) = (exp(P_cost(i)/max_cost)/(1 + exp(P_cost(i)/max_cost))); % sigmoid ///////// % 0.5*(tanh(4*(P_cost(i)/max_cost) - 2) + 1);
        end
        P_cost(1)
        max_cost
        exp(P_cost(1)/max_cost)
        [val, indx] = sort(N, 'descend');
        new_Pop = P(indx,:);
        clear P
        P = new_Pop;
        clear new_Pop val indx P_cost max_cost
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
            phi_pop(s,:) = sort(phi_pop(s,:));
            Popul{1,1} = phi_pop(s,1:2:end);
            Popul{1,2} = phi_pop(s,2:2:end);
            P_cost(s) = type2fuzzy(Popul, norm_hist, gray_levels, alpha, thresh);
            clear Popul
        end
        max_cost = max(P_cost);
        for s = 1:length(phi_pop(:,1))
            N2(s) = (exp(P_cost(s)/max_cost)/(1 + exp(P_cost(s)/max_cost))); % 0.5*(tanh(4*calcfit(phi_pop(s,:), a, b, c, penalty, demand) - 2) + 1);
        end
        [vall, indxx] = sort(N2, 'descend');
        new_Pop = phi_pop(indxx,:);
        clear P N2 phi_pop N P_cost max_cost
        P = new_Pop(1:nPop,:);
        clear new_Pop vall indxx
      %  penalty = penalty*beta; % penalty
        PX(1,:) = sort(P(1,:));
        Popul{1,1} = PX(1,1:2:end);
        Popul{1,2} = PX(1,2:2:end);
        Pcost = type2fuzzy(Popul, norm_hist, gray_levels, alpha, thresh);
        clear Popul PX
        temp = [temp, Pcost];
        clear Pcost
    end
    figure
    plot(1:nGen, temp(1:end), 'r-');
    xlabel('Iterations', 'fontsize', 20);
    ylabel('Fitness', 'fontsize', 20);
end