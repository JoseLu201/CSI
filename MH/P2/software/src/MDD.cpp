#include "MDD.hpp"
#include <string>
#include <iostream>
#include <algorithm>
#include "random.hpp"
#include <vector>
#include <set>
#include<queue>


using namespace std;
using std::remove;
using namespace std::chrono;

using Random = effolkronium::random_static;

MDD::MDD(int n, int m){
    this->n = n;
    this->m = m;
    this->datos.resize(n,vector<float>(n));
    this->distan.resize(m); 
}

void MDD::leer_fichero(string nombre_fichero){
    float dist;
    string t1;
    ifstream file(nombre_fichero);
    getline(file,t1);
    int i =0,j=0;
    while (file >> i >> j >> dist)
        datos[i][j] = dist;
    file.close();
    //cout << "archivo cerrado" << endl;
}
//Non binary solution
float MDD::distPuntoRestoElemenetosNonBin(int f,vector<int> v){
    float dist = 0;
    for(int i = 0; i < v.size();i++){
        dist+=this->datos[f][v[i]];
        if(datos[f][v[i]] < 0 || datos[f][v[i]] == 0)
            dist+= datos[v[i]][f];
    }
    return dist;
}
float MDD::distPuntoRestoElemenetos(int f,vector<int> v){
    float dist = 0;

    for(int i = 0; i < v.size();i++){
        if(v[i] != 0){
            dist+=this->datos[f][i];
            if(datos[f][v[i]] < 0 || datos[f][i] == 0)
                dist+= datos[i][f];
        }
    }
    return dist;
}


float MDD::diffNonBin(vector<int> posib){
    vector<float> distancias;
    for(int i = 0; i < posib.size();i++)
        distancias.push_back(distPuntoRestoElemenetosNonBin(posib[i],posib));
    int min =  std::min_element(distancias.begin(),distancias.end()) - distancias.begin();
    int max =  std::max_element(distancias.begin(),distancias.end()) - distancias.begin();
    return (distancias[max] - distancias[min] );
}

float MDD::diff(vector<int> posib){
    vector<float> distancias;
    for(int i = 0; i < posib.size();i++)
        if(posib[i] != 0)
            distancias.push_back(distPuntoRestoElemenetos(i,posib));
    
    int min =  std::min_element(distancias.begin(),distancias.end()) - distancias.begin();
    int max =  std::max_element(distancias.begin(),distancias.end()) - distancias.begin();
    return (distancias[max] - distancias[min] );
}


float MDD::fit_adding(vector<int> posib, int new_i){
    float new_diff =std::numeric_limits<double>::infinity(); 
    if(posib[new_i] != 1){
        posib.at(new_i) = 1;
        new_diff = diff(posib);
        posib.at(new_i) = 0;
    }else {cout << "ERROR: El valor añadido ya esta en la solucion " << endl;
    for(auto& i : posib)
        cout << i << " ";
    cout << "Index" << new_i << endl;

   }
    return new_diff;
}

//Este es el bueno
vector<int> MDD::greedy(){
    vector<int> solucion(this->n,0);
    vector<int> cand;

    for(int i = 0; i < this->n;i++){
        cand.push_back(i);
    }
    int max = this->n;
    auto rand = Random::get(0,max);
    solucion.at(rand) = 1;
    cout << "First select1 " << rand << endl;
    std::remove(cand.begin(),cand.end(),rand);
    cand.resize(cand.size()-1);
    while(count(solucion.begin(), solucion.end(), 1) != this->m ){
        float new_fitness;
        int pos = 0;
        float min = 10000000.0f;

        for(auto ele : cand){            
            new_fitness = fit_adding(solucion,ele);
            cout << "Fitness añadiendo " << ele << " es " << new_fitness << endl;
            if(new_fitness < min){
                pos = ele;
                min = new_fitness;    
            }
        }
        cout << "Minimo encontrado en " << pos << endl;   
        for(auto& i : solucion)
                cout << i << " ";
            cout << endl;
        if(solucion.at(pos) != 1){
            //cout << "Elemento seleccionado" << pos << endl;
            solucion.at(pos)= 1;
        }
        std::remove(cand.begin(),cand.end(),pos);
        cand.resize(cand.size()-1);
    }
    return solucion;
}



/*
Calcula la distancia desde un punto al resto de los pntos del vector
f -> es la fila sobre la que se aplica,
v -> es un vector con los indices de las columnas sobre las que se suman
*/


/*

01011100001
1,4,12
*/


/*
Calcula la distancia de un punto al resto de puntos y lo almacena en un vector de distancias

Si hacemos una susticution en vez de calcular otra vez solo hago el calculo del cambio


(0,4,6)
D0 = D04 + D06  //Esta ya no lo necesito
D4 = D40 + D46  //Si cambio el 0 por un 1 D4 = D4 -D04 + D14
D6 = D60 + D64

1 0 0 0 1 0 1 -> 0 1 0 0 1 0 1
*/

float MDD::distFactorizada(vector<int> sol,pair<int,int> cambio){
    float disp = 0;
    for(int i = 0; i < sol.size();i++)
        this->distan[i] = distPuntoRestoElemenetos(sol[i],sol);

    int last_pos = sol[cambio.first] ;
    sol[cambio.first] = cambio.second;
    this->distan[cambio.first] = distPuntoRestoElemenetos(cambio.second,sol);

    for(auto i =0; i < sol.size();i++){
        if(i != cambio.first){     
               
            if(this->datos[last_pos][sol[i]] != 0){
                if(this->datos[cambio.second][sol[i]] != 0){
                    this->distan[i] = this->distan[i] - this->datos[last_pos][sol[i]] + this->datos[cambio.second][sol[i]];
                }
                else{
                    
                    this->distan[i] = this->distan[i] - this->datos[last_pos][sol[i]] + this->datos[sol[i]][cambio.second];
                }
            }else{
                if(this->datos[cambio.second][sol[i]] != 0){
                    
                    this->distan[i] = this->distan[i] - this->datos[sol[i]][last_pos] + this->datos[cambio.second][sol[i]];
                }else{ 
                   
                    this->distan[i] = this->distan[i] - this->datos[sol[i]][last_pos] + this->datos[sol[i]][cambio.second];
                }
            }
        }
    }

    sort(distan.begin(), distan.end());
    return (distan[distan.size()-1] - distan[0] );
    
}

