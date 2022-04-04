#include "MDD.hpp"
#include <string>
#include <iostream>
#include <algorithm>
#include "random.hpp"


/*

*/
using namespace std;

using Random = effolkronium::random_static;

MDD::MDD(int n){
    this->n = n;
    this->m = 2;
    //datos = new vector<vector<float>> (m,vector<float> (n,0));
    this->datos = vector<vector<float>>(n,vector<float>(n,0));
    cout << datos.size() << ", "<<datos[0].size() << endl;
}

void MDD::read_dimension(string fichero){
    ifstream file(fichero);
    string t1;
    getline(file,t1,' ');
    getline(file,t1);
    this->m = stoi(t1);
    //cout << "Num casos" << m << endl;
    file.close();
}

void MDD::leer_fichero(string nombre_fichero){
    float dist;
    string t1;
    ifstream file(nombre_fichero);
    getline(file,t1);
    int i =0,j=0;
    while (file >> i >> j >> dist){
        //cout <<"->" << i << " " << j << " dist=" << dist << endl;
        datos[i][j] = dist;
    }
    
    file.close();
    cout << "archivo cerrado" << endl;
}


/*
De entre todas las soluciones escojo unas localizaciones aleatorias

*/


/*
A(v) suma de las dist entre ese vertice 'v' y el resto de vertices de S

*/




vector<int> MDD::greedy(){

    vector<int> solucion;
    vector<int> cand;
    Random::seed(5);
    for(int i = 0; i < this->n;i++){
        cand.push_back(i);
    }
    int max = this->n;
    auto rand = Random::get(0,max);
    auto select = cand.at(rand);//Seleccion inicial
    cout << "Valor inicial = " << select << endl;
    //Seleccionar la primera solucion de forma aleatoria
    solucion.push_back(select);
    auto delete_ps = cand.begin()+rand;
    cand.erase(delete_ps);
    while(solucion.size() < this->m ){
        float actual_dif = diff(solucion);
        float new_diff;
        

        for(auto ele : cand){
            new_diff = diff_adding(solucion,ele);
            cout << "Añadiendo el elementeo " << ele << " -> " << new_diff << endl;
            
            if((new_diff < actual_dif || new_diff == actual_dif )&& solucion.size() < this->m){
                solucion.push_back(ele);
                auto index = cand.begin()+ele;
                cout << "Añadiendo el elementos " << ele << endl;
                cand.erase(index);
                
            }
        }
    }
    return solucion;

}



/*
Calcula la distancia desde un puntoal resto de los pntos
f -> es la fila sobre la que se aplica,
v -> es un vector con los indices de las columnas sobre las que se suman
*/
float MDD::distPuntoRestoElemenetos(int f,vector<int> v){
    float dist = 0;
    for(int i = 0; i < v.size();i++){
        dist+=this->datos[f][v[i]];
        if(datos[f][v[i]] == 0)
            dist+= datos[v[i]][f];
    }
    return dist;
}

float MDD::diff(vector<int> posib){
    //Almaceno los valores para cada solucion
    vector<float> distancias;

    for(int i = 0; i < posib.size();i++){
        distancias.push_back(distPuntoRestoElemenetos(posib[i],posib));
    }
    sort(distancias.begin(), distancias.end());
    /*for(auto x : distancias)
        cout << x << " ";
    cout << endl;*/
    return (distancias[distancias.size()-1] - distancias[0] );
}

float MDD::diff_adding(vector<int> posib, int new_i){
    float actual_diff = diff(posib);
    float new_diff;
    vector<int> n;
    n = posib;
    n.push_back(new_i);
    new_diff = diff(n);
    if(new_diff < actual_diff){
        cout << "Se mejora" << endl;
        return new_diff;
    }else{
        //cout << "No se mejora "<< endl;
        return actual_diff;
    }

}

void MDD::mostrarDatos(){
    for(auto vec : datos){
       for(auto x : vec)
        cout << x << "\t"; 
        cout << endl;
    }
}