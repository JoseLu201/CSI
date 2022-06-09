#include <iostream>
#include <fstream>
#include <vector>
#include "MDD.hpp"
#include <random>

using namespace std;
using namespace std::chrono;
using Random = effolkronium::random_static;


pair<int,int> read_dimension(string fichero){
    ifstream file(fichero);
    string t1,t2;
    pair<int,int> ans;
    getline(file,t1,' ');
    ans.first = stoi(t1);
    getline(file,t2);
    ans.second = stoi(t2);
    file.close();

    return ans;
}

int main(int argc, char *argv[]){
    string algo = argv[1];
    string nombreArchivo = argv[2];
    
    ifstream file(nombreArchivo);
    pair<int,int> dim  = read_dimension(nombreArchivo);
    MDD instance(dim.first,dim.second);

    instance.leer_fichero(nombreArchivo);

    Random::seed(0);
    vector<float> dispersion;
    vector<milliseconds> times;
    milliseconds tiempo;
    vector<int> sol;

    std::chrono::_V2::system_clock::time_point inicio,fin;
    int MAX_ITERS = 100000;
    int outer_loop = 10;
    int inner_loop = 10000;
    float fit;

    
    switch (stoi(algo)){
    case 0:
        inicio = high_resolution_clock::now();
        sol = instance.BL(); 
        fin = high_resolution_clock::now();
        break;
    case 1:
        inicio = high_resolution_clock::now();
        sol = instance.EnfriamientoSimulado(MAX_ITERS,fit); 
        fin = high_resolution_clock::now();
        break;
    case 2:
        inicio = high_resolution_clock::now();
        sol = instance.BMB(outer_loop,inner_loop); 
        fin = high_resolution_clock::now();
        break;
    case 3:
        inicio = high_resolution_clock::now();
        sol = instance.ILS(outer_loop, inner_loop); 
        fin = high_resolution_clock::now();
        break;
    case 4:
        inicio = high_resolution_clock::now();
        sol = instance.ILS_ES(outer_loop,inner_loop); 
        fin = high_resolution_clock::now();
        break;
    default:
        break;
    }

    
    //dispersion.push_back(instance.diff(sol));
    tiempo = duration_cast<std::chrono::milliseconds>(fin - inicio);
 

     
    cout <</*"Media de la dispersion " <<*/ instance.diff(sol) << ";";
    cout << /*"Media de la tiempos " << */ tiempo.count() <<endl;
    return 0;   
}