float MDD::distFactorizadaNonBin(vector<int> sol,pair<int,int> cambio){
    float disp = 0;
    for(int i = 0; i < sol.size();i++){
        this->distan[i] = distPuntoRestoElemenetosNonBin(sol[i],sol);
        //cout << sol[i] << " ";
        }

    int last_pos = sol[cambio.first] ;
    sol[cambio.first] = cambio.second;
    this->distan[cambio.first] = distPuntoRestoElemenetosNonBin(cambio.second,sol);

    for(auto i =0; i < sol.size();i++){
        if(i != cambio.first){     
               
            if(this->datos[last_pos][sol[i]] != 0){
                if(this->datos[cambio.second][sol[i]] != 0){
                    this->distan[i] = this->distan[i] - this->datos[last_pos][sol[i]] + this->datos[cambio.second][sol[i]];
                }
                else{
                    
                    this->distan[i] = this->distan[i] - this->datos[last_pos][sol[i]] + this->datos[sol[i]][cambio.second];
                }
            }else{
                if(this->datos[cambio.second][sol[i]] != 0){
                    
                    this->distan[i] = this->distan[i] - this->datos[sol[i]][last_pos] + this->datos[cambio.second][sol[i]];
                }else{ 
                   
                    this->distan[i] = this->distan[i] - this->datos[sol[i]][last_pos] + this->datos[sol[i]][cambio.second];
                }
            }
        }
    }

    sort(distan.begin(), distan.end());
    return (distan[distan.size()-1] - distan[0] );
    
}


/*
Genero una solucion aleatoria y luego seria ir intercambiando para generar los vecinos

Una forma de cambiar los indices seria hacer hacer una pareja de valores en la cual la primera 
posicion es el valor que cambias y el segundo seria por el cual lo cambias, con esto podemos mejorar en memoria

Para factorizar la funcion de evaluacion si solo cambiamos un elemento en los vecinos, no tendriamos que 
volver a recalcular todos los valores por solo cambiar uno

ejemplo

(0,4,6)
D0 = D04 + D06  //Esta ya no lo necesito
D4 = D40 + D46  //Si cambio el 0 por un 1 D4 = D4 -D04 + D14
D6 = D60 + D64

1 0 0 0 1 0 1 -> 0 1 0 0 1 0 1


*/


vector<int> MDD::BL(){
    vector<int> solucion;
    vector<int> cand;

    for(int i = 0; i < this->n;i++)
        cand.push_back(i);
    
    int rand;
    for(int i = 0; i < this->m;i++){
        rand = Random::get(0,this->n-1);
        if(std::find(solucion.begin(), solucion.end(), rand) == solucion.end())
            solucion.push_back(rand);
        else{
             rand = Random::get(0,this->n-1);
             solucion.push_back(rand);
        }
    } 
    Random::shuffle( cand.begin( ), cand.end( ) );


    pair<int,int> cambio;
    int index = 0;
    float new_disp;
    bool change = true;
    bool first = true;
    int maxIters = 100000;
    int iter = 0;

    while(iter < maxIters && change == true){
        if(first){
            change = false;
            first = false;
        }
        for(int i = 0; i < cand.size();i++){
            float actual_disp = diff(solucion);
            cambio = make_pair(index,cand[i]);
            new_disp = distFactorizada(solucion,cambio);  
            new_disp = round( new_disp * 1000.0 ) / 1000.0; //Redondeo a 3 cifras por error en los datos
            actual_disp = round( actual_disp * 1000.0 ) / 1000.0;                                            
            if(new_disp < actual_disp  ){
                solucion[index] = cand[i];
                index = (index +1)%(solucion.size());
                change = true;
                i = -1;
                
            }
            if(!change && solucion[index] != solucion[solucion.size()-1]){
                if(cand[i] == cand[cand.size()-1]){
                    index = (index +1)%(solucion.size());
                    i = -1;
                }
            }
            if(solucion[index] == solucion[solucion.size()-1]){
                if(change){
                    index = 0 ;
                    i = -1;
                    change = false;
                }
            }
            iter++;
        }
        index = (index +1)%(solucion.size());
    }
    return solucion;
}

void printi(vector<int> v){
    cout << "[";
    for(auto a : v)
        cout << a << " ";
    cout << "]\n";
}



void MDD::print_check(){
    for(auto& row: datos){
        for(auto& col : row){
            cout << col <<"\t";
        }
        cout <<endl;
    }
}
/*
Funcion que genera una pareja de hijos de forma uniforme dados 2 padres
*/
pair<vector<int>,vector<int>> MDD::generarHijosUniforme(vector<int> p1,vector<int> p2){
    vector<int> hijo1(p1.size(),0);
    vector<int> hijo2(p1.size(),0);
    
    pair<vector<int>, vector<int>> ans;

    for(auto i = 0; i < p1.size(); i++){
        if(p1[i] == p2[i]){
            hijo1[i] = p1[i];
            hijo2[i] = p1[i];
        }else{
            hijo1[i] = Random::get(0,1);
            hijo2[i] = Random::get(0,1);
        }
    }
        
    reparar(hijo1);
    reparar(hijo2);
    ans.first = hijo1;
    ans.second= hijo2;
    return ans;
}

vector<int> MDD::reparar(vector<int> hijo){
    vector<int> seleccionados;
    vector<float> contribucion;
    float average = 0.0;
    
    for(auto row : this->datos){
        for(auto i : row){
            average+=i;
        }
    }
    int v = count(hijo.begin(), hijo.end(),1);
    /*if (v == m){
        return hijo;
    }else if( v > m){ //Si sobran elementos
        while(v != m){
            for(int i = 0; i < hijo.size();i++){
                if(hijo[i] == 1){
                    for(auto j : hijo){
                        if(hijo[i] != j)
                    }
                }
            }
        }

        

    }*/

    return hijo;
}

