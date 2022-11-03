//Roleta

clc
clear


rows=[4 6 8]
epocaporrow = [0 0 0]

function c=calcCusto(pop, index)
    soma = 0;

    for m=1:nRows
        for n=1:nRows
            soma = soma + validaRainhas(pop(index,m), pop(index,n), m, n);
        end
    end
    c = soma;
endfunction

function z=validaRainhas(ativa, passiva, indexAtiva, indexPassiva)
    z=0;
    dif = abs(ativa - passiva);
    difIndex = abs(indexAtiva - indexPassiva);

    if(ativa == passiva)then
        z = 1;
    else
        if(dif == difIndex)then
            z = 1;
        end 
    end

    if z <> 1 then
        z = 0;
    end


endfunction

function mostraTabuleiro(pop)

    c = ones(nRows/2, nRows/2).*.[1,8;8,1];
    for i=1:nRows
        if (c(pop(i)+1, i) == 8) || (c(pop(i)+1, i) == 1) then
            c(pop(i)+1, i) = 12;
        else 
            c(pop(i)+1, i) = c(pop(i)+1, i) + 1;
        end
    end
    C = [c];
    Matplot(C);
endfunction


function z=validaRainhas2(ativa, passiva)
    z=0;
    dif = abs(ativa - passiva);
    if pmodulo(dif, nRows-1) == 0 || pmodulo(dif, nRows) == 0 || pmodulo(dif, nRows+1) == 0 then
        // disp('Diagonal');
        z= 1;
    else 
        for count=0:nRows:nRows**2
            if (ativa - count < 0 && ativa - count >= -8 ) && (passiva - count < 0 && passiva - count >= -8 ) then
                // disp('Linha');
                z = 1;
            end
        end
    end

    if z <> 1 then
        z = 0;
    end


endfunction


function mostraTabuleiro2(pop)

    c = ones(nRows/2, nRows/2).*.[1,8;8,1];
    for item=1:nRows
        div = pop(item)/nRows;
        remainder = (div - int(div)) * nRows;
        if (c(int(div)+1, remainder+1) == 8) || (c(int(div)+1, remainder+1) == 1) then
            c(int(div)+1, remainder+1) =  12;
        else
            c(int(div)+1, remainder+1) =  c(int(div)+1, remainder+1) + 1
        end
    end
    C = [c];
    Matplot(C);
endfunction


for epocaRow=1:length(rows)
    totalepoca = 0;
    for rodada=1:5

        nRows=rows(epocaRow); // Sempre multimplo de 2
        nPop=15;
        pop=[];
        bestcusto=10^8;
        bestpop=0;
        epocas=1000;
        epoca = 0;
        //maxNumber = (nRows*nRows)-1;
        maxNumber = nRows-1;

        for i=1:nPop
            for j=1:nRows
                pop(i,j)=round(maxNumber*rand());
            end
        end


        while epoca <> epocas
            epoca = epoca + 1;
            mostraTabuleiro(pop(1,:));
            disp("Época atual: "+string(epoca) + ' / ' + string(epocas) + ' | Tabuleiro ' + string(nRows) + ' | Rodada ' + string(rodada) + ' de 5');
            custo=[];
            for i=1:nPop

                custo(i) = calcCusto(pop, i);

            end
            // disp(custo)
            for i=1:nPop
                if custo(i)<bestcusto then
                    bestcusto=custo(i);
                    bestpop=pop(i, :);
                    if(bestcusto==nRows)then
                        disp('Processo finalizado por resultado ideal!');
                        totalepoca = totalepoca + epoca
                        epoca = epocas;
                    else 
                        disp(bestpop);
                        disp(bestcusto);
                    end
                end
            end
            //Melhor indiv _ end

            //Torneio
            newpop1=[];
            newpop2=[];
            for i=1:nPop
                t1=round(rand()*(nPop-1)+1);
                t2=round(rand()*(nPop-1)+1);
                if custo(t1)<custo(t2) then
                    newpop1(i,:)=pop(t1,:);
                else
                    newpop1(i,:)=pop(t2,:)
                end 
                t1=round(rand()*(nPop-1)+1);
                t2=round(rand()*(nPop-1)+1);
                if custo(t1)<custo(t2) then
                    newpop2(i,:)=pop(t1,:);
                else
                    newpop2(i,:)=pop(t2,:);
                end     
            end
            //Torneio - end
            //Crossover
            newpop=[];
            for i=1:nPop
                for j=1:nRows       
                    //if pmodulo(j,2) == 0 then
                    if j <= nRows/2 then
                        newpop(i, j) = newpop1(i, j);
                    else 
                        newpop(i, j) = newpop2(i, j)
                    end
                    // newpop(i, j)=round(sqrt(newpop1(i, j)*newpop2(i, j))); 
                    //newpop(i, j)=abs(newpop1(i, j)+(maxNumber-2*rand()*(newpop2(i, j)-newpop1(i, j)))); 
                end
            end
            //Crossover _ end

            //Mutação
            for i=1:nPop
                indexMutation = round(rand()*(nRows-1)+1);
                //for j=1:nRows
                //if rand()>=0.95 then

                mutation = round(maxNumber*rand());
                // disp('mutação occoreu de '+ string(newpop(i,j)) + ' para ' + string(mutation));


                newpop(i,indexMutation)=mutation;
                //end
                //end
            end
            //Mutação end
            //oldpop=pop; // Para debugging
            pop=newpop;
            pop(1, :)=bestpop;
            //mostraTabuleiro(bestpop);
        end

        disp('Processo finalizado!');
        disp(bestpop);
        disp((bestcusto-nRows)/2);
        mostraTabuleiro(bestpop);

end
epocaporrow(epocaRow) = totalepoca;
end

disp(epocaporrow)
