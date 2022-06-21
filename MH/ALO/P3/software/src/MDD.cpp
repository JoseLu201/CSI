#include "MDD.hpp"
#include <string>
#include <iostream>
#include <algorithm>
#include "random.hpp"
#include <vector>
#include <math.h>
#include <set>
#include <unordered_set>


/*

*/
using namespace std;
using std::remove;

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

void printi(vector<int> v){
    cout << "[";
    for(auto a : v)
        cout << a << " ";
    cout << "]\n";
}

float MDD::diff(vector<int> posib){
    vector<float> distancias;
    for(int i = 0; i < posib.size();i++){
        distancias.push_back(distPuntoRestoElemenetos(posib[i],posib));
        
    }
    sort(distancias.begin(), distancias.end());
    
    return (distancias[distancias.size()-1] - distancias[0] );
}

float MDD::fit_adding(vector<int> posib, int new_i){
    float new_diff;
    posib.push_back(new_i);

    new_diff = diff(posib);

    posib.pop_back();
    return new_diff;
}

//Este es el bueno
vector<int> MDD::greedy(){
    vector<int> solucion;
    vector<int> cand;

    for(int i = 0; i < this->n;i++){
        cand.push_back(i);
    }
    int max = this->n;
    auto rand = Random::get(0,max);
    auto select = cand.at(rand);//Seleccion inicial
    //Seleccionar la primera solucion de forma aleatoria
    solucion.push_back(select);
    auto delete_ps = cand.begin()+rand;
    cand.erase(delete_ps);

    while(solucion.size() < this->m ){
        float new_fitness;
        int pos = 0;
        float min = 10000000.0f;
        for(auto ele : cand){
            new_fitness = fit_adding(solucion,ele);
            if(new_fitness < min){
                pos = ele;
                min = new_fitness;    
            }
        }   
        solucion.push_back(pos);
        std::remove(cand.begin(),cand.end(),pos);
    }
    return solucion;
}



/*
Calcula la distancia desde un punto al resto de los pntos del vector
f -> es la fila sobre la que se aplica,
v -> es un vector con los indices de las columnas sobre las que se suman
*/
float MDD::distPuntoRestoElemenetos(int f,vector<int> v){
    float dist = 0;
    for(int i = 0; i < v.size();i++){
        dist+=this->datos[f][v[i]];
        if(datos[f][v[i]] < 0 || datos[f][v[i]] == 0)
            dist+= datos[v[i]][f];
    }
    return dist;
}



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


/*
Genero una solucion aleatoria y luego seria ir intercambiando para generar los vecinos

Una forma de cambiar los indices seria hacer hacer una pareja de valores en la cual la primera 
posicion es el valor que cambias y el segundo seria por el cual lo cambias, con esto podemos mejorar en memoria

Para factorizar la funcion de evaluacion si solo cambiamos un elemento en los vecinos, no tendriamos que 
volver a recalcular todos los valores por solo cambiar uno

ejemplo

(0,4,6)
D0 = D04 + D06  //Esta ya no lo necesito
D4 = D40 + D46  //Si cambio el o por un 1 D4 = D4 -D04 + D14
D6 = D60 + D64
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
            iter++;
        }
        index = (index +1)%(solucion.size());
    }
    return solucion;
}


vector<int> MDD::BL_2(vector<int> solucion, int iteraciones, float& sol_fit){

   
    
    vector<int> cand;
    
    for(int i = 0; i < this->n;i++)
        cand.push_back(i);

    Random::shuffle( cand.begin( ), cand.end( ) );
    
    pair<int,int> cambio;
    int index = 0;
    float new_disp;
    bool change = true;
    bool first = true;
    int maxIters = iteraciones;
    int iter = 0;
    float actual_disp = diff(solucion);

    while(iter < maxIters /*&& change == true*/){
        if(first){
            change = false;
            first = false;
        }
        for(int i = 0; i < cand.size();i++){
            iter++;
             
            cambio = make_pair(index,cand[i]);
            new_disp = distFactorizada(solucion,cambio);  
            //new_disp = round( new_disp * 1000.0 ) / 1000.0; //Redondeo a 3 cifras por error en los datos
            //actual_disp = round( actual_disp * 1000.0 ) / 1000.0;     
            //cout << "Cambiando el " << solucion[index] << "  por " << cand[i] << endl;
            //cout << "actual diff " << actual_disp <<" , " << new_disp << endl ;  
            if(new_disp < actual_disp && (find(solucion.begin(), solucion.end(), cand[i]) == solucion.end()) ){
                //cout << "MEJORO " << endl << endl;
                solucion[index] = cand[i];
                index = (index +1)%(solucion.size());
                change = true;
                i = -1;
                actual_disp = new_disp;
                
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
            //cout << "Iteracion  "<<  iter << endl;
        }
        index = (index +1)%(solucion.size());
        //cout << "Iteraciones " <<iter << endl;
    }
    //cout << "best fittnes " << diff(solucion) << endl;
    sol_fit = actual_disp;
    return solucion;
}