/*
Funcion que genera una pareja de hijos mediante posicion dados 2 padres
*/
pair<vector<int>,vector<int>> MDD::generarHijosPosicion(vector<int> p1,vector<int> p2){
    vector<int> hijo1(p1.size(),0);
    vector<int> hijo2(p1.size(),0);
    pair<vector<int>, vector<int>> ans;
    vector<int> resto, resto2;

    if(p1 == p2){
        ans.first = p1;
        ans.second = p1;
        return ans;
    }

    for(auto i = 0; i < p1.size();i++){
        if(p1[i] != p2[i]){
            if(p1[i] == 0 && p2[i] == 1){
                resto.push_back(0);}
            else if(p1[i] == 1 && p2[i] == 0){
                resto.push_back(1);}
        }else{
            continue;
        }
    }
    resto2 = resto;
    Random::shuffle(resto);
    Random::shuffle(resto2);
    int j = 0;
    for(auto i = 0; i < p1.size(); i++){
        if(p1[i] == p2[i]){
            hijo1[i] = p1[i];
            hijo2[i] = p1[i];
        }else{
            hijo1[i] = resto[j];
            hijo2[i] = resto2[j];
            j++;
        }
    }
    ans.first = hijo1;
    ans.second= hijo2;
    return ans;
}

/*
Crea un individuo cumpliendo las restricciones
*/
vector<int> MDD::generarPoblacion(){
    vector<int> poblacion(this->n,0);
    
    while(count(poblacion.begin(),poblacion.end(),1) != this->m){
        int i = Random::get(0,n);
        if(poblacion[i] == 0)
            poblacion[i] = 1;
        else continue;
    }    
    return poblacion;
}

/*
Funcion que escoge entre "indiv_torneo" (numero de individuos a participar en el torneo) el mejor de ellos 
*/
int MDD::torneo(vector<vector<int>> poblacion, vector<float> fitness_i, int indiv_torneo){
    set<int> torneo;
    float worst = std::numeric_limits<double>::infinity();
    int winner = -1;
    int TAM = poblacion.size();
    /*Selecciono "indiv_torneo" individuos diferentes*/
    while(torneo.size() != indiv_torneo)
        torneo.insert( Random::get(0,TAM-1));
    //Me quedo con el que tenga mejor fitness
    for(auto i : torneo){
        if(fitness_i[i] < worst  ){
            worst = fitness_i[i];
            winner = i;
        }
    }
    return winner;
}

/*
Funcion que escoge n elementos ganadores del torneo
*/
set<int> MDD::seleccion(vector<vector<int>> poblacion,vector<float> fitness_i, int n){
    set<int> winner;
    for(int i = 0; i< n /*&& winner.size() != n*/;i++)
        winner.insert( torneo(poblacion,fitness_i,n));
    return winner;
}



vector<int> MDD::AGG_uniforme(){
    const int TAM = 50;
    const int MAX_ITERS = 100000;
    int iters = 0;

    vector<int> hijo(this->n-1,0);  //Solucion del mejor hijo tras las iteraciones
    vector<vector<int>> poblacion(TAM,vector<int>(this->n-1,0)); //Poblacion de individuos
    vector<vector<int>> hijos;                                      //Poblacion de hijos que sustituira a la poblacion actual tras un ciclo.
    vector<float> fitness_i;                                     //Distancia acumulada de cada individuo de la poblacion
    
    //Generamos una poblacion y calculamos su distancia
    for(auto &row : poblacion){
        row = generarPoblacion();
        fitness_i.push_back(diff(row));
    }


    while(iters < MAX_ITERS){

        //Nesesito buscar el mejor padre
        int best_i =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin(); //Indice del mejor
        float best_fit = fitness_i[best_i];                                                     //Mejor fit
        vector<int> best_father = *(poblacion.begin() + best_i);

        int desp = 0;
        pair<vector<int>,vector<int>> pair_child;
        //int num_cruces = 0.7*poblacion.size()*2;

        //          Cruzamos
       //Generamos tantos torneos como individuos en la poblacion
        for(auto row = poblacion.begin(); row != poblacion.end();row++){
            auto p2 = next(row);
            if(Random::get<bool>(0.7) && p2 != poblacion.end()){
                //Generar una pareja de hijos
                pair_child = generarHijosUniforme(*row, *p2); 

                hijos.insert(hijos.begin()+desp ,pair_child.first);
                fitness_i[desp] = diff(pair_child.first);

                hijos.insert(hijos.begin()+desp+1 ,pair_child.second);
                fitness_i[desp+1] = diff(pair_child.second);
                desp+=2;
                row = std::next(row);
            }else{
                hijos.insert(hijos.begin()+desp ,*row);
                desp++;
            }
        }

        //Tocar MUTAR
        int num_mutaciones_esperado = 0.1*this->n * this->m;
        int count = 0;
        
        while(count != num_mutaciones_esperado){
            //escojo e un individuo aleatoriamente y dos genes distintos para intercambiar

            int cromos = Random::get(0,TAM-1);
            int gen1,gen2;
            do{
                gen1 = Random::get(0,this->n-1);
                gen2 = Random::get(0,this->n-1);
            }while(gen1 == gen2);
                      
            if((*(hijos.begin()+cromos))[gen1] != (*(hijos.begin()+cromos))[gen2]){
                std::iter_swap((*(hijos.begin()+cromos)).begin()+gen1, (*(hijos.begin()+cromos)).begin() + gen2);
                fitness_i[cromos] = diff(*(hijos.begin()+cromos));
            }
            count++;
        }

        //Cambio la poblacion actual por la de los hijos
        poblacion.clear();
        poblacion.resize(TAM,vector<int>(this->n-1,0));
        
        poblacion = hijos;
        hijos.clear();

        //Si no encuentro el mejor individuo de la poblacion reemplazo el peor 
        if( find(fitness_i.begin(), fitness_i.end(), best_fit) == fitness_i.end() ){
            int worst_i =  std::max_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
            fitness_i[worst_i] = best_fit;
            *(poblacion.begin() + worst_i) = best_father;
        }
       iters++;
    }
    //Escogo el mejor
    int best =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
    hijo = (*(poblacion.begin()+ best));     

return hijo;
}

