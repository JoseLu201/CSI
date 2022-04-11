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
    string nombreArchivo = argv[1];
    ifstream file(nombreArchivo);
    pair<int,int> dim  = read_dimension(nombreArchivo);
    MDD instance(dim.first,dim.second);

    instance.leer_fichero(nombreArchivo);
    std::seed_seq sseq{1,2,3,4,5};
    Random::seed(sseq);
    vector<float> dispersion;
    vector<milliseconds> times;
    milliseconds tiempo;
    for(int i = 0; i < sseq.size();i++){
        auto inicio = high_resolution_clock::now();
        vector<int> sol = instance.BL_2(); 
        auto fin = high_resolution_clock::now();
        dispersion.push_back(instance.diff(sol));
        /*for(auto a : sol)
        cout << a << " ";
        cout << endl;*/
        tiempo = duration_cast<std::chrono::milliseconds>(fin - inicio);
        times.push_back(tiempo);
        //cout <<instance.diff(sol)<< endl;  
    }
    
    float sum = 0;
    for(auto dis : dispersion){
        sum+=dis;
    }
    auto sum_tiempo = 0;
    for(auto t : times){
        sum_tiempo+=t.count();
    }
     
    cout <</*"Media de la dispersion " <<*/ sum/dispersion.size() <<endl;
    //cout << /*"Media de la tiempos " << */sum_tiempo/times.size() <<endl;
    return 0;   
}