/*

Solucion inicial 
7 4 20 9 3 21 23 

*/
/*
En tema de tiempos tarda mas o menos lo mismo que la busqueda local pero normalmente un poco mas
no se para tan facilmente en minimos glabales.
Pasar por parametro el numero de evaluacion/iteraciones, es lo mas comodo.

Comparar si la temperatura inicial sea mayor 

*/
vector<int> MDD::generarSolucionAleatoria(){
    vector<int> solucion;
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
    return solucion;
}

vector<int> MDD::EnfriamientoSimulado(int MAX_ITERS, float& sol_fit){

    //Creamos una solucion aleatoria y calculamos su coste.
    vector<int> solucion; 
    vector<int> best;  
    vector<int> s_i; 

    int max_vecinos = 10 * this->n;
    int max_exitos = 0.1 * max_vecinos;
    int M = MAX_ITERS / max_vecinos;

    int n_vecinos = 1;
    int n_exitos =1;

    solucion = generarSolucionAleatoria();

    //Calculamos el coste de la solucion  inicial.
    float coste_ini = diff(solucion);

    //Nos quedamos con la mejor solucion que es la actual
    best = solucion;
    ////////////float best_fit = diff(best);///////////////////////////////////////////////
    float best_fit = coste_ini;

    /*cout << "Primera solucion " << coste_ini << endl;
    printi(solucion);*/
    
    //Inicializamos la temperatura inicial
    double T_ini = 0.3 * coste_ini / (-log(0.3));    
    double T_fin = 0.0001;

    double T_curr = T_ini;
    int iters = 0;
    double beta = (T_ini - T_fin)/(M * T_ini *T_fin);
    //cout << "Valor de beta  " << beta << endl;
    float curr_fit = coste_ini;
    while(/*T_curr  < T_fin && */ iters < MAX_ITERS && n_exitos != 0 ){
        n_vecinos = 0;
        n_exitos = 0;
        //cout << "Temperatura "<< T_curr  <<endl;   
        while(n_vecinos < max_vecinos && n_exitos < max_exitos){
            float vecinos_fit;             
            n_vecinos++;
            iters++;
            //cout << "Solucion actual " << curr_fit<<endl;
            /*printi(solucion);
            */
            s_i = generarVecino(solucion, vecinos_fit);
            //cout << "Generamos un vecino  " << vecinos_fit <<endl;
            /*printi(s_i);*/
            
            float diferencia = abs( vecinos_fit - curr_fit );
            
            if(vecinos_fit < curr_fit || Random::get<Random::common>(0, 1.f) < exp(-diferencia/T_curr)){
                solucion = s_i;  
                curr_fit = vecinos_fit;  
                n_exitos++;
                if(vecinos_fit < best_fit){
                    best = solucion;
                    best_fit = vecinos_fit;
                    //  cout << "Mejor solucion " << best_fit << endl <<endl;
                    //printi(best);
                }
            }
        }
         

        
        T_curr = T_curr / ( 1 + beta * T_curr);
    }
    //cout << "Mejor solucion encontrada " << diff(best) << endl;
    //printi(best);
    /*cout << "Acabamos la ejecucion con " << endl;
    cout << "Iters "<< iters << endl
    << "Temperatura " << T_curr << endl
    << "N_vecinos " << n_vecinos << " de " << max_vecinos<< endl
    <<  "N_exitos " << n_exitos<< " de " << max_exitos<< endl;*/
    //cout << "DIFFF " << diff(best) << " " << best_fit << endl;
    sol_fit = best_fit;
    return best;
}

