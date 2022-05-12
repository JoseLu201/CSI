#include "MDD.hpp"
#include <string>
#include <iostream>
#include <algorithm>
#include "random.hpp"
#include <vector>


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
