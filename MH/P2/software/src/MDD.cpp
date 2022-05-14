#include "MDD.hpp"
#include <string>
#include <iostream>
#include <algorithm>
#include "random.hpp"
#include <vector>
#include <set>


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


float MDD::distPuntoRestoElemenetos(int f,vector<int> v){
    float dist = 0;

    for(int i = 0; i < v.size();i++){
        if(v[i] != 0){
            //cout << "-> " << this->datos[f][i] << endl;
            dist+=this->datos[f][i];
            if(datos[f][v[i]] < 0 || datos[f][i] == 0)
                dist+= datos[i][f];
        }
    }
    return dist;
}

float MDD::diff(vector<int> posib){
    vector<float> distancias;
    for(int i = 0; i < posib.size();i++)
        if(posib[i] != 0)distancias.push_back(distPuntoRestoElemenetos(i,posib));
    sort(distancias.begin(), distancias.end());
    return (distancias[distancias.size()-1] - distancias[0] );
}
/*
La idea de este es calcular fitness añadiendo un elemento, eso seria pasrle un indice

*/
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
    cout << endl;
    for(int i = 0; i < sol.size();i++){
        this->distan[i] = distPuntoRestoElemenetos(i,sol);
        cout << i << " " <<distan[i] << " " << endl;
    }
    cout << endl;
    //el first es un indice
    // y el second es un elemento 16

    
    int last_pos = sol[cambio.first] ;
    sol[cambio.first] = cambio.second;
    //Recalculo el nuevo punto que estoy añadiendo

    this->distan[cambio.second] = distPuntoRestoElemenetos(cambio.second,sol);
    //cout << "Añadiendo " << cambio.se
    for(auto i =0; i < sol.size();i++){
        if(i != cambio.first){     
            if(this->datos[cambio.first][i] != 0){
                if(this->datos[cambio.second][i] != 0){
                    this->distan[i] = this->distan[i] - this->datos[cambio.first][i] + this->datos[cambio.second][i];
                }
                else{
                    
                    this->distan[i] = this->distan[i] - this->datos[cambio.first][i] + this->datos[i][cambio.second];
                }
            }else{
                if(this->datos[cambio.second][i] != 0){
                    
                    this->distan[i] = this->distan[i] - this->datos[i][cambio.first] + this->datos[cambio.second][i];
                }else{ 
                   
                    this->distan[i] = this->distan[i] - this->datos[i][cambio.first] + this->datos[i][cambio.second];
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

vector<int> MDD::generarHijosUniforme(vector<int> p1,vector<int> p2){
    vector<int> hijo(p1.size(),0);
    for(auto i = 0; i < p1.size(); i++){
        if(p1[i] == p2[i]){
            hijo[i] = p1[i];
        }else
            hijo[i] = Random::get(0,1);
    }

    
    reparar(hijo);
}

vector<int> MDD::reparar(vector<int> hijo){
    int v = count(hijo.begin(), hijo.end(),1);
    if (v == m){
        return hijo;
    }else if( v > m){ //Si sobran elementos

    }
}

pair<vector<int>,vector<int>> MDD::generarHijosPosicion(vector<int> p1,vector<int> p2){
    vector<int> hijo1(p1.size(),0);
    vector<int> hijo2(p1.size(),0);
    pair<vector<int>, vector<int>> ans;
    vector<int> resto;//(p1.size(),0);
    /*cout << "Padres" << endl;
    for(auto i = 0; i < p1.size();i++){
        cout << p1[i] <<" ";
    }
    cout << endl;
    for(auto i = 0; i < p1.size();i++){
        cout << p2[i] <<" ";
    }
    cout << endl;*/

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

    Random::shuffle(resto);
    int j = 0;
    for(auto i = 0; i < p1.size(); i++){
        if(p1[i] == p2[i]){
            hijo1[i] = p1[i];
        }else{
            hijo1[i] = resto[j];
            j++;
        }
    }

    Random::shuffle(resto);
    j = 0;
    for(auto i = 0; i < p1.size(); i++){
        if(p1[i] == p2[i]){
            hijo2[i] = p1[i];
        }else{
            hijo2[i] = resto[j];
            j++;
        }
    }
   /* cout << "Hijos " << endl;
    for(auto i = 0; i < hijo1.size();i++){
        cout << hijo1[i] <<" ";
    }
    cout << endl;
    for(auto i = 0; i < hijo2.size();i++){
        cout << hijo2[i] <<" ";
    }
    cout << endl ;*/
    ans.first = hijo1;
    ans.second= hijo2;
    return ans;
}

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

int MDD::torneo(vector<vector<int>> poblacion, vector<float> fitness_i, int indiv_torneo){
    set<int> torneo;
    float best_fit = std::numeric_limits<double>::infinity();
    int winner = -1;

    while(torneo.size() != indiv_torneo)
        torneo.insert( Random::get(0,this->n));
    
    for(auto i : torneo){
        if(best_fit < fitness_i[i]){
            best_fit = fitness_i[i];
            winner = i;
        }
    }
    return winner;
}

vector<vector<int>> MDD::seleccion(vector<vector<int>> poblacion,vector<float> fitness_i){
    vector<vector<int>> select;
    vector<int> winner;
    for(auto i : poblacion){
        winner.push_back( torneo(poblacion,fitness_i,2));
    }
    
}

vector<int> MDD::AGG_uniforme(){
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

    /*for(auto row : poblacion){
            for(auto c : row)
                cout << c << " ";
            cout << endl;
        }*/

    while(iters < MAX_ITERS){
        
        //Nesesito buscar el mejor padre
        int best_i =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
        float best_fit = fitness_i[best_i];
        vector<int> best_father = *(poblacion.begin() + best_i);
        //Operador de selecion
        //Selecciono 2 individuos y escogo el mejor de ellos y esto lo repetire con toda la poblacion
        //Torneo sobre ambos y me quedo con el ganador


        //Para generar el cruze podriamos generarlos de forma aleatoria, ahora
        //los voy ha hacer EN ORDEN!!

        int desp = 0;
        pair<vector<int>,vector<int>> pair_child;
        /*cout << "Tamño de la poblacion INICIAL DE EPOCA " << poblacion.size() << endl;
        int di = 0;
            for(auto row : poblacion){
                for(auto c : row)
                    cout << c << " ";
                cout << "\t"<<fitness_i[di] << endl;
                di++;
            }*/
        int idx = 0;
        int num_cruces = 0.7*poblacion.size()*2;
        for(auto row = poblacion.begin(); row != poblacion.end(); row++ ){
            auto p2 = next(row);
            if(Random::get<bool>(0.7) && p2 != poblacion.end()){
                //cout << "Muto " << idx<< " y " <<idx+1 << endl;
                pair_child = generarHijosPosicion(*row, *p2);
               
                hijos.insert(hijos.begin()+desp ,pair_child.first);
                fitness_i[desp] = diff(pair_child.first);
                hijos.insert(hijos.begin()+desp+1 ,pair_child.second);
                fitness_i[desp+1] = diff(pair_child.second);
                desp+=2;
                //idx+=2
                row = std::next(row);
            }else{
                hijos.insert(hijos.begin()+desp ,*row);
                desp++;
                //cout << "No Muto " << idx << endl;
                idx++;
            }/*
            cout << " Desplaza,iento "<<desp << endl;
            for(auto row : hijos){
            for(auto c : row)
                cout << c << " ";
            cout << endl;
            }*/
        }
        /*cout << "Tamño de los hijos cruzados " << hijos.size() << endl;
            di = 0;
            for(auto row : hijos){
                for(auto c : row)
                    cout << c << " ";
                cout << "\t"<<fitness_i[di] << endl;
                di++;
            }*/
        

        //Tocar MUTAR
        int num_mutaciones_esperado = 0.1*this->n * this->m;
        int count = 0;
        
        while(count != num_mutaciones_esperado){
            int cromos = Random::get(0,TAM-1);
            int gen1,gen2;
            do{
                gen1 = Random::get(0,this->n-1);
                gen2 = Random::get(0,this->n-1);
            }while(gen1 == gen2);
            
            // Si la mutacion es 0 a 0 o 1 a 1 no hago el swap, aunque la mutacion este ahi
            //De esta forma aseguiro que el first siempre es 0 y por lo tanto el cambio es de 0 a 1
             /*pair<int,int> muted_gens;
            if((*(hijos.begin()+cromos))[gen1] == 0)
                muted_gens = make_pair(gen1,gen2);
            else
                muted_gens = make_pair(gen2,gen1);*/
            if((*(hijos.begin()+cromos))[gen1] != (*(hijos.begin()+cromos))[gen2]){
                //cout << "Para el cromosoma " << cromos << " cambio G1 " <<gen1 << "," << (*(hijos.begin()+cromos)).at(gen1)<<" G2 "<<gen2 << "," << (*(hijos.begin()+cromos))[gen2]<< endl;
                std::iter_swap((*(hijos.begin()+cromos)).begin()+gen1, (*(hijos.begin()+cromos)).begin() + gen2);
                //cout << "Fitness antes de mutar " << fitness_i[cromos] << " despues de la mutacion " ;
                //fitness_i[cromos] = distFactorizada(*(hijos.begin()+cromos),muted_gens);
                //|||||| CAMBIAR ESTO ES INEFICIENTE POR EL FACTORIZADO
                fitness_i[cromos] = diff(*(hijos.begin()+cromos));
                //cout << fitness_i[cromos] << endl;
            }
            count++;
        }
        /*cout << "Tamño de los hijos mutados " << hijos.size() << endl;
        di = 0;
        for(auto row : hijos){
            for(auto c : row)
                cout << c << " ";
            cout << "\t"<<fitness_i[di] << endl;
                di++;
        }*/

        
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

            /*int di = 0;
            for(auto row : poblacion){
                for(auto c : row)
                    cout << c << " ";
                cout << "\t"<<fitness_i[di] << endl;
                di++;
            }*/
    
    int best =  std::min_element(fitness_i.begin(),fitness_i.end()) - fitness_i.begin();
    //Escogo el mejor
    //cout << "Best solucion " << fitness_i[best] << " en " << best<< endl;
    hijo = (*(poblacion.begin()+ best));     

return hijo;
}

vector<int> MDD::AGG_posicion(){
    vector<int> hijo(this->n,0);
}