vector<int> MDD::EnfriamientoSimulado2(int MAX_ITERS, float& sol_fit, vector<int> solucion){

    vector<int> best;  
    vector<int> s_i; 

    int max_vecinos = 10 * this->n;
    int max_exitos = 0.1 * max_vecinos;
    int M = MAX_ITERS / max_vecinos;

    int n_vecinos = 1;
    int n_exitos =1;



    //Calculamos el coste de la solucion  inicial.
    float coste_ini = diff(solucion);

    //Nos quedamos con la mejor solucion que es la actual
    best = solucion;
    ////////////float best_fit = diff(best);///////////////////////////////////////////////
    float best_fit = coste_ini;

    /*cout << "Primera solucion " << coste_ini << endl;
    printi(solucion);*/
    
    //Inicializamos la temperatura inicial
    double T_ini = 0.3 * coste_ini / (-log(0.3));    
    double T_fin = 0.0001;

    double T_curr = T_ini;
    int iters = 0;
    double beta = (T_ini - T_fin)/(M * T_ini *T_fin);
    float curr_fit = coste_ini;
    while(iters < MAX_ITERS && n_exitos != 0 ){
        n_vecinos = 0;
        n_exitos = 0;
        //cout << "Temperatura "<< T_curr  <<endl;   
        while(n_vecinos < max_vecinos && n_exitos < max_exitos){
            float vecinos_fit;             
            n_vecinos++;
            iters++;


            s_i = generarVecino(solucion, vecinos_fit);

            float diferencia = abs( vecinos_fit - curr_fit );
            
            if(vecinos_fit < curr_fit || Random::get<Random::common>(0, 1.f) < exp(-diferencia/T_curr)){
                solucion = s_i;  
                curr_fit = vecinos_fit;  
                n_exitos++;
                if(vecinos_fit < best_fit){
                    best = solucion;
                    best_fit = vecinos_fit;
                }
            }
        }
        T_curr = T_curr / ( 1 + beta * T_curr);
    }
    //cout << "Mejor solucion encontrada " << diff(best) << endl;
    //printi(best);
    /*cout << "Acabamos la ejecucion con " << endl;
    cout << "Iters "<< iters << endl
    << "Temperatura " << T_curr << endl
    << "N_vecinos " << n_vecinos << " de " << max_vecinos<< endl
    <<  "N_exitos " << n_exitos<< " de " << max_exitos<< endl;*/
    //cout << "DIFFF " << diff(best) << " " << best_fit << endl;
    sol_fit = best_fit;
    return best;
}

