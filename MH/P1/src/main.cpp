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

void print(vector<int> v){
    cout << "[";
    for(auto a : v)
        cout << a << ",";
    cout << "]\n";
}
void printf(vector<float> v){
    cout << "[";
    for( int a = 0; a < v.size();a++)
        cout << a << ",";
    cout << "]\n";
}

int main(int argc, char *argv[]){

    
    //string nombreArchivo = "datos_MDD/GKD-b_11_n50_m5.txt";
    string nombreArchivo = argv[1];
    // = "datos_MDD/GKD-b_25_n100_m10.txt";
    
    ifstream file(nombreArchivo);
    pair<int,int> dim  = read_dimension(nombreArchivo);
    MDD instance(dim.first,dim.second);
    instance.leer_fichero(nombreArchivo);


    std::seed_seq sseq{0,1,2,3,4};
    
    Random::seed(sseq);
    vector<float> dispersion;
    milliseconds tiempo;
    for(int i = 0; i < sseq.size();i++){
        auto inicio = high_resolution_clock::now();
        vector<int> sol = instance.BL2();
        auto fin = high_resolution_clock::now();
        dispersion.push_back(instance.diff(sol));
        //print(sol);
        //cout << "Dispersion = " << instance.diff(sol) << endl<<endl;
        tiempo = duration_cast<std::chrono::milliseconds>(fin - inicio);
        
    }
    //cout <<"Tiempo Pasado: " <<tiempo.count() <<endl;

    float sum = 0;
    for(auto dis : dispersion){
        sum+=dis;
    }
    
    cout << /*"Media de la dispersion " << */sum/dispersion.size() <<endl;
 
    //vector<int> sol = instance.BL2();
    //print(sol);
    //cout << "Dispersion = " << instance.diff(sol) << endl<<endl;
    
   
    return 0;
 
    
}