vector<int> MDD::AGG_posicion(){
    const int TAM = 50;
    const int MAX_ITERS = 100000;
    vector<int> hijo(this->n-1,0);
    vector<vector<int>> poblacion(TAM,vector<int>(this->n-1,0));
    vector<vector<int>> hijos;
    vector<float> fitness_i;
    int iters = 0;
    
    //Generamos una poblacion y calculamos su distancia
    for(auto &row : poblacion){
        row = generarPoblacion();
        fitness_i.push_back(diff(row)); 
    }
    
    while(iters < MAX_ITERS){

        //Nesesito buscar el mejor padre
        int best_i =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
        float best_fit = fitness_i[best_i];
        vector<int> best_father = *(poblacion.begin() + best_i);


        int desp = 0;
        pair<vector<int>,vector<int>> pair_child;
        int num_cruces = 0.7*poblacion.size()*2;

        //          Cruzamos
       
        for(auto row = poblacion.begin(); row != poblacion.end();row++){
            auto p2 = next(row);
            if(Random::get<bool>(0.7) && p2 != poblacion.end()){
                //Generar una pareja de hijos
                pair_child = generarHijosPosicion(*row, *p2);

                hijos.insert(hijos.begin()+desp ,pair_child.first);
                fitness_i[desp] = diff(pair_child.first);

                hijos.insert(hijos.begin()+desp+1 ,pair_child.second);
                fitness_i[desp+1] = diff(pair_child.second);
                desp+=2;
                row = std::next(row);
            }else{
                hijos.insert(hijos.begin()+desp ,*row);
                desp++;
            }
            iters++;
        }

        //Tocar MUTAR
         //inicioMuta= high_resolution_clock::now();
       
        int count = 0;
        int num_mutaciones_esperado = 0.1*this->n * TAM;
        
        while(count != num_mutaciones_esperado){
            //inicioCruce = high_resolution_clock::now();
            int cromos = Random::get(0,TAM-1);
            int gen1,gen2;
            
            do{ 
                gen1 = Random::get(0,this->n-1);
                gen2 = Random::get(0,this->n-1);
            }while(gen1 == gen2);
           
            if((*(hijos.begin()+cromos))[gen1] != (*(hijos.begin()+cromos))[gen2]){
                std::iter_swap((*(hijos.begin()+cromos)).begin()+gen1, (*(hijos.begin()+cromos)).begin() + gen2);
                fitness_i[cromos] = diff(*(hijos.begin()+cromos));
            }
            count++;
        }
        poblacion.resize(TAM,vector<int>(this->n-1,0));
        
        poblacion = hijos;
        hijos.clear();


        if( find(fitness_i.begin(), fitness_i.end(), best_fit) == fitness_i.end() ){
            int worst_i =  std::max_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
            fitness_i[worst_i] = best_fit;
            *(poblacion.begin() + worst_i) = best_father;
        }

    }

    //Escogo el mejor
    int best =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
    hijo = (*(poblacion.begin()+ best));    

    return hijo;
}

vector<int> MDD::AGE_uniforme(){
    const int TAM = 50;
    const int MAX_ITERS = 100000;
    vector<int> hijo(this->n-1,0);
    vector<vector<int>> poblacion(TAM,vector<int>(this->n-1,0));
    vector<vector<int>> hijos;
    vector<float> fitness_i;
    vector<float> fitness_padre;
    int iters = 0;

    for(auto &row : poblacion){
        row = generarPoblacion();
        fitness_i.push_back(diff(row));
    }

    //inicioLoop = high_resolution_clock::now();
    while(iters < MAX_ITERS){
        //inicioCruce = high_resolution_clock::now();
        //Nesesito buscar el mejor padre
        int best_i =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
        float best_fit = fitness_i[best_i];
        vector<int> best_father = *(poblacion.begin() + best_i);


        //Seleccionamos

        //auto selected = seleccion(poblacion,fitness_i,2);


        int desp = 0;
        pair<vector<int>,vector<int>> pair_child;
        int num_cruces = 0.7*poblacion.size()*2;



        //          Cruzamos

        //pair_child = generarHijosUniforme(, *p2);
        
       
        for(auto row = poblacion.begin(); row != poblacion.end();row++){
            auto p2 = next(row);
            if(Random::get<bool>(0.7) && p2 != poblacion.end()){
                //Generar una pareja de hijos
                pair_child = generarHijosUniforme(*row, *p2);

                hijos.insert(hijos.begin()+desp ,pair_child.first);
                fitness_i[desp] = diff(pair_child.first);

                hijos.insert(hijos.begin()+desp+1 ,pair_child.second);
                fitness_i[desp+1] = diff(pair_child.second);
                desp+=2;
                row = std::next(row);
            }else{
                hijos.insert(hijos.begin()+desp ,*row);
                desp++;
            }
        }

        //Tocar MUTAR
         //inicioMuta= high_resolution_clock::now();
        int num_mutaciones_esperado = 0.1*this->n * TAM;
        int count = 0;
        
        while(count != num_mutaciones_esperado){
            //inicioCruce = high_resolution_clock::now();
            int cromos = Random::get(0,TAM-1);
            int gen1,gen2;
            do{
                gen1 = Random::get(0,this->n-1);
                gen2 = Random::get(0,this->n-1);
            }while(gen1 == gen2);
            pair<int,int> muted_gens;
            muted_gens = make_pair(gen1,gen2);
             

           
            if((*(hijos.begin()+cromos))[gen1] != (*(hijos.begin()+cromos))[gen2]){
                std::iter_swap((*(hijos.begin()+cromos)).begin()+gen1, (*(hijos.begin()+cromos)).begin() + gen2);
                //fitness_i[cromos] = distFactorizada(*(hijos.begin()+cromos),muted_gens);
                //|||||| CAMBIAR ESTO ES INEFICIENTE POR EL FACTORIZADO
                fitness_i[cromos] = diff(*(hijos.begin()+cromos));
            }
            
            count++;
        }
        


        
        poblacion.clear();
        poblacion.resize(TAM,vector<int>(this->n-1,0));
        
        poblacion = hijos;
        hijos.clear();

        //cout << "Best padre " << best_fit << endl;
        //Si no encuentro reemplazo el peor 
        if( find(fitness_i.begin(), fitness_i.end(), best_fit) == fitness_i.end() ){
            int worst_i =  std::max_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
            fitness_i[worst_i] = best_fit;
            *(poblacion.begin() + worst_i) = best_father;
        }



        
        //cout << endl << "---------------------------------------------------------------"<<endl;
        //cout << endl << "---------------------------  GENERACION  "<<  iters <<"  ----" << endl;
        //cout << endl << "---------------------------------------------------------------"<<endl;
        

       iters++;
    }


    
    int best =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
    //Escogo el mejor
    hijo = (*(poblacion.begin()+ best));     

return hijo;
}

