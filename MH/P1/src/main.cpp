#include <iostream>
#include <fstream>
#include <vector>
#include "MDD.hpp"
#include <random>

using namespace std;
using Random = effolkronium::random_static;
int read_dimension(string fichero){
    ifstream file(fichero);
    string t1,t2;
    getline(file,t1,' ');
    getline(file,t2);
    
    file.close();
    return stoi(t1);
}

int main(){

    
    string nombreArchivo = "datos_MDD/GKD-b_11_n50_m5.txt";
    //string nombreArchivo = "datos_MDD/datos_prueba.txt";
    ifstream file(nombreArchivo);

    
    int dim = read_dimension(nombreArchivo);
    MDD instance(dim);
    instance.read_dimension(nombreArchivo);
    instance.leer_fichero(nombreArchivo);
    /*
    instance.mostrarDatos();
    vector<int> index = {0,1,2};
    float dis = instance.diff(index);
    cout << endl << "Distancia " << dis << endl;
    */
    vector<int> sol = instance.greedy();
    for(auto i : sol)
        cout << i << " ";
    cout << "Dispersion = " << instance.diff(sol) << endl;
    
    return 0;
}