/*
Operador de vecino, intercambia los 
*/
vector<int > MDD::generarVecino(vector<int> solucion, float &disp_vecino){
    vector<int> vecino;
    vecino = solucion;
    pair<int,int> cambio;
    int index = Random::get(0,this->m-1);
    int cand = -1;
    do{
        cand = Random::get(0,this->n-1);
    }while(std::find(vecino.begin(), vecino.end(), cand) != vecino.end());

    cambio = make_pair(index,cand);
    disp_vecino = distFactorizada(vecino,cambio);  
    vecino[index] = cand;
   
    return vecino;
}
/*


si el nuevo fitness es mejor que el actual reemplazamos BL

ahora si si el nuevo fitness es mejor que el actual  && num aleatorioentre 0 y 1, < e (-DIF/T)
    
    diferencia es el abs(new_fit - curr_fit)

    comprobar que e^ este entre 0 y 1, se puede pasar solo un poco

Poner a cero el numero de exitos y de vecinos en cada vuelta.    
*/



//Esto es aplicar BL n_sol veces y me quedo con la mejor
vector<int > MDD::BMB(int n_sol, int MAX_ITERS){
    vector<int> solucion;
    int iters = 0;
    vector<int> best;
    float best_fit = 99999.9f;
    float sol_fit;
    while(iters < n_sol){
        iters++;
        solucion = generarSolucionAleatoria();

        auto BL_sol = BL_2(solucion, MAX_ITERS,sol_fit);
        
        if(sol_fit < best_fit){
            best = BL_sol;
            best_fit = sol_fit;
        }       
    }
    return best;
}

/*
Se elegiran t posiciones aleatorias de la solucion actual para despues
y cambiarlos por t valores aleatorios
*/
vector<int> MDD::mutarSolucion(vector<int> solucion, float percent){
    /*cout << "Solucion inicial " << endl;
    printi(solucion);*/
    vector<int> mutacion = solucion;
    int t = percent * this->m; //Numero de elementos a mutar.
    int count = 0;

    while(count != t){
        int muta = Random::get(0,this->m-1); // Eligo la posicion a mutar
        int cambio = -1;
        do{
            cambio = Random::get(0,this->n-1);
        } while (find(mutacion.begin(),mutacion.end(), cambio) != mutacion.end());

        mutacion[muta] = cambio;
        count++;
    }
    //cout << "Solucion mutada " << endl;
    //printi(mutacion);
    return mutacion;
}

vector<int> MDD::ILS(int n_sol, int BL_ITERS){

    vector<int> solucion;
    vector<int> best;
    float best_fit;
    float curr_fit;

    solucion = generarSolucionAleatoria();
    best = solucion;
    best_fit = diff(solucion);

    int iters = 0;
    while(iters < n_sol){
        iters++;
        vector<int> s_i = BL_2(solucion,BL_ITERS,curr_fit); 
        if(curr_fit < best_fit){
            best = s_i;
            best_fit = curr_fit;
        }
        solucion = mutarSolucion(best,0.3);  
    }
    return best;
}


vector<int> MDD::ILS_ES(int n_sol, int ES_ITERS){
    vector<int> solucion;
    vector<int> best;
    float best_fit;
    float curr_fit;

    solucion = generarSolucionAleatoria();
    best = solucion;
    best_fit = diff(solucion);

    int iters = 0;
    while(iters < n_sol){
        iters++;
        vector<int> s_i = this->EnfriamientoSimulado2(ES_ITERS,curr_fit,solucion);
        if(curr_fit < best_fit){
            best = s_i;
            best_fit = curr_fit;
        }
        solucion = mutarSolucion(best,0.3);    
    }
    return best;
}



vector<int> MDD::generarPoblacion(){
    set<int> ant;
    while(ant.size() != this->m){
        ant.insert(Random::get(0,this->n-1));
    }
    vector<int> ant_v(ant.begin(), ant.end());
    return ant_v;
}

bool compare_menorFitness(const pair<vector<int>,float> &f,const  pair<vector<int>,float> &s){
    if(f.second <= s.second) 
        return true;
    return false;
}