vector<int> MDD::AGE_posicion(){
    const int TAM = 50;
    const int MAX_ITERS = 100000;
    int idx = 0;
    int iters = 0;

    vector<int> hijo(this->n-1,0);
    vector<vector<int>> poblacion(TAM,vector<int>(this->n-1,0));
    vector<vector<int>> hijos;

    vector<float> fitness_i;
    vector<float> fitness_hijo;
    

    bool sustitucion = true; 
    
    for(auto &row : poblacion){
        row = generarPoblacion();
        fitness_i.push_back(diff(row)); 
    }
     
     int worst_i,second_worst;
    //float fit_first,fit_second;
    while(iters < MAX_ITERS){
       auto inicioLoop = high_resolution_clock::now();
       
        //auto iniciosel= high_resolution_clock::now();
        set<int> selected = MDD::seleccion(poblacion,fitness_i,2);
        //auto finsel= high_resolution_clock::now();
        /*cout << "Selecciono  "  ;
        for(auto i : selected)
            cout << i << " ";
        cout << endl; */
        //cout <<"La seleccion tarda : " <<  (duration_cast<std::chrono::milliseconds>(finsel - iniciosel)).count() << endl;

        

        int desp = 0;
        pair<vector<int>,vector<int>> pair_child;

        //          Cruzamos
        //auto iniciocruze= high_resolution_clock::now();
        int first = *(selected.begin());
        selected.erase(first);
        int sec = *(selected.begin());

        pair_child = generarHijosPosicion(*(poblacion.begin()+first), *(poblacion.begin()+sec));
        hijos.push_back(pair_child.first);
        hijos.push_back(pair_child.second);
  
        //auto fincruze = high_resolution_clock::now();
        //cout <<"El cruze tarda : " <<  (duration_cast<std::chrono::milliseconds>(fincruze - iniciocruze)).count() << endl;
        //Tocar MUTAR
        //auto inicioMuta= high_resolution_clock::now();
       
        int count = 0;
        int num_mutaciones_esperado = 0.1*2*n;
        int hijos_size = hijos.size();
        bool mut = false;

        //!!!! EN VEZ DE HACER N MUTACIONES HCAER 2 Y A MAMARLA
        while(count != num_mutaciones_esperado){
            //inicioCruce = high_resolution_clock::now();
            int cromos = Random::get(0,hijos_size-1);
            //cout << "Eligo el hijo " << cromos << endl;
            int gen1,gen2;
            
            do{ 
                gen1 = Random::get(0,this->n-1);
                gen2 = Random::get(0,this->n-1);
            }while((*(hijos.begin()+cromos))[gen1] != (*(hijos.begin()+cromos))[gen2]);

            std::iter_swap((*(hijos.begin()+cromos)).begin()+gen1, (*(hijos.begin()+cromos)).begin() + gen2);
            fitness_hijo.push_back(diff((*(hijos.begin()+cromos))));

            count++;
        }


        //Busco los 2 peores elementos de 
       
        //if(sustitucion){
            worst_i =  std::max_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
            float tmp1 = fitness_i[worst_i];
            fitness_i[worst_i] = -1;
            second_worst = std::max_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
            fitness_i[worst_i] = tmp1;

        //} 
        float fit_first = fitness_hijo.at(0);
        float fit_second = fitness_hijo.at(1);

        //cout << "Peores elementos " << worst_i <<" con "<< fitness_i[worst_i] <<" , " << second_worst <<" con "<< fitness_i[second_worst]  <<endl;
        //cout << "Fit de los hijos " << fit_first<< " , " << fit_second<<endl;

          
        if(fit_first < fit_second){ //Si el primer hijo es mejor que el segundo
            if(fit_first < fitness_i[worst_i] ){ // Cambio el mejor por el peor
                //cout << "Subsitucion 1" << endl;
                (*(poblacion.begin()+worst_i)) = (*(hijos.begin()));
                fitness_i[worst_i] = fit_first;
                //sustitucion = true;
                if(fit_second < fitness_i[second_worst] ){ // Cambio el mejor por el peor
                    (*(poblacion.begin()+second_worst)) = (*(hijos.begin()+1));
                    fitness_i[second_worst] = fit_second;

                }//else sustitucion = false;
                
            }//else sustitucion = false;

        }else{
            if(fit_second < fitness_i[worst_i] ){ // Cambio el mejor por el peor
                //cout << "Subsitucion 2" << endl;
                (*(poblacion.begin()+worst_i)) = (*(hijos.begin()+1));
                fitness_i[worst_i] = fit_second;
                //sustitucion = true;
                if(fit_first < fitness_i[second_worst] ){
                    (*(poblacion.begin()+second_worst)) = (*(hijos.begin()));
                    fitness_i[second_worst] = fit_first;
                }//else sustitucion = false;
                
            }//else sustitucion = false;
        }
        

        hijos.clear();
        fitness_hijo.clear();


        //auto finMuta= high_resolution_clock::now();
        //cout <<"La mutacion tarda : " <<  (duration_cast<std::chrono::milliseconds>(finMuta - inicioMuta)).count() << endl;

        
        //cout << endl << "---------------------------------------------------------------"<<endl;
        //cout << endl << "------  GENERACION  "<<  iters <<"  --------------------" << endl;
        //cout << endl << "---------------------------------------------------------------"<<endl;
        iters++;

        auto finLoop = high_resolution_clock::now();
         //cout <<" La generacion tarda : " <<  (duration_cast<std::chrono::milliseconds>(finLoop - inicioLoop)).count() << endl;
    }


    int best =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
    //cout << "Best index " << best << endl;
    //Escogo el mejor
    hijo = (*(poblacion.begin()+ best));    
    /*cout << "Best individuo " << endl; 
    for(auto e : hijo)
        cout << e << " ";
    cout << endl;
    cout << "Real cost " << diff(hijo) << endl;*/
return hijo;

}


