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

        //Cambiar aqui las semillas!!
    std::seed_seq sseq{0,1,2,3,4};

    Random::seed(sseq);
    vector<float> dispersion;
    vector<milliseconds> times;
    milliseconds tiempo;
    vector<int> sol;

    std::chrono::_V2::system_clock::time_point inicio,fin;

    for(int i = 0; i < sseq.size();i++){
        if(stoi(algo) == 1){
            inicio = high_resolution_clock::now();
            sol = instance.greedy(); 
            fin = high_resolution_clock::now();
        }else if(stoi(algo) == 2){
            inicio = high_resolution_clock::now();
            sol = instance.BL(); 
            fin = high_resolution_clock::now();
            
        }
        
        dispersion.push_back(instance.diff(sol));
        tiempo = duration_cast<std::chrono::milliseconds>(fin - inicio);
        times.push_back(tiempo);
    }
    
    float sum = 0;
    for(auto dis : dispersion){
        sum+=dis;
    }
    auto sum_tiempo = 0;
    for(auto t : times){
        sum_tiempo+=t.count();
    }
     
    cout <</*"Media de la dispersion " <<*/ sum/dispersion.size() << ";";
    cout << /*"Media de la tiempos " << */sum_tiempo/times.size() <<endl;
    return 0;   
}