int MDD::RouletteWheelSelection(vector<float> pesos){
    int chosen = 1;
    vector<float> cumsum;
    cumsum.resize(pesos.size());
    std::partial_sum(pesos.begin(), pesos.end(), cumsum.begin(),plus<float>() );
     auto val = Random::get<Random::common>(1, 0.f);
    float p = val * cumsum[cumsum.size()-1];
    for(int i = 0; i < cumsum.size();i++){
        if(cumsum[i] > p){
            chosen = i;
            break;
        }  
    }
    return chosen;
}
//Necesito la ant_lion y la iteracion actual
/*vector<int> Random_walk_around_antlion(pair<vector<int>,float> ant_l, int curr_iter, int MAX_ITERS){
    double I;
    if(curr_iter >= MAX_ITERS *0.95)
        I = 1 + 10**6 * (curr_iter/MAX_ITERS);
    else if (curr_iter >= MAX_ITERS * 0.9)
        I = 1 + 10**5 * (curr_iter/MAX_ITERS);
    else if (curr_iter >= MAX_ITERS * 3/4)
        I = 1 + 10**4 * (curr_iter/MAX_ITERS);
    else if (curr_iter >= MAX_ITERS * 0.5)
        I = 1 + 10**3 * (curr_iter/MAX_ITERS);
    else
        I = 1 + 10**2 * (curr_iter/MAX_ITERS);
    return;
}*/
void print_poblacion(vector<pair<vector<int>,float>> ant){
    for(auto i : ant){
        for(auto j :i.first){
            cout << j << " ";
        }
        cout << "   " << i.second << endl;
    }
    
    
}

void print_ant(pair<vector<int>,float> ant){
    for(auto j :ant.first){
        cout << j << " ";
    }
    cout << "   " << ant.second << endl<< endl;
}

void MDD::move_to_hole(pair<vector<int>,float> &ant_lion, pair<vector<int>,float> &ant, int curr_iter){

    if(ant.second > ant_lion.second){
        for(int i = 0; i < ant.first.size();i++){
            if(ant_lion.first[i] >= ant.first[i] ){
                //Deslizamos aleatoriamente
                ant.first[i] = ant_lion.first[i] - ant.first[i];
                ant.second = distFactorizada(ant.first,make_pair(i,ant.first[i]));
            }
        }
    }else if(Random::get<bool>(0.5)){
        for(int i = 0; i < ant.first.size();i++){
            if(ant_lion.first[i] >= ant.first[i] ){
                //Deslizamos aleatoriamente
                ant.first[i] = (ant_lion.first[i] + ant.first[i])%this->n;
                ant.second = distFactorizada(ant.first,make_pair(i,ant.first[i]));
            }
        }
    }

    unordered_set<int> fix(ant.first.begin(),ant.first.end());
    if(fix.size() != this->m){
        while(fix.size() != this->m){
            fix.insert(Random::get(0,this->n-1));
        }
        ant.first.assign(fix.begin(),fix.end());
        ant.second = diff(ant.first);
    } 
        
}