vector<int> MDD::AM_all(){
    const int TAM = 50;
    const int MAX_ITERS = 100000;
    vector<int> hijo(this->n-1,0);
    vector<vector<int>> poblacion(TAM,vector<int>(this->n-1,0));
    vector<vector<int>> hijos;
    vector<float> fitness_i;
    vector<float> fitness_padre;
    int iters = 0;
    int idx = 1;
    int dd = 0;
    
    
    for(auto &row : poblacion){
        row = generarPoblacion();
        fitness_i.push_back(diff(row)); 
    }
    
    auto inicioLoop = high_resolution_clock::now();
    while(iters < MAX_ITERS){
        bool bl = false;
        //inicioCruce = high_resolution_clock::now();
        //Nesesito buscar el mejor padre
        
        int best_i =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
        float best_fit = fitness_i[best_i];
       // cout << "Iteracion " << iters << endl;
        //cout << "En esta gen encontramos el mejor elemento en " << best_i << " con fitt = " << best_fit << endl;
        vector<int> best_father = *(poblacion.begin() + best_i);


        int desp = 0;
        pair<vector<int>,vector<int>> pair_child;
        int num_cruces = 0.7*poblacion.size()*2;

        //          Cruzamos
       
        for(auto row = poblacion.begin(); row != poblacion.end();row++){
            auto p2 = next(row);
            if(Random::get<bool>(0.7) && p2 != poblacion.end()){
                //Generar una pareja de hijos
                pair_child = generarHijosPosicion(*row, *p2);

                hijos.insert(hijos.begin()+desp ,pair_child.first);
                fitness_i[desp] = diff(pair_child.first);

                hijos.insert(hijos.begin()+desp+1 ,pair_child.second);
                fitness_i[desp+1] = diff(pair_child.second);
                desp+=2;
                row = std::next(row);
            }else{
                hijos.insert(hijos.begin()+desp ,*row);
                desp++;
            }
            iters++;
            //cout << "Iteraciones " << iters << endl;
            if(iters == 10*idx){
                bl = true;
            }
        }
        //cout << "muto " <<endl;
        //Tocar MUTAR
         //inicioMuta= high_resolution_clock::now();
       
        int count = 0;
        int num_mutaciones_esperado = 0.1*this->n * TAM;
        
        while(count != num_mutaciones_esperado){
            //inicioCruce = high_resolution_clock::now();
            int cromos = Random::get(0,TAM-1);
            int gen1,gen2;
            
            do{ 
                gen1 = Random::get(0,this->n-1);
                gen2 = Random::get(0,this->n-1);
            }while(gen1 == gen2);
           
            if((*(hijos.begin()+cromos))[gen1] != (*(hijos.begin()+cromos))[gen2]){
                std::iter_swap((*(hijos.begin()+cromos)).begin()+gen1, (*(hijos.begin()+cromos)).begin() + gen2);
                fitness_i[cromos] = diff(*(hijos.begin()+cromos));
            }
            count++;
        }
                
        //poblacion.clear();
        poblacion.resize(TAM,vector<int>(this->n-1,0));
        
        poblacion = hijos;
        hijos.clear();

        //cout << "Best padre " << best_fit << endl;
        //Si no encuentro reemplazo el peor 
        if( find(fitness_i.begin(), fitness_i.end(), best_fit) == fitness_i.end() ){
            int worst_i =  std::max_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
            fitness_i[worst_i] = best_fit;
            *(poblacion.begin() + worst_i) = best_father;
        }
       
        auto finLoop = high_resolution_clock::now();
        //cout <<" La generacion tarda : " <<  (duration_cast<std::chrono::milliseconds>(finLoop - inicioLoop)).count() << endl;
       /* dd=0;
        for(auto row : poblacion){
            for(auto e : row){
                cout << e << " ";
            }
            cout << "\t" << fitness_i[dd] << endl;
            dd++;
        }*/

        
        //cout << "->>Generacion " << iters << endl;
        if(bl){
            fitness_i.clear();
            //cout << "Aplicando BL " <<endl;
            for(auto& row : poblacion){
                auto ans = Bin_BL(row);
                row = ans;
                fitness_i.push_back(diff(row)); 
            }
            idx++;
        } 
    }
    
    int best =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
    //Escogo el mejor
    //cout << "best " << best << endl;
    hijo = (*(poblacion.begin()+ best));     

    return hijo;

}



vector<int> MDD::Bin_BL(vector<int> data){
     vector<int> solucion;
    vector<int> cand;

    //Genero una lista de candidatos que seran todos los posibles genes de 0 a n
    for(int i = 0; i < this->n;i++)
        cand.push_back(i);

    for(int i = 0; i < data.size(); i++){
        if(data[i] == 1){
            solucion.push_back(i);
        }
    }
    /*cout << "Solucion seria " << endl;
    for(auto s : solucion)
    cout << s << " ";
    cout << endl;*/
    /*for(auto e : solucion){
        cand.erase(std::remove(cand.begin(), cand.end(), e), cand.end());
    }*/  //5 2 24 3 1 18 22 
    Random::shuffle( cand.begin( ), cand.end( ) );


    pair<int,int> cambio;
    int index = 0;
    float new_disp;
    bool change = true;
    bool first = true;
    int maxIters = 100000;
    int iter = 0;
    bool print = false;

    while(iter < maxIters/* && change == true*/){
        if(first){
            change = false;
            first = false;
        }
        /*if(solucion.at(0) == 19 && solucion.at(1) == 3 &&solucion.at(2) == 15)
           print = false;*/
         
        for(int i = 0; i < cand.size();i++){
            iter++;
            float actual_disp = diffNonBin(solucion);
            cambio = make_pair(index,cand[i]);
            new_disp = distFactorizadaNonBin(solucion,cambio);  
            
            new_disp = round( new_disp * 100.0 ) / 100.0; //Redondeo a 3 cifras por error en los datos
            actual_disp = round( actual_disp * 100.0 ) / 100.0;
            
            /*//if(print){
                //cout << "-> " << i << endl;
                cout << "Cambio " << solucion[cambio.first ]<< " " << cambio.second << endl;
                cout << new_disp << " ,, " <<  actual_disp << endl;

            //}  */                                     
            if(new_disp < actual_disp  ){
                if(std::find(solucion.begin(), solucion.end(), cand[i]) == solucion.end()){
                    solucion[index] = cand[i];
                    index = (index +1)%(solucion.size());
                    change = true;
                    i = -1;
                   /* //if(print){
                        //cout << " solucion[index] = " << solucion[index] << " -- " << cand[i] << endl;
                        cout << "ANS " <<endl;
                        for(auto i : solucion)
                            cout << i << " ";
                            cout << endl;
                            cout << endl;
                    //}*/
                }
            }

            if(!change and solucion[index] != solucion[solucion.size()-1]){
                if(cand[i] == cand[cand.size()-1]){
                    index = (index +1)%(solucion.size());
                    i = -1;
                }
            }
            if(solucion[index] == solucion[solucion.size()-1]){
                if(change){
                    index = 0 ;
                    i = -1;
                    change = false;
                }
            }
            
        }
        index = (index +1)%(solucion.size());
       /* cout << "--------Iteraciones " << iter << endl;
        for(auto i : solucion)
        cout << i << " ";
        cout /*<<diffNonBin(solucion)*//* <<  endl;*/
    
    }
    vector<int> real_s(this->n,0);
    for(auto i : solucion){
        real_s[i] = 1;
    }
    /*cout << "La solucion de BL seria" << endl;
    for(auto i : real_s)
        cout << i << " ";
    cout << endl;*/
    return real_s;
}

vector<int> MDD::AM_subset(){
    const int TAM = 50;
    const int MAX_ITERS = 100000;
    vector<int> hijo(this->n-1,0);
    vector<vector<int>> poblacion(TAM,vector<int>(this->n-1,0));
    vector<vector<int>> hijos;
    vector<float> fitness_i;
    vector<float> fitness_padre;
    int iters = 0;
    int idx = 1;
    int dd = 0;
    
    
    for(auto &row : poblacion){
        row = generarPoblacion();
        fitness_i.push_back(diff(row)); 
    }
    
    auto inicioLoop = high_resolution_clock::now();
    while(iters < MAX_ITERS){
        bool bl = false;
        //inicioCruce = high_resolution_clock::now();
        //Nesesito buscar el mejor padre
        
        int best_i =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
        float best_fit = fitness_i[best_i];
       // cout << "Iteracion " << iters << endl;
        //cout << "En esta gen encontramos el mejor elemento en " << best_i << " con fitt = " << best_fit << endl;
        vector<int> best_father = *(poblacion.begin() + best_i);


        int desp = 0;
        pair<vector<int>,vector<int>> pair_child;
        int num_cruces = 0.7*poblacion.size()*2;

        //          Cruzamos
       
        for(auto row = poblacion.begin(); row != poblacion.end();row++){
            auto p2 = next(row);
            if(Random::get<bool>(0.7) && p2 != poblacion.end()){
                //Generar una pareja de hijos
                pair_child = generarHijosPosicion(*row, *p2);

                hijos.insert(hijos.begin()+desp ,pair_child.first);
                fitness_i[desp] = diff(pair_child.first);

                hijos.insert(hijos.begin()+desp+1 ,pair_child.second);
                fitness_i[desp+1] = diff(pair_child.second);
                desp+=2;
                row = std::next(row);
            }else{
                hijos.insert(hijos.begin()+desp ,*row);
                desp++;
            }
            iters++;
            //cout << "Iteraciones " << iters << endl;
            if(iters == 10*idx){
                bl = true;
            }
        }
        //cout << "muto " <<endl;
        //Tocar MUTAR
         //inicioMuta= high_resolution_clock::now();
       
        int count = 0;
        int num_mutaciones_esperado = 0.1*this->n * TAM;
        
        while(count != num_mutaciones_esperado){
            //inicioCruce = high_resolution_clock::now();
            int cromos = Random::get(0,TAM-1);
            int gen1,gen2;
            
            do{ 
                gen1 = Random::get(0,this->n-1);
                gen2 = Random::get(0,this->n-1);
            }while(gen1 == gen2);
           
            if((*(hijos.begin()+cromos))[gen1] != (*(hijos.begin()+cromos))[gen2]){
                std::iter_swap((*(hijos.begin()+cromos)).begin()+gen1, (*(hijos.begin()+cromos)).begin() + gen2);
                fitness_i[cromos] = diff(*(hijos.begin()+cromos));
            }
            count++;
        }
                
        //poblacion.clear();
        poblacion.resize(TAM,vector<int>(this->n-1,0));
        
        poblacion = hijos;
        hijos.clear();

        //cout << "Best padre " << best_fit << endl;
        //Si no encuentro reemplazo el peor 
        if( find(fitness_i.begin(), fitness_i.end(), best_fit) == fitness_i.end() ){
            int worst_i =  std::max_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
            fitness_i[worst_i] = best_fit;
            *(poblacion.begin() + worst_i) = best_father;
        }
       


        
        //cout << "->>Generacion " << iters << endl;
        if(bl){
            //fitness_i.clear();
            //cout << "Aplicando BL " <<endl;
            int contador = 0;
            for(auto& row : poblacion){
                if(Random::get<bool>(0.1)){
                    auto ans = Bin_BL(row);
                    row = ans;
                    //fitness_i.push_back(diff(row)); 
                    fitness_i.at(contador) = diff(row);
                }
                contador++;
            }
            idx++;
        }
        
        
        //iters++;
       /*dd=0;
        for(auto row : poblacion){
            for(auto e : row){
                cout << e << " ";
            }
            cout << "\t" << fitness_i[dd] << endl;
            dd++;
        }*/
    
    }
    
    int best =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
    //Escogo el mejor
    //cout << "best " << best << endl;
    hijo = (*(poblacion.begin()+ best));     

    return hijo;

}