vector<int> MDD::ALO(int ITERS){
    //Definimos la matriz de hormigas y hormigas leones
    int TAM = 20;
   vector<int> best;
   float best_fit;
    vector<pair<vector<int>,float>> ant(TAM,make_pair(vector<int>(this->n-1,0),0));
    vector<pair<vector<int>,float>> ant_leon(TAM/2,make_pair(vector<int>(this->n-1,0),0));;


    
    vector<int> ans;

    for(auto &i : ant){
        i.first = generarPoblacion();
        i.second = diff(i.first);
    }

    //sort(ant.begin(), ant.end(),compare_menorFitness);

    for(auto &i : ant_leon){
        i.first = generarPoblacion();
        i.second = diff(i.first);
    }

    sort(ant_leon.begin(), ant_leon.end(),compare_menorFitness);

    best = (*(ant_leon.begin())).first;
    best_fit = (*(ant_leon.begin())).second;

    int iter = 0;

    /*cout << "Poblacion inicial " << endl;
    print_poblacion(ant);
    cout << "LEON" << endl;
    print_poblacion(ant_leon);
    */
    while(iter < ITERS){
        iter++;
        vector<float> pesos;
        for(auto &row : ant_leon){
            pesos.push_back(row.second);
        }
        //Para cada hormiga 
        for(auto &hormiga : ant){
            //selecciono una hormiga leon con la ruleta
            int roulete_index = RouletteWheelSelection(pesos);
            //Y esa hormiga se movera en torno a esa solucion
            move_to_hole(*(ant_leon.begin()+roulete_index),hormiga,iter);
          
            if(hormiga.second < (*(ant_leon.begin()+roulete_index)).second){
                *(ant_leon.begin()+roulete_index) = hormiga;
            }

            /*cout<< "Hormiga leon"<< endl;
            print_ant(*(ant_leon.begin()+roulete_index));*/
        }

        float max = 9999;
        pair<vector<int>,float> min;
        for(auto &h : ant_leon){
            if(h.second < max){
                min = h;
                max = h.second;
            }
        }
            
        if(min.second < best_fit){
            best = min.first;
            best_fit =min.second;
            /*cout << "Mejoro" << endl;
            for(int i =0; i < best.size();i++){
                cout << best[i] << ",";
            }cout << "  "<<best_fit << endl;*/
        }
        //cout << iter << endl;

    }

    

    return best;
    
}

vector<pair<vector<int>,float>>::iterator RouletteWheel(vector<pair<vector<int>,float>>& M_ant_lion) {
    // Obtenemos el número de ant lion
    int numIndividuos = M_ant_lion.size();

    // Calcular el fitness acumulado total
    double fitnessTotal = 0.0;
    for(auto it = M_ant_lion.begin(); it != M_ant_lion.end(); ++it) {
        fitnessTotal += it->second;
    }

    // Calcular el peso de cada ant lion
    vector<double> pesos;
    for(auto it = M_ant_lion.begin(); it != M_ant_lion.end(); ++it) {
        pesos.push_back(it->second / fitnessTotal);
    }

    // Calcular las probabilidades de cada ant lion
     vector<double> probabilidades;
    probabilidades.push_back(pesos[0]);
    for(int i = 1; i < (numIndividuos-1); ++i) {
        probabilidades.push_back(probabilidades[i-1] + pesos[i]);
    }

    // Se añade la última probabilidad acumulada de esta forma para evitar problemas de redondeo
    probabilidades.push_back(1.0);

    // Generar un número aleatorio en el rango [0,1]

    double prob = Random::get<Random::common>(1, 0.f) ;

    // Selección del ant lion
    auto elegido = M_ant_lion.begin();
    for(int i = 0; i < (numIndividuos-1); ++i, ++elegido) {
        if(probabilidades[i] < prob && prob < probabilidades[i+1]) {
            break;
        }
    }

    return elegido;
}



/**
 * @brief Función para obtener el valor de w
 * 
 * @param iteraciones Iteración actual
 * @param maxIteraciones Número máximo de iteraciones
 * @return int Valor de w
 */
int obtenerW(double iteraciones, double maxIteraciones) {
    int w = 1;

    if(iteraciones > 0.1*maxIteraciones) {
        ++w;
    }
    if(iteraciones > 0.5*maxIteraciones) {
        ++w;
    }
    if(iteraciones > 0.75*maxIteraciones) {
        ++w;
    }
    if(iteraciones > 0.9*maxIteraciones) {
        ++w;
    }
    if(iteraciones > 0.95*maxIteraciones) {
        ++w;
    }

    return w;
}

/**
 * @brief Función para obtener el valor de I
 * 
 * @param iteraciones Iteración actual
 * @param maxIteraciones Número máximo de iteraciones
 * @return double Valor de I
 */
double obtenerI(double iteraciones, double maxIteraciones) {
    double w = obtenerW(iteraciones, maxIteraciones);
    double I = pow(10, w) * (iteraciones/maxIteraciones);

    return I;
}