vector<int> MDD::AM_best(){
    const int TAM = 50;
    const int MAX_ITERS = 100000;
    vector<int> hijo(this->n-1,0);
    vector<vector<int>> poblacion(TAM,vector<int>(this->n-1,0));
    vector<vector<int>> hijos;
    vector<float> fitness_i;
    vector<float> fitness_padre;
    int iters = 0;
    int idx = 1;
    int dd = 0;
    
    
    for(auto &row : poblacion){
        row = generarPoblacion();
        fitness_i.push_back(diff(row)); 
    }
    
    auto inicioLoop = high_resolution_clock::now();
    while(iters < MAX_ITERS){
        bool bl = false;
        //inicioCruce = high_resolution_clock::now();
        //Nesesito buscar el mejor padre
        
        int best_i =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
        float best_fit = fitness_i[best_i];
       // cout << "Iteracion " << iters << endl;
        //cout << "En esta gen encontramos el mejor elemento en " << best_i << " con fitt = " << best_fit << endl;
        vector<int> best_father = *(poblacion.begin() + best_i);


        int desp = 0;
        pair<vector<int>,vector<int>> pair_child;
        int num_cruces = 0.7*poblacion.size()*2;

        //          Cruzamos
       
        for(auto row = poblacion.begin(); row != poblacion.end();row++){
            auto p2 = next(row);
            if(Random::get<bool>(0.7) && p2 != poblacion.end()){
                //Generar una pareja de hijos
                pair_child = generarHijosPosicion(*row, *p2);

                hijos.insert(hijos.begin()+desp ,pair_child.first);
                fitness_i[desp] = diff(pair_child.first);

                hijos.insert(hijos.begin()+desp+1 ,pair_child.second);
                fitness_i[desp+1] = diff(pair_child.second);
                desp+=2;
                row = std::next(row);
            }else{
                hijos.insert(hijos.begin()+desp ,*row);
                desp++;
            }
            iters++;
            //cout << "Iteraciones " << iters << endl;
            if(iters == 10*idx){
                bl = true;
            }
        }
        //cout << "muto " <<endl;
        //Tocar MUTAR
         //inicioMuta= high_resolution_clock::now();
       
        int count = 0;
        int num_mutaciones_esperado = 0.1*this->n * TAM;
        
        while(count != num_mutaciones_esperado){
            //inicioCruce = high_resolution_clock::now();
            int cromos = Random::get(0,TAM-1);
            int gen1,gen2;
            
            do{ 
                gen1 = Random::get(0,this->n-1);
                gen2 = Random::get(0,this->n-1);
            }while(gen1 == gen2);
           
            if((*(hijos.begin()+cromos))[gen1] != (*(hijos.begin()+cromos))[gen2]){
                std::iter_swap((*(hijos.begin()+cromos)).begin()+gen1, (*(hijos.begin()+cromos)).begin() + gen2);
                fitness_i[cromos] = diff(*(hijos.begin()+cromos));
            }
            count++;
        }
                
        //poblacion.clear();
        poblacion.resize(TAM,vector<int>(this->n-1,0));
        
        poblacion = hijos;
        hijos.clear();

        //cout << "Best padre " << best_fit << endl;
        //Si no encuentro reemplazo el peor 
        if( find(fitness_i.begin(), fitness_i.end(), best_fit) == fitness_i.end() ){
            int worst_i =  std::max_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
            fitness_i[worst_i] = best_fit;
            *(poblacion.begin() + worst_i) = best_father;
        }
               
        //cout << "->>Generacion " << iters << endl;
        int mejores = 0.1* TAM;
        vector<int> best_index;
        for (auto i : sort_indexes(fitness_i)) 
            best_index.push_back(i);
        
        best_index.resize(mejores);
        //cout << best_index.size() << endl;
        if(bl){
            for(auto i : best_index){
                auto ans = Bin_BL(*(poblacion.begin()+i));
                *(poblacion.begin()+i) = ans;
                fitness_i.at(i) = diff(*(poblacion.begin()+i));
            }
            idx++;
        }
        
        
        //iters++;
       /*dd=0;
        for(auto row : poblacion){
            for(auto e : row){
                cout << e << " ";
            }
            cout << "\t" << fitness_i[dd] << endl;
            dd++;
        }*/
    
    }
    
    int best =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
    //Escogo el mejor
    //cout << "best " << best << endl;
    hijo = (*(poblacion.begin()+ best));     

    return hijo;

}
template <typename T>
vector<size_t> sort_indexes(const vector<T> &v) {

  // initialize original index locations
  vector<size_t> idx(v.size());
  iota(idx.begin(), idx.end(), 0);

  // sort indexes based on comparing values in v
  // using std::stable_sort instead of std::sort
  // to avoid unnecessary index re-orderings
  // when v contains elements of equal values 
  stable_sort(idx.begin(), idx.end(),
       [&v](size_t i1, size_t i2) {return v[i1] < v[i2];});

  